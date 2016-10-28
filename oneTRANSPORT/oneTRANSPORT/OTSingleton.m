//
//  OTSingleton.m
//  oneTRANSPORT
//
//  Created by Dominic Frazer Imregh on 15/08/2016.
//  Copyright 2016 InterDigital Communications, Inc.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//    http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

#import "OTSingleton+Private.h"
#import "NSObject+Collection.h"
#import "OTOperationFinishedDownload.h"

#import "OTCoreData+Private.h"
#import "OTCoreDataVariableMessageSigns.h"
#import "OTCoreDataTraffic.h"
#import "OTCoreDataCarPark.h"
#import "OTCoreDataRoadworks.h"
#import "OTCoreDataEvent.h"
#import "OTCoreDataCommon.h"
#import "Common.h"

#import "OTCoreDataBitCarrierNode.h"
#import "OTCoreDataBitCarrierSketch.h"
#import "OTCoreDataBitCarrierVector.h"
#import "OTCoreDataBitCarrierTravel.h"
#import "OTCoreDataBitCarrierConfigVector.h"
#import "OTCoreDataClearViewDevice.h"
#import "OTCoreDataClearViewTraffic.h"

#import "BC_Node.h"
#import "BC_ConfigVector.h"
#import "BC_Travel.h"
#import "CV_Device.h"

@interface OTSingleton()

@property (nonatomic)         NSInteger       requestCount;

@property (nonatomic, strong) NSDate *timeStart;

@property (nonatomic, strong) NSOperationQueue *opQueue;

@end

@implementation OTSingleton

@synthesize common = _common;
@synthesize variableMS = _variableMS;
@synthesize trafficFlow = _trafficFlow;
@synthesize trafficQueue = _trafficQueue;
@synthesize trafficSpeed = _trafficSpeed;
@synthesize trafficScoot = _trafficScoot;
@synthesize trafficTime = _trafficTime;
@synthesize carParks = _carParks;
@synthesize roadworks = _roadworks;
@synthesize events = _events;
@synthesize bitCarrierNode = _bitCarrierNode;
@synthesize bitCarrierSketch = _bitCarrierSketch;
@synthesize bitCarrierVector = _bitCarrierVector;
@synthesize bitCarrierConfigVector = _bitCarrierConfigVector;
@synthesize bitCarrierTravel = _bitCarrierTravel;
@synthesize clearViewDevice = _clearViewDevice;
@synthesize clearViewTraffic = _clearViewTraffic;

#pragma mark Singleton Generation

+ (OTSingleton *)sharedInstance {
    
    static dispatch_once_t once;
    static id sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [self new];
        
    });
    return sharedInstance;
}

#pragma mark - Generate CSE

- (void)configureOneTransport:(NSString *)appId
                         auth:(NSString *)auth
                       origin:(NSString *)origin {

    NSString *baseUrl;
    switch ([[NSUserDefaults standardUserDefaults] integerForKey:kUserDefaultsCommsMode]) {
        case CommsTestDev:
            baseUrl = k_CSE_BASEURL_DEV;
            break;
        case CommsTestStaging:
            baseUrl = k_CSE_BASEURL_STAGING;
            break;
        default:
            baseUrl = k_CSE_BASEURL_LIVE;
            break;
    }
    [self configureCseWithBaseUrl:baseUrl
                            appId:appId
                       resourceId:k_CSE_ID
                     resourceName:k_CSE_NAME
                             auth:auth
                           origin:origin];
}

- (void)deleteCse {
    _cse = nil;
}

- (void)configureCseWithBaseUrl:(NSString *)baseUrl
                          appId:(NSString *)appId
                     resourceId:(NSString *)resourceId
                   resourceName:(NSString *)resourceName
                           auth:(NSString *)auth
                         origin:(NSString *)origin {
    
    if (_cse) {
        return;
    }
    _cse = [[OTCommonServicesEntity alloc] initWithBaseUrl:baseUrl appId:appId resourceId:resourceId resourceName:resourceName];
    
    if (_sessionTask == nil) {
        _sessionTask = [OTSessionTask new];
    }

    if (_coreData == nil) {
        _coreData = [[OTCoreData alloc] init];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.coreData managedObjectContext]; //initialise the MainThread MOC
        });
    }
    
    [_sessionTask setAuth:auth origin:origin];
    [_sessionTask setTimeOut:20 connections:1];
    
    _opQueue = [NSOperationQueue new];
    [_opQueue setMaxConcurrentOperationCount:1];

    [self checkFirstTimeUserDefaults];
}

- (void)checkFirstTimeUserDefaults {
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if ([userDefaults valueForKey:self.variableMS.userDefaultsUse] == nil) {
        [userDefaults setBool:true forKey:self.variableMS.userDefaultsUse];
        [userDefaults setBool:true forKey:self.trafficFlow.userDefaultsUse];
        [userDefaults setBool:true forKey:self.trafficQueue.userDefaultsUse];
        [userDefaults setBool:true forKey:self.trafficSpeed.userDefaultsUse];
        [userDefaults setBool:true forKey:self.trafficScoot.userDefaultsUse];
        [userDefaults setBool:true forKey:self.trafficTime.userDefaultsUse];
        [userDefaults setBool:true forKey:self.carParks.userDefaultsUse];
        [userDefaults setBool:true forKey:self.roadworks.userDefaultsUse];
        [userDefaults setBool:true forKey:self.events.userDefaultsUse];
        [userDefaults setBool:false forKey:self.bitCarrierNode.userDefaultsUse];
        [userDefaults setBool:false forKey:self.clearViewDevice.userDefaultsUse];
        [userDefaults setBool:true forKey:[self getUserDefault:LocalAuthorityBucks]];
        [userDefaults setBool:false forKey:[self getUserDefault:LocalAuthorityNorthants]];
        [userDefaults setBool:false forKey:[self getUserDefault:LocalAuthorityOxon]];
        [userDefaults setBool:false forKey:[self getUserDefault:LocalAuthorityHerts]];
        [userDefaults setBool:false forKey:[self getUserDefault:LocalAuthorityBirmingham]];

        [self setMaxHoursDataAge:4];
    }
}

- (OTApplicationEntity *)buildAeWithResourceId:(NSString *)resourceId resourceName:(NSString *)resourceName {
    
    if (_cse == nil) {
        return nil;
    }
    OTApplicationEntity *ae = [self.cse createAeWithId:resourceId name:resourceName];
    return ae;
}

#pragma mark - Lazy Loaders

- (OTCoreDataCommon *)common {
    
    if (_common == nil) {
        _common = [[OTCoreDataCommon alloc] initWithCoreData:_coreData];
    }
    return _common;
}

- (OTCoreDataVariableMessageSigns *)variableMS {
    
    if (_variableMS == nil) {
        _variableMS = [[OTCoreDataVariableMessageSigns alloc] initWithCoreData:_coreData];
    }
    return _variableMS;
}

- (OTCoreDataTrafficFlow *)trafficFlow {
    
    if (_trafficFlow == nil) {
        _trafficFlow = [[OTCoreDataTrafficFlow alloc] initWithCoreData:_coreData];
    }
    return _trafficFlow;
}

- (OTCoreDataTrafficQueue *)trafficQueue {
    
    if (_trafficQueue == nil) {
        _trafficQueue = [[OTCoreDataTrafficQueue alloc] initWithCoreData:_coreData];
    }
    return _trafficQueue;
}

- (OTCoreDataTrafficSpeed *)trafficSpeed {
    
    if (_trafficSpeed == nil) {
        _trafficSpeed = [[OTCoreDataTrafficSpeed alloc] initWithCoreData:_coreData];
    }
    return _trafficSpeed;
}

- (OTCoreDataTrafficScoot *)trafficScoot {
    
    if (_trafficScoot == nil) {
        _trafficScoot = [[OTCoreDataTrafficScoot alloc] initWithCoreData:_coreData];
    }
    return _trafficScoot;
}

- (OTCoreDataTrafficTime *)trafficTime {
    
    if (_trafficTime == nil) {
        _trafficTime = [[OTCoreDataTrafficTime alloc] initWithCoreData:_coreData];
    }
    return _trafficTime;
}

- (OTCoreDataCarPark *)carParks {
    
    if (_carParks == nil) {
        _carParks = [[OTCoreDataCarPark alloc] initWithCoreData:_coreData];
    }
    return _carParks;
}

- (OTCoreDataRoadworks *)roadworks {
    
    if (_roadworks == nil) {
        _roadworks = [[OTCoreDataRoadworks alloc] initWithCoreData:_coreData];
    }
    return _roadworks;
}

- (OTCoreDataEvent *)events {
    
    if (_events == nil) {
        _events = [[OTCoreDataEvent alloc] initWithCoreData:_coreData];
    }
    return _events;
}

- (OTCoreDataBitCarrierNode *)bitCarrierNode {
    
    if (_bitCarrierNode == nil) {
        _bitCarrierNode = [[OTCoreDataBitCarrierNode alloc] initWithCoreData:_coreData];
    }
    return _bitCarrierNode;
}

- (OTCoreDataBitCarrierSketch *)bitCarrierSketch {
    
    if (_bitCarrierSketch == nil) {
        _bitCarrierSketch = [[OTCoreDataBitCarrierSketch alloc] initWithCoreData:_coreData];
    }
    return _bitCarrierSketch;
}

- (OTCoreDataBitCarrierVector *)bitCarrierVector {
    
    if (_bitCarrierVector == nil) {
        _bitCarrierVector = [[OTCoreDataBitCarrierVector alloc] initWithCoreData:_coreData];
    }
    return _bitCarrierVector;
}

- (OTCoreDataBitCarrierConfigVector *)bitCarrierConfigVector {
    
    if (_bitCarrierConfigVector == nil) {
        _bitCarrierConfigVector = [[OTCoreDataBitCarrierConfigVector alloc] initWithCoreData:_coreData];
    }
    return _bitCarrierConfigVector;
}

- (OTCoreDataBitCarrierTravel *)bitCarrierTravel {
    
    if (_bitCarrierTravel == nil) {
        _bitCarrierTravel = [[OTCoreDataBitCarrierTravel alloc] initWithCoreData:_coreData];
    }
    return _bitCarrierTravel;
}

- (OTCoreDataClearViewDevice *)clearViewDevice {
    
    if (_clearViewDevice == nil) {
        _clearViewDevice = [[OTCoreDataClearViewDevice alloc] initWithCoreData:_coreData];
    }
    return _clearViewDevice;
}

- (OTCoreDataClearViewTraffic *)clearViewTraffic {
    
    if (_clearViewTraffic == nil) {
        _clearViewTraffic = [[OTCoreDataClearViewTraffic alloc] initWithCoreData:_coreData];
    }
    return _clearViewTraffic;
}

#pragma mark - Helpers

- (OTCoreDataBase *)getObjectClass:(ObjectType)type {

    switch (type) {
        case ObjectTypeVariableMessageSigns:
            return self.variableMS;
        case ObjectTypeTrafficFlow:
            return self.trafficFlow;
        case ObjectTypeTrafficQueue:
            return self.trafficQueue;
        case ObjectTypeTrafficSpeed:
            return self.trafficSpeed;
        case ObjectTypeTrafficScoot:
            return self.trafficScoot;
        case ObjectTypeTrafficTime:
            return self.trafficTime;
        case ObjectTypeCarParks:
            return self.carParks;
        case ObjectTypeRoadworks:
            return self.roadworks;
        case ObjectTypeEvents:
            return self.events;
        case ObjectTypeBitCarrier:
            return self.bitCarrierNode;
        case ObjectTypeClearView:
            return self.clearViewDevice;
    }
    return self.variableMS;
}

- (NSString *)getAuthorityAeId:(LocalAuthority)la {
    
    switch (la) {
        case LocalAuthorityBucks:
            return k_AE_ID_Bucks;
        case LocalAuthorityNorthants:
            return k_AE_ID_Northants;
        case LocalAuthorityOxon:
            return k_AE_ID_Oxon;
        case LocalAuthorityHerts:
            return k_AE_ID_Herts;
        case LocalAuthorityBirmingham:
            return k_AE_ID_Birmingham;
        default:
            break;
    }
    return @"";
}

- (NSString *)getUserDefault:(LocalAuthority)la {
    
    switch (la) {
        case LocalAuthorityBucks:
            return kUserDefaultsLA_Bucks;
        case LocalAuthorityNorthants:
            return kUserDefaultsLA_Northants;
        case LocalAuthorityOxon:
            return kUserDefaultsLA_Oxon;
        case LocalAuthorityHerts:
            return kUserDefaultsLA_Herts;
        case LocalAuthorityBirmingham:
            return kUserDefaultsLA_Birmingham;
        default:
            break;
    }
    return @"";
}

- (NSString *)getContainerId:(ContainerType)cnt {
    
    switch (cnt) {
        case ContainerTypeVariableMessageSigns:
            return k_CNT_VariableMS;
        case ContainerTypeTrafficFlow:
            return k_CNT_TrafficFlow;
        case ContainerTypeTrafficQueue:
            return k_CNT_TrafficQueue;
        case ContainerTypeTrafficSpeed:
            return k_CNT_TrafficSpeed;
        case ContainerTypeTrafficScoot:
            return k_CNT_TrafficScoot;
        case ContainerTypeTrafficTime:
            return k_CNT_TrafficTime;
        case ContainerTypeCarParks:
            return k_CNT_CarPark;
        case ContainerTypeRoadWorks:
            return k_CNT_Roadworks;
        case ContainerTypeEvents:
            return k_CNT_Event;
        default:
            break;
    }
    return @"";
}

- (OTCoreDataBase *)getCntObject:(ContainerType)cnt {
    
    switch (cnt) {
        case ContainerTypeVariableMessageSigns:
            return self.variableMS;
        case ContainerTypeTrafficFlow:
            return self.trafficFlow;
        case ContainerTypeTrafficQueue:
            return self.trafficQueue;
        case ContainerTypeTrafficSpeed:
            return self.trafficSpeed;
        case ContainerTypeTrafficScoot:
            return self.trafficScoot;
        case ContainerTypeTrafficTime:
            return self.trafficTime;
        case ContainerTypeCarParks:
            return self.carParks;
        case ContainerTypeRoadWorks:
            return self.roadworks;
        case ContainerTypeEvents:
            return self.events;
        default:
            break;
    }
    return nil;
}

#pragma mark - User Defaults

- (void)setMaxHoursDataAge:(NSInteger)hours {

    if (hours < 0) {
        hours = 0;
    }
    
    [[NSUserDefaults standardUserDefaults] setInteger:hours forKey:kUserDefaultsDataAge];
}

- (void)setKph:(BOOL)kph {
    
    [[NSUserDefaults standardUserDefaults] setBool:kph forKey:kUserDefaultsKph];
}

- (BOOL)isKph {
    
    return [[NSUserDefaults standardUserDefaults] boolForKey:kUserDefaultsKph];
}

- (void)setTrace:(BOOL)trace {

    [[NSUserDefaults standardUserDefaults] setBool:trace forKey:kKeyUserDefaults_Trace];
}

- (BOOL)isTrace {
    
    return [[NSUserDefaults standardUserDefaults] boolForKey:kKeyUserDefaults_Trace];
}

- (void)setDataImportFilterMin:(CLLocationCoordinate2D)min max:(CLLocationCoordinate2D)max {
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    [userDefaults setDouble:min.latitude forKey:kUserDefaultsMinLat];
    [userDefaults setDouble:min.longitude forKey:kUserDefaultsMinLon];
    [userDefaults setDouble:max.latitude forKey:kUserDefaultsMaxLat];
    [userDefaults setDouble:max.longitude forKey:kUserDefaultsMaxLon];
}

- (void)clearDataImportFilter {
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    [userDefaults setObject:nil forKey:kUserDefaultsMinLat];
    [userDefaults setObject:nil forKey:kUserDefaultsMinLon];
    [userDefaults setObject:nil forKey:kUserDefaultsMaxLat];
    [userDefaults setObject:nil forKey:kUserDefaultsMaxLon];
}

- (CLLocationCoordinate2D)getMinImportFilter {

    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];

    if ([userDefaults objectForKey:kUserDefaultsMinLat] == nil) {
        return CLLocationCoordinate2DMake(EmptyLatLonMinLat, EmptyLatLonMinLon);
    } else {
        return CLLocationCoordinate2DMake([userDefaults doubleForKey:kUserDefaultsMinLat], [userDefaults doubleForKey:kUserDefaultsMinLon]);
    }
}

- (CLLocationCoordinate2D)getMaxImportFilter {
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    if ([userDefaults objectForKey:kUserDefaultsMaxLat] == nil) {
        return CLLocationCoordinate2DMake(EmptyLatLonMaxLat, EmptyLatLonMaxLon);
    } else {
        return CLLocationCoordinate2DMake([userDefaults doubleForKey:kUserDefaultsMaxLat], [userDefaults doubleForKey:kUserDefaultsMaxLon]);
    }
}

#pragma mark - Common data processing

- (void)requestData:(LocalAuthority)la container:(ContainerType)cn completion:(CompletionType)completionBlock {
    
    NSString *ae = [self getAuthorityAeId:la];
    NSString *cnt = [self getContainerId:cn];
    OTCoreDataBase *object = [self getCntObject:cn];
    [self request:ae cnt:cnt object:object subMethod:SubCommandTypeLatest completion:completionBlock];
}

- (void)requestData:(CompletionType)completionBlock {
    
    if (_requestCount > 0) {
        return;
    }

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        self.timeStart = [NSDate date];
        
        NSArray *arrayCNT = @[@(ContainerTypeVariableMessageSigns),
                              @(ContainerTypeTrafficFlow), @(ContainerTypeTrafficQueue), @(ContainerTypeTrafficSpeed),
                              @(ContainerTypeTrafficScoot), @(ContainerTypeTrafficTime),
                              @(ContainerTypeCarParks), @(ContainerTypeRoadWorks), @(ContainerTypeEvents)];
        NSArray *arrayTypes = @[@(LocalAuthorityBucks), @(LocalAuthorityNorthants), @(LocalAuthorityOxon), @(LocalAuthorityHerts), @(LocalAuthorityBirmingham)];
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        for (NSInteger i=0 ;i<arrayTypes.count; i++) {
            LocalAuthority la = (LocalAuthority)[arrayTypes[i] integerValue];
            NSString *userDef = [self getUserDefault:la];
            NSString *ae = [self getAuthorityAeId:la];
            
            if ([userDefaults boolForKey:userDef]) {
                for (NSInteger j=0 ;j<arrayCNT.count; j++) {
                    ContainerType cType = (ContainerType)[arrayCNT[j] integerValue];
                    id object = [self getCntObject:cType];
                    NSString *cnt = [self getContainerId:cType];
                    
                    if ([object isAllowedToMakeRequest:la]) {
                        [self request:ae cnt:cnt object:object subMethod:SubCommandTypeLatest completion:completionBlock];
                    }
                }
            }
        }

        if ([userDefaults boolForKey:self.bitCarrierVector.userDefaultsUse]) {
            [self requestBitCarrierVectors:completionBlock];
        }
        if ([userDefaults boolForKey:self.bitCarrierTravel.userDefaultsUse]) {
            [self requestBitCarrierTravel:completionBlock];
        }
        if ([userDefaults boolForKey:self.clearViewTraffic.userDefaultsUse]) {
            [self requestClearViewTraffic:completionBlock];
        }

        if (_requestCount == 0) {
            completionBlock(nil, nil);
        }
    });
}

- (void)request:(NSString *)aeId
            cnt:(NSString *)cnt
         object:(OTCoreDataBase *)object
      subMethod:(SubCommandType)subMethod
     completion:(CompletionType)completion {

    [self request:aeId cnt:cnt object:object subMethod:subMethod reference:nil completion:completion];
}

- (void)request:(NSString *)aeId
            cnt:(NSString *)cnt
         object:(OTCoreDataBase *)object
      subMethod:(SubCommandType)subMethod
      reference:(NSString *)reference
     completion:(CompletionType)completion {
    
    if (_arrayChanges == nil) {
        _arrayChanges = [NSMutableArray new];
    }

    _requestCount++;

    [self buildAeWithResourceId:aeId resourceName:aeId];
    __block OTContainer *container = [[_cse aeWithId:aeId] createContainerWithName:cnt];
    
    CompletionType completionBlock = ^(NSDictionary *response, NSError *error) {
    
        OTOperationFinishedDownload *op = [OTOperationFinishedDownload new];
        [op configure:container
               object:object
            reference:reference
             response:response error:error
           completion:completion];

        [_opQueue addOperation:op];
    };
    
    if (!reference) {
        [object removeOld];
    }
    [container remoteRequest:CommandTypeGet subMethod:subMethod session:_sessionTask completionBlock:completionBlock];
}

- (void)requestBitCarrierVectors:(CompletionType)completionBlock {

    NSArray *arrayVectors = [self.bitCarrierConfigVector retrieveAll:nil];
    for (BC_ConfigVector *vector in arrayVectors) {
        NSString *path = [NSString stringWithFormat:@"BitCarrier/v1.0/InterdigitalDemo/silverstone/data/vectors/v%@", vector.reference];
        [self request:k_AE_ID_BitCarrier cnt:path object:self.bitCarrierVector subMethod:SubCommandTypeLatest reference:nil completion:completionBlock];
    }
}

- (void)requestBitCarrierTravel:(CompletionType)completionBlock {
    
    _requestCount++;

    [self buildAeWithResourceId:k_AE_ID_BitCarrier resourceName:k_AE_ID_BitCarrier];
    __block OTContainer *container = [[_cse aeWithId:k_AE_ID_BitCarrier] createContainerWithName:@"BitCarrier/v1.0/InterdigitalDemo/silverstone/data/traveltimes"];
    
    CompletionType completion = ^(NSDictionary *response, NSError *error) {
        NSDictionary *dictCnt = [NSObject validateDictionary:response[@"m2m:cnt"]];
        if (dictCnt) {
            NSArray *arrayCh = dictCnt[@"ch"];
            if (arrayCh) {
                for (NSDictionary *item in arrayCh) {
                    NSString *travelCnt = item[@"-nm"];
                    NSString *path = [NSString stringWithFormat:@"BitCarrier/v1.0/InterdigitalDemo/silverstone/data/traveltimes/%@", travelCnt];
                    [self request:k_AE_ID_BitCarrier cnt:path object:self.bitCarrierTravel subMethod:SubCommandTypeLatest reference:nil completion:completionBlock];
                }
            }
        }
        [self decrementRequestCount:error completion:completion];
    };
    [container remoteRequest:CommandTypeDiscoverViaRcn subMethod:SubCommandTypeNone session:_sessionTask completionBlock:completion];
}

- (void)requestClearViewTraffic:(CompletionType)completionBlock {
    
    NSArray *arrayDevices = [self.clearViewDevice retrieveAll:nil];
    if (arrayDevices.count == 0) {
        NSLog(@"No devices in the array");
    } else {
        for (CV_Device *device in arrayDevices) {
            NSString *path = [NSString stringWithFormat:@"DEVICE_%@", device.reference];
            [self request:k_AE_ID_ClearView cnt:path object:self.clearViewTraffic subMethod:SubCommandTypeLatest reference:device.reference completion:completionBlock];
        }
    }
}

- (void)decrementRequestCount:(NSError *)error completion:(CompletionType)completion {
    
    _requestCount -= 1;
    
    NSLog(@"Decrement %zd", self.requestCount);
    NSLog(@"Time %.2f", [[NSDate date] timeIntervalSinceDate:self.timeStart]);

    if (_requestCount == 0) {
        NSMutableArray *arrayChangesFavourite = [NSMutableArray new];
        for (id object in self.arrayChanges) {
            NSString *reference = nil;
            ObjectType type = ObjectTypeVariableMessageSigns;
            if ([object isKindOfClass:[VariableMessageSigns class]]) {
                reference = ((VariableMessageSigns *)object).reference;
                type = ObjectTypeVariableMessageSigns;
            } else if ([object isKindOfClass:[TrafficFlow class]]) {
                reference = ((TrafficFlow *)object).reference;
                type = ObjectTypeTrafficFlow;
            } else if ([object isKindOfClass:[TrafficQueue class]]) {
                reference = ((TrafficQueue *)object).reference;
                type = ObjectTypeTrafficQueue;
            } else if ([object isKindOfClass:[TrafficSpeed class]]) {
                reference = ((TrafficSpeed *)object).reference;
                type = ObjectTypeTrafficSpeed;
            } else if ([object isKindOfClass:[TrafficScoot class]]) {
                reference = ((TrafficScoot *)object).reference;
                type = ObjectTypeTrafficScoot;
            } else if ([object isKindOfClass:[TrafficTime class]]) {
                reference = ((TrafficTime *)object).reference;
                type = ObjectTypeTrafficTime;
            } else if ([object isKindOfClass:[CarParks class]]) {
                reference = ((CarParks *)object).reference;
                type = ObjectTypeCarParks;
            } else if ([object isKindOfClass:[Roadworks class]]) {
                reference = ((Roadworks *)object).reference;
                type = ObjectTypeRoadworks;
            } else if ([object isKindOfClass:[BC_Node class]]) {
                reference = ((BC_Node *)object).reference;
                type = ObjectTypeBitCarrier;
            } else if ([object isKindOfClass:[CV_Device class]]) {
                reference = ((CV_Device *)object).reference;
                type = ObjectTypeClearView;
            }
            
            if (reference) {
                if ([self.common isFavourite:reference type:type]) {
                    [arrayChangesFavourite addObject:object];
                }
            }
        }
        
        NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:[self.arrayChanges copy], kResponseChangesAll,
                              arrayChangesFavourite, kResponseChangesFavourites,
                              nil];
        
        [self.arrayChanges removeAllObjects];
        [self purgeOrphanedCommon];
        
        NSLog(@">>>>>>>>>>>>>>>");
        NSLog(@"Time %.2f", [[NSDate date] timeIntervalSinceDate:self.timeStart]);
        NSLog(@">>>>>>>>>>>>>>>");

        completion(dict, error);

        NSLog(@"Completion %.2f", [[NSDate date] timeIntervalSinceDate:self.timeStart]);
        NSLog(@">>>>>>>>>>>>>>>");
    }
}

- (void)purgeOrphanedCommon {
    
    NSManagedObjectContext *moc = [self.coreData managedObjectContext];
    
    NSArray *arrayCommon = [self.common retrieveAll:nil];
    for (Common *common in arrayCommon) {
        NSArray *arraySub;
        if ([common.type isEqualToString:self.variableMS.dataType]) {
            arraySub = [self.variableMS retrieveHistory:common.reference];
        } else if ([common.type isEqualToString:self.trafficFlow.dataType]) {
            arraySub = [self.trafficFlow retrieveHistory:common.reference];
        } else if ([common.type isEqualToString:self.trafficQueue.dataType]) {
            arraySub = [self.trafficQueue retrieveHistory:common.reference];
        } else if ([common.type isEqualToString:self.trafficSpeed.dataType]) {
            arraySub = [self.trafficSpeed retrieveHistory:common.reference];
        } else if ([common.type isEqualToString:self.trafficScoot.dataType]) {
            arraySub = [self.trafficScoot retrieveHistory:common.reference];
        } else if ([common.type isEqualToString:self.trafficTime.dataType]) {
            arraySub = [self.trafficTime retrieveHistory:common.reference];
        } else if ([common.type isEqualToString:self.carParks.dataType]) {
            arraySub = [self.carParks retrieveHistory:common.reference];
        } else if ([common.type isEqualToString:self.roadworks.dataType]) {
            arraySub = [self.roadworks retrieveHistory:common.reference];
        } else if ([common.type isEqualToString:self.events.dataType]) {
            arraySub = [self.events retrieveHistory:common.reference];
        } else if ([common.type isEqualToString:self.bitCarrierNode.dataType]) {
//            arraySub = [self.bitCarrierTravel retrieveHistory:common.reference];
        } else if ([common.type isEqualToString:self.clearViewDevice.dataType]) {
            arraySub = [self.clearViewTraffic retrieveHistory:common.reference];
        }
        
        if (arraySub.count == 0) {
            [moc deleteObject:common];
        }
    }
    [self.coreData saveContext];
}

- (void)removeAll:(PopulateBlock)completion {
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{

        NSArray *array = @[self.common, self.variableMS,
                           self.trafficFlow, self.trafficQueue, self.trafficSpeed, self.trafficScoot, self.trafficTime,
                           self.carParks, self.roadworks, self.events,
                           self.bitCarrierNode, self.bitCarrierSketch, self.bitCarrierVector, self.bitCarrierConfigVector, self.bitCarrierTravel,
                           self.clearViewDevice, self.clearViewTraffic];
        for (OTCoreDataBase *object in array) {
            [object removeAll];
            dispatch_async(dispatch_get_main_queue(), ^{
                completion(false);
            });
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(true);
        });
    });
}

@end

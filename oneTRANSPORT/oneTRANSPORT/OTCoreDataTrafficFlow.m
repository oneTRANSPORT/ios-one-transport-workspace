//
//  OTCoreDataTrafficFlow.m
//  oneTRANSPORT
//
//  Created by Dominic Frazer Imregh on 07/10/2016.
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

#import "OTCoreDataTrafficFlow.h"
#import "OTCoreDataTraffic+Private.h"
#import "OTCoreData+Private.h"
#import "NSObject+Collection.h"
#import "OTTransportTypes.h"
#import "OTCoreDataBase+Private.h"

@implementation OTCoreDataTrafficFlow

- (instancetype)initWithCoreData:(id)parent {
    
    if (self = [super initWithCoreData:parent]) {
        self.entityName = kCoreDataEntityTrafficFlow;
        self.dataType = k_CommonType_TrafficFlow;
        self.userDefaultsUse = @"oneT_UserDefaultsTrafficFlow";
    }
    return self;
}

- (NSArray *)populateTableWith:(id)data timestamp:(NSDate *)date {
    
    NSMutableArray <NSDictionary *> *arrayCommon = [NSMutableArray new];
    [self setImportFilter];
    
    NSError *error = nil;
    NSManagedObjectContext *moc = [self.coreData managedObjectContext];
    [moc refreshAllObjects];
    
    TrafficFlow *object;
    
    NSPredicate *predicate;
    NSFetchRequest *fetchRequest = [self getFetchRequest];
    [fetchRequest setFetchLimit:1];
    
    NSArray *array = data;
    for (NSDictionary *item in array) {
        NSString *reference = [NSObject validateString:item[@"id"]];
        if (reference.length == 0) {
            continue;
        }
        
        NSNumber *latitude;
        NSNumber *longitude;
        [self setupLat:&latitude lon:&longitude from:item];        
        if (![self validForImport:latitude lon:longitude]) {
            NSLog(@"Failed lat/lon for %@, %@", reference, self);
        } else {
            NSDate *timestamp = [self dateFromString:item[@"time"]];
            
            predicate = [NSPredicate predicateWithFormat:@"reference == %@ && timestamp == %@", reference, timestamp];
            [fetchRequest setPredicate:predicate];
            NSSortDescriptor *sort1 = [[NSSortDescriptor alloc] initWithKey:@"timestamp" ascending:false];
            [fetchRequest setSortDescriptors:@[sort1]];
            
            NSArray *arrayExisting = [moc executeFetchRequest:fetchRequest error:&error];
            if ([arrayExisting count] == 0) {
                object = [NSEntityDescription insertNewObjectForEntityForName:self.entityName inManagedObjectContext:moc];
                object.reference          = reference;
                object.timestamp          = timestamp;
                object.vehicleFlow        = [NSObject validateNumberInt:item[@"vehicleFlow"]];

                    /*
                     freeFlowSpeed = 0;
                     freeFlowTravelTime = 0;
                     fromDescriptor = "A63 westbound from A1105 to M62 then M62 westbound from Jct 38(A63) to Jct 35(M18 J7)";
                     fromLatitude = 0;
                     fromLongitude = 0;
                     fromType = junctionName;
                     id = SECTION10817;
                     time = "2016-09-21T18:47:55+01:00";
                     toDescriptor = "A63 westbound from A1105 to M62 then M62 westbound from Jct 38(A63) to Jct 35(M18 J7)";
                     toLatitude = 0;
                     toLongitude = 0;
                     toType = junctionName;
                     tpegDirection = westBound;
                     travelTime = 1168;
                     */
                
                NSMutableDictionary *dict = [self buildCommon:item lat:latitude lon:longitude];
                [dict setValue:date forKey:kCommonTimestamp];
                [dict setValue:@(object.localizedCounter) forKey:kCommonCounter1];
                [arrayCommon addObject:dict];
            }
        }
    }
    [self.coreData saveContext];
    [self setTimestamp:date];
    
    return arrayCommon;
}

- (NSArray *)checkForChanges:(NSArray <NSDictionary *> *)arrayCommon {
    
    NSMutableArray <NSDictionary *> *arrayChanges = [NSMutableArray new];
    
    for (NSDictionary *item in arrayCommon) {
        NSString *reference = [NSObject validateString:item[kCommonReference]];
        NSArray *history = [self retrieveHistory:reference];
        if (history.count >= 2) {
            TrafficFlow *historyItem1 = history[0];
            TrafficFlow *historyItem2 = history[1];
            if (historyItem1.vehicleFlow.integerValue != historyItem2.vehicleFlow.integerValue) {
                [arrayChanges addObject:item];
            }
        } else {
            [arrayChanges addObject:item];
        }
    }
    
    return arrayChanges;
}

- (NSArray <TrafficFlow *> *)retrieveAll:(BOOL)activeOnly {
    
    NSPredicate *predicate = nil;
    if (activeOnly) {
        predicate = [NSPredicate predicateWithFormat:@"vehicleFlow != 0"];
    }
    return [super retrieveAll:predicate];
}

- (NSArray <TrafficFlow *> *)retrieveHistory:(NSString *)reference {
    
    return [super retrieveHistory:reference];
}

@end

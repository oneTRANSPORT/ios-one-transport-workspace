//
//  OTCoreDataTrafficSpeed.m
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

#import "OTCoreDataTrafficSpeed.h"
#import "OTCoreDataTraffic+Private.h"
#import "OTCoreData+Private.h"
#import "NSObject+Collection.h"
#import "OTTransportTypes.h"
#import "OTCoreDataBase+Private.h"

@implementation OTCoreDataTrafficSpeed

- (instancetype)initWithCoreData:(id)parent {
    
    if (self = [super initWithCoreData:parent]) {
        self.entityName = kCoreDataEntityTrafficSpeed;
        self.dataType = k_CommonType_TrafficSpeed;
        self.userDefaultsUse = @"oneT_UserDefaultsTrafficSpeed";
    }
    return self;
}

- (BOOL)isAllowedToMakeRequest:(LocalAuthority)la {
    
    return [super isAllowedToMakeRequest:la] && (la == LocalAuthorityBucks || la == LocalAuthorityOxon || la == LocalAuthorityHerts || la == LocalAuthorityBirmingham);
}

- (NSArray *)populateTableWith:(id)data timestamp:(NSDate *)date {
    
    NSMutableArray <NSDictionary *> *arrayCommon = [NSMutableArray new];
    [self setImportFilter];
    
    NSError *error = nil;
    NSManagedObjectContext *moc = [self.coreData managedObjectContext];
    [moc refreshAllObjects];
    
    TrafficSpeed *object;
    
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
        if ([self validForImport:latitude lon:longitude]) {
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
                object.averageVehicleSpeed = [NSObject validateNumberInt:item[@"averageVehicleSpeed"]];

                    /*
                     averageVehicleSpeed = "65.983";
                     fromDescriptor = "A418 Rowsham";
                     fromLatitude = "51.5694466";
                     fromLongitude = "-0.5055608";
                     fromType = junctionName;
                     id = "LINKBUCK-36N1";
                     time = "2012-03-25T05:00:00+01:00";
                     toDescriptor = "A418 Rowsham";
                     toLatitude = "51.8544";
                     toLongitude = "-0.7164059";
                     toType = junctionName;
                     tpegDirection = other;
                     */
                
                NSMutableDictionary *dict = [self buildCommon:item lat:latitude lon:longitude];
                [dict setValue:date forKey:kCommonTimestamp];
                [dict setValue:@(object.localizedCounter) forKey:kCommonCounter1];
                [arrayCommon addObject:dict];
            }
        } else {
            NSLog(@"Speed - outside range for lat / lon \n%@", item);
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
            TrafficSpeed *historyItem1 = history[0];
            TrafficSpeed *historyItem2 = history[1];
            if (historyItem1.averageVehicleSpeed.integerValue != historyItem2.averageVehicleSpeed.integerValue) {
                [arrayChanges addObject:item];
            }
        } else {
            [arrayChanges addObject:item];
        }
    }
    
    return arrayChanges;
}

- (NSArray <TrafficSpeed *> *)retrieveAll:(BOOL)activeOnly {
    
    NSPredicate *predicate = nil;
    if (activeOnly) {
        predicate = [NSPredicate predicateWithFormat:@"averageVehicleSpeed != 0"];
    }
    return [super retrieveAll:predicate];
}

- (NSArray <TrafficSpeed *> *)retrieveHistory:(NSString *)reference {
    
    return [super retrieveHistory:reference];
}

@end

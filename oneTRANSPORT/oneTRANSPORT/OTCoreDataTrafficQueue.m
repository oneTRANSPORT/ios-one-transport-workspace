//
//  OTCoreDataTrafficQueue.m
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

#import "OTCoreDataTrafficQueue.h"
#import "OTCoreDataTraffic+Private.h"
#import "OTCoreData+Private.h"
#import "NSObject+Collection.h"
#import "OTTransportTypes.h"
#import "OTCoreDataBase+Private.h"

@implementation OTCoreDataTrafficQueue

- (instancetype)initWithCoreData:(id)parent {
    
    if (self = [super initWithCoreData:parent]) {
        self.entityName = kCoreDataEntityTrafficQueue;
        self.dataType = k_CommonType_TrafficQueue;
        self.userDefaultsUse = @"oneT_UserDefaultsTrafficQueue";
    }
    return self;
}

- (BOOL)isAllowedToMakeRequest:(LocalAuthority)la {
    
    return [super isAllowedToMakeRequest:la] && (la == LocalAuthorityBucks || la == LocalAuthorityOxon);
}

- (NSArray *)populateTableWith:(id)data timestamp:(NSDate *)date {
    
    NSMutableArray <NSDictionary *> *arrayCommon = [NSMutableArray new];
    [self setImportFilter];
    
    NSError *error = nil;
    NSManagedObjectContext *moc = [self.coreData managedObjectContext];
    [moc refreshAllObjects];
    
    TrafficQueue *object;
    
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
                object.present = [NSObject validateString:item[@"present"]];
                object.severity = [NSObject validateNumberInt:item[@"severity"]];

                    /*
                     fromDescriptor = "C171 Coldharbour";
                     fromLatitude = "51.8105049";
                     fromLongitude = "-0.8357463000000001";
                     fromType = junctionName;
                     id = "LINKBUCK-61NW1";
                     present = N;
                     severity = 0;
                     time = "2012-03-25T04:05:00+01:00";
                     toDescriptor = "C171 Coldharbour";
                     toLatitude = "51.8105049";
                     toLongitude = "-0.8357463000000001";
                     toType = junctionName;
                     tpegDirection = other;
                     */
                
                NSMutableDictionary *dict = [self buildCommon:item lat:latitude lon:longitude];
                [dict setValue:date forKey:kCommonTimestamp];
                [dict setValue:@(object.localizedCounter) forKey:kCommonCounter1];
                [arrayCommon addObject:dict];
            }
//        } else {
//            NSLog(@"Queue - outside range for lat / lon \n%@", item);
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
            TrafficQueue *historyItem1 = history[0];
            TrafficQueue *historyItem2 = history[1];
            if (historyItem1.severity.integerValue != historyItem2.severity.integerValue) {
                [arrayChanges addObject:item];
            }
        } else {
            [arrayChanges addObject:item];
        }
    }
    
    return arrayChanges;
}

- (NSArray <TrafficQueue *> *)retrieveAll:(BOOL)activeOnly {
    
    NSPredicate *predicate = nil;
    if (activeOnly) {
        predicate = [NSPredicate predicateWithFormat:@"severity != 0"];
    }
    return [super retrieveAll:predicate];
}

- (NSArray <TrafficQueue *> *)retrieveHistory:(NSString *)reference {
    
    return [super retrieveHistory:reference];
}

@end

//
//  OTCoreDataCarPark.m
//  oneTRANSPORT
//
//  Created by Dominic Frazer Imregh on 16/08/2016.
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

#import "OTCoreDataCarPark.h"
#import "OTCoreData+Private.h"
#import "NSObject+Collection.h"
#import "OTTransportTypes.h"
#import "OTCoreDataBase+Private.h"

@implementation OTCoreDataCarPark

- (instancetype)initWithCoreData:(id)parent {
    
    if (self = [super initWithCoreData:parent]) {
        self.entityName = kCoreDataEntityCarParks;
        self.userDefaultsCurrentData = kUserDefaultsStampCarParks;
        self.dataType = k_CommonType_CarParks;
        self.userDefaultsUse = @"oneT_UserDefaultsCarParks";
    }
    return self;
}

- (NSArray *)populateTableWith:(id)data timestamp:(NSDate *)date {
    
    NSMutableArray <NSDictionary *> *arrayCommon = [NSMutableArray new];
    [self setImportFilter];

    NSError *error = nil;
    NSManagedObjectContext *moc = [self.coreData managedObjectContext];
    [moc refreshAllObjects];
    
    CarParks *object;
    
    NSPredicate *predicate;
    NSFetchRequest *fetchRequest = [self getFetchRequest];
    [fetchRequest setFetchLimit:1];
    
    NSArray *array = data;
    for (NSDictionary *item in array) {
        NSString *reference = [NSObject validateString:item[@"carParkIdentity"]];
        NSNumber *latitude;
        NSNumber *longitude;
        [self setupLat:&latitude lon:&longitude from:item];
        if (![self validForImport:latitude lon:longitude]) {
            NSLog(@"Failed lat/lon for %@, %@", reference, self);
        } else {
            predicate = [NSPredicate predicateWithFormat:@"reference == %@ && timestamp == %@", reference, date];
            [fetchRequest setPredicate:predicate];
            NSSortDescriptor *sort1 = [[NSSortDescriptor alloc] initWithKey:@"timestamp" ascending:false];
            [fetchRequest setSortDescriptors:@[sort1]];

            NSArray *arrayExisting = [moc executeFetchRequest:fetchRequest error:&error];
            if ([arrayExisting count] == 0) {
                object = [NSEntityDescription insertNewObjectForEntityForName:self.entityName inManagedObjectContext:moc];
                object.reference          = reference;
                object.timestamp          = date;
            
                NSString *title = [NSObject validateString:item[@"parkingAreaName"]];
                if (title.length == 0) {
                    title = [NSObject validateString:item[@"description"]];
                }
                object.capacity           = [NSObject validateNumberInt:item[@"totalParkingCapacity"]];
                object.spacesAvailable    = [NSObject validateNumberInt:item[@"spacesAvailable"]];
                object.rateExit           = [NSObject validateNumberInt:item[@"exitRate"]];
                object.rateFill           = [NSObject validateNumberInt:item[@"fillRate"]];
                object.almostFullDec      = [NSObject validateNumberInt:item[@"almostFullDecreasing"]];
                object.almostFullInc      = [NSObject validateNumberInt:item[@"almostFullIncreasing"]];
                object.fullDec            = [NSObject validateNumberInt:item[@"fullDecreasing"]];
                object.fullInc            = [NSObject validateNumberInt:item[@"fullIncreasing"]];
                object.full               = [NSObject validateNumberInt:item[@"entranceFull"]];
                object.occupancy          = [NSObject validateNumberInt:item[@"occupancy"]];
                object.queuingTime        = [NSObject validateNumberInt:item[@"queuingTime"]];
                object.status             = [NSObject validateString:item[@"status"]];
                object.occupancyTrend     = [NSObject validateString:item[@"occupancyTrend"]];
                
                NSMutableDictionary *dict = [NSMutableDictionary new];
                [dict setValue:reference forKey:kCommonReference];
                [dict setValue:title forKey:kCommonTitle];
                [dict setValue:latitude forKey:kCommonLat];
                [dict setValue:longitude forKey:kCommonLon];
                [dict setValue:object.timestamp forKey:kCommonTimestamp];
                [dict setValue:@(object.localizedCounter) forKey:kCommonCounter1];
                [dict setValue:@(object.localizedCounterSub) forKey:kCommonCounter2];
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
        NSDate *timestamp = item[kCommonTimestamp];
        
        NSArray *history = [self retrieveHistory:reference];
        if (history.count >= 2) {
            CarParks *historyItem1 = history[0];
            if ([historyItem1.timestamp timeIntervalSinceDate:timestamp] == 0) {    //first date is current batch
                CarParks *historyItem2 = history[1];
                if (historyItem1.full.boolValue != historyItem2.full.boolValue) {
                    [arrayChanges addObject:item];
                }
            }
        } else {
            [arrayChanges addObject:item];
        }
    }
    
    return arrayChanges;
}

- (NSArray <CarParks *> *)retrieveAll:(BOOL)activeOnly {

    NSPredicate *predicate = nil;
    if (activeOnly) {
        predicate = [NSPredicate predicateWithFormat:@"full == 0"];
    }
    return [super retrieveAll:predicate];
}

- (NSArray <CarParks *> *)retrieveHistory:(NSString *)reference {
    
    return [super retrieveHistory:reference];
}

@end

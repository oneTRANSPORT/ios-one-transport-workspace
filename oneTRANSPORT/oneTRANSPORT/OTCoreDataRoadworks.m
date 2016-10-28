//
//  OTCoreDataRoadworks.m
//  oneTRANSPORT
//
//  Created by Dominic Frazer Imregh on 18/08/2016.
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

#import "OTCoreDataRoadworks.h"
#import "OTCoreData+Private.h"
#import "NSObject+Collection.h"
#import "OTTransportTypes.h"
#import "OTCoreDataBase+Private.h"

@implementation OTCoreDataRoadworks

- (instancetype)initWithCoreData:(id)parent {
    
    if (self = [super initWithCoreData:parent]) {
        self.entityName = kCoreDataEntityRoadworks;
        self.userDefaultsCurrentData = kUserDefaultsStampRoadworks;
        self.dataType = k_CommonType_Roadworks;
        self.userDefaultsUse = @"oneT_UserDefaultsRoadWorks";
    }
    return self;
}

- (NSArray *)populateTableWith:(NSArray *)array timestamp:(NSDate *)date {
    
    NSMutableArray <NSDictionary *> *arrayCommon = [NSMutableArray new];
    [self setImportFilter];

    NSError *error = nil;
    NSManagedObjectContext *moc = [self.coreData managedObjectContext];
    [moc refreshAllObjects];
    
    Roadworks *object;
    
    NSPredicate *predicate;
    NSFetchRequest *fetchRequest = [self getFetchRequest];
    [fetchRequest setFetchLimit:1];
    
    NSLog(@"Processing %zd records", array.count);
    for (NSDictionary *item in array) {
        NSString *reference = [NSObject validateString:item[@"id"]];
        if (reference.length == 0) {
            continue;
        }
        
        NSNumber *latitude = [NSObject validateNumberDouble:item[@"latitude"]];
        NSNumber *longitude = [NSObject validateNumberDouble:item[@"longitude"]];
        if (![self validForImport:latitude lon:longitude]) {
            NSLog(@"Failed lat/lon for %@, %@", reference, self);
        } else {
            predicate = [NSPredicate predicateWithFormat:@"reference == %@ && timestamp == %@", reference, date];
            [fetchRequest setPredicate:predicate];
            NSArray *arrayExisting = [moc executeFetchRequest:fetchRequest error:&error];
            if ([arrayExisting count] == 0) {
                object = [NSEntityDescription insertNewObjectForEntityForName:self.entityName inManagedObjectContext:moc];
                object.reference          = reference;
                object.timestamp          = date;
                object.comment            = [NSObject validateString:item[@"comment"]];
                object.effectOnRoadLayout   = [NSObject validateString:item[@"effectOnRoadLayout"]];
                object.roadMaintenanceType = [NSObject validateString:item[@"roadMaintenanceType"]];
                object.impactOnTraffic      = [NSObject validateString:item[@"impactOnTraffic"]];
                object.type                 = [NSObject validateString:item[@"roadMaintenanceType"]];
                object.status               = [NSObject validateString:item[@"validityStatus"]];
                object.periods              = [NSObject validateString:item[@"startOfPeriod"]];
                object.overallStartTime     = [self dateFromString:[NSObject validateString:item[@"overallStartTime"]]];
                object.overallEndTime       = [self dateFromString:[NSObject validateString:item[@"overallEndTime"]]];
            
                NSMutableDictionary *dict = [NSMutableDictionary new];
                [dict setValue:reference forKey:kCommonReference];
                [dict setValue:[NSObject validateString:item[@"id"]] forKey:kCommonTitle];
                [dict setValue:latitude forKey:kCommonLat];
                [dict setValue:longitude forKey:kCommonLon];
                [dict setValue:object.timestamp forKey:kCommonTimestamp];
                [dict setValue:@(object.localizedCounter) forKey:kCommonCounter1];
                [dict setValue:@(object.localizedCounterSub) forKey:kCommonCounter2];
                [arrayCommon addObject:dict];
            }
        }
    }
    NSLog(@"Processing complete");

    [self.coreData saveContext];
    [self setTimestamp:date];
    NSLog(@"Saved");
    
    return arrayCommon;
}

- (NSArray *)checkForChanges:(NSArray <NSDictionary *> *)arrayCommon {
    
    NSMutableArray <NSDictionary *> *arrayChanges = [NSMutableArray new];
    
    for (NSDictionary *item in arrayCommon) {
        NSString *reference = [NSObject validateString:item[kCommonReference]];
        NSDate *timestamp = item[kCommonTimestamp];
        
        NSArray *history = [self retrieveHistory:reference];
        if (history.count >= 2) {
            Roadworks *historyItem1 = history[0];
            if ([historyItem1.timestamp timeIntervalSinceDate:timestamp] == 0) {    //first date is current batch
                Roadworks *historyItem2 = history[1];
                if (![historyItem1.comment isEqualToString:historyItem2.comment]) {
                    [arrayChanges addObject:item];
                }
            }
        } else {
            [arrayChanges addObject:item];
        }
    }
    
    return arrayChanges;
}

- (NSArray <Roadworks *> *)retrieveAll {
    
    return [super retrieveAll:nil];
}

- (NSArray <Roadworks *> *)retrieveHistory:(NSString *)reference {
    
    return [super retrieveHistory:reference];
}

#pragma mark -

- (NSDate *)dateFromString:(NSString *)string {
    
    NSDate *date = [[self dateFormatterRoadworks] dateFromString:string];
    if (date == nil) {
        date = [[self dateFormatterRoadworks2] dateFromString:string];
    }
    return date;
}

static NSDateFormatter *formatterRoadworks = nil;
- (NSDateFormatter *)dateFormatterRoadworks {
    
    if (!formatterRoadworks)
    {
        formatterRoadworks = [NSDateFormatter new];
        [formatterRoadworks setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
        [formatterRoadworks setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
    }
    return formatterRoadworks;
}

static NSDateFormatter *formatterRoadworks2 = nil;
- (NSDateFormatter *)dateFormatterRoadworks2 {
    
    if (!formatterRoadworks2)
    {
        formatterRoadworks2 = [NSDateFormatter new];
        [formatterRoadworks2 setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
        [formatterRoadworks2 setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    }
    return formatterRoadworks2;
}

@end

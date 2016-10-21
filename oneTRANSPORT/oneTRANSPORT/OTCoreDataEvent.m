//
//  OTCoreDataEvent.m
//  oneTRANSPORT
//
//  Created by Dominic Frazer Imregh on 15/09/2016.
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

#import "OTCoreDataEvent.h"
#import "OTCoreDataBase+Private.h"
#import "OTCoreData+Private.h"
#import "NSObject+Collection.h"
#import "OTTransportTypes.h"

@interface OTCoreDataEvent()

@property (nonatomic, strong) NSDateFormatter *formatter;

@end

@implementation OTCoreDataEvent

- (instancetype)initWithCoreData:(id)parent {
    
    if (self = [super initWithCoreData:parent]) {
        self.entityName = kCoreDataEntityEvent;
        self.userDefaultsCurrentData = kUserDefaultsStampEvent;
        self.dataType = k_CommonType_Events;
        self.userDefaultsUse = @"oneT_UserDefaultsEvent";
    }
    return self;
}

- (BOOL)isAllowedToMakeRequest:(LocalAuthority)la {
    
    return [super isAllowedToMakeRequest:la] && (la != LocalAuthorityBirmingham);
}

- (NSArray *)populateTableWith:(id)data timestamp:(NSDate *)date {
    
    NSMutableArray <NSDictionary *> *arrayCommon = [NSMutableArray new];
    [self setImportFilter];
    
    NSError *error = nil;
    NSManagedObjectContext *moc = [self.coreData managedObjectContext];
    [moc refreshAllObjects];
    
    Event *object;
    
    NSPredicate *predicate;
    NSFetchRequest *fetchRequest = [self getFetchRequest];
    [fetchRequest setFetchLimit:1];
    
    NSArray *array = data;
    for (NSDictionary *item in array) {
        NSString *reference = [NSObject validateString:item[@"id"]];
        if (reference.length == 0) {
            continue;
        }
        
        NSNumber *latitude = [NSObject validateNumberDouble:item[@"latitude"]];
        NSNumber *longitude = [NSObject validateNumberDouble:item[@"longitude"]];
        if ([self validForImport:latitude lon:longitude]) {
            predicate = [NSPredicate predicateWithFormat:@"reference == %@ && timestamp == %@", reference, date];
            [fetchRequest setPredicate:predicate];
            NSSortDescriptor *sort1 = [[NSSortDescriptor alloc] initWithKey:@"timestamp" ascending:false];
            [fetchRequest setSortDescriptors:@[sort1]];
            
            NSArray *arrayExisting = [moc executeFetchRequest:fetchRequest error:&error];
            if ([arrayExisting count] == 0) {
                object = [NSEntityDescription insertNewObjectForEntityForName:self.entityName inManagedObjectContext:moc];
                object.reference = reference;
                object.timestamp = date;
                object.periodStart = [self dateFromString:item[@"startOfPeriod"]];
                object.periodEnd = [self dateFromString:item[@"endOfPeriod"]];
                object.overallStart = [self dateFromString:item[@"overallStartTime"]];
                object.overEnd = [self dateFromString:item[@"overallEndTime"]];
                object.validityStatus = [NSObject validateString:item[@"validityStatus"]];
                object.impactOnTraffic = [NSObject validateString:item[@"impactOnTraffic"]];
                
                NSMutableDictionary *dict = [NSMutableDictionary new];
                [dict setValue:reference forKey:kCommonReference];
                [dict setValue:[NSObject validateString:item[@"description"]] forKey:kCommonTitle];
                [dict setValue:latitude forKey:kCommonLat];
                [dict setValue:longitude forKey:kCommonLon];
                [dict setValue:date forKey:kCommonTimestamp];
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
            Event *historyItem1 = history[0];
            if ([historyItem1.timestamp timeIntervalSinceDate:timestamp] == 0) {    //first date is current batch
                Event *historyItem2 = history[1];
                if (![historyItem1.periodStart isEqualToDate:historyItem2.periodStart]) {
                    [arrayChanges addObject:item];
                }
            }
        } else {
            [arrayChanges addObject:item];
        }
    }
    
    return arrayChanges;
}

- (NSArray <Event *> * _Nonnull)retrieveAll {
    
    return [super retrieveAll:nil];
}

- (NSArray <Event *> *)retrieveHistory:(NSString *)reference {
    
    return [super retrieveHistory:reference];
}

#pragma mark - Dates
- (NSDate *)dateFromString:(NSString *)string {
    
    return [[self dateFormatter] dateFromString:string];
}

- (NSDateFormatter *)dateFormatter {
    
    if (!self.formatter)
    {
        NSDateFormatter *formatter = [NSDateFormatter new];
        [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
        [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
        self.formatter = formatter;
    }
    return self.formatter;
}

/*
 {
 description =     {
 content = "TYPE : GDP : Location : The junction of the M4 J4 and the A408   : Reason : Congestion : Status : Currently Active : Delay : There are currently delays of 10 minutes against expected traffic";
 lang = en;
 };
 endOfPeriod = "9999-12-31T23:59:59.9999999";
 impactOnTraffic = heavy;
 overallEndTime = "9999-12-31T23:59:59.9999999";
 overallStartTime = "2016-07-28T19:14:28";
 startOfPeriod = "2016-07-28T19:14:28";
 validityStatus = active;
 },
 {
 description =     {
 content = "TYPE : GDP : Location : The A5 southbound at the junction with the A505 Leighton Buzzard : Reason : Congestion : Status : Currently Active";
 lang = en;
 };
 endOfPeriod = "9999-12-31T23:59:59.9999999";
 id = GUID733682;
 impactOnTraffic = freeFlow;
 latitude = "51.9069";
 longitude = "-0.550465643";
 overallEndTime = "9999-12-31T23:59:59.9999999";
 overallStartTime = "2016-08-29T12:19:23";
 startOfPeriod = "2016-08-29T12:19:23";
 validityStatus = active;
 },
 */

@end

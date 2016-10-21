//
//  OTCoreDataVariableMessageSigns.m
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

#import "OTCoreDataVariableMessageSigns.h"
#import "OTCoreDataBase+Private.h"
#import "OTCoreData+Private.h"
#import "NSObject+Collection.h"
#import "OTTransportTypes.h"

@implementation OTCoreDataVariableMessageSigns

- (instancetype)initWithCoreData:(id)parent {
    
    if (self = [super initWithCoreData:parent]) {
        self.entityName = kCoreDataEntityVariable;
        self.userDefaultsCurrentData = kUserDefaultsStampVariableMS;
        self.dataType = k_CommonType_VariableMS;
        self.userDefaultsUse = @"oneT_UserDefaultsVariableSigns";
    }
    return self;
}

- (NSArray *)populateTableWith:(id)data timestamp:(NSDate *)date {
    
    NSMutableArray <NSDictionary *> *arrayCommon = [NSMutableArray new];
    [self setImportFilter];

    NSError *error = nil;
    NSManagedObjectContext *moc = [self.coreData managedObjectContext];
    [moc refreshAllObjects];
    
    VariableMessageSigns *object;
    
    NSPredicate *predicate;
    NSFetchRequest *fetchRequest = [self getFetchRequest];
    [fetchRequest setFetchLimit:1];

    NSInteger i = 0;
    NSInteger j = 0;
         
    NSArray *array = data;
    for (NSDictionary *item in array) {
        NSString *reference = [NSObject validateString:item[@"locationId"]];
        if (reference.length == 0) {
            continue;
        }
        i++;
        NSNumber *latitude = [NSObject validateNumberDouble:item[@"latitude"]];
        NSNumber *longitude = [NSObject validateNumberDouble:item[@"longitude"]];
        if ([self validForImport:latitude lon:longitude]) {
            j++;
            predicate = [NSPredicate predicateWithFormat:@"reference == %@ && timestamp == %@", reference, date];
            [fetchRequest setPredicate:predicate];
            NSSortDescriptor *sort1 = [[NSSortDescriptor alloc] initWithKey:@"timestamp" ascending:false];
            [fetchRequest setSortDescriptors:@[sort1]];

            NSArray *arrayExisting = [moc executeFetchRequest:fetchRequest error:&error];
            if ([arrayExisting count] == 0) {
                object = [NSEntityDescription insertNewObjectForEntityForName:self.entityName inManagedObjectContext:moc];
                object.reference = reference;
                object.timestamp = date;
                    
                NSArray *arrayLegends = item[@"legend"];
                if ([arrayLegends isKindOfClass:[NSArray class]]) {
                    NSString *legends = [arrayLegends componentsJoinedByString:@"\n"];
                    object.legends = [NSObject validateString:legends];
                } else if ([arrayLegends isKindOfClass:[NSString class]]) {
                    object.legends = (NSString *)arrayLegends;
                }
                object.type = [NSObject validateString:item[@"vmsType"]];
                
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
    
    NSLog(@"Total VMS count %zd, good %zd", i, j);
    
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
            VariableMessageSigns *historyItem1 = history[0];
            VariableMessageSigns *historyItem2 = history[1];
            if (![historyItem1.legends isEqualToString:historyItem2.legends]) { //legends are different
                [arrayChanges addObject:item];
            }
        } else {
            [arrayChanges addObject:item];
        }
    }

    return arrayChanges;
}

- (NSArray <VariableMessageSigns *> *)retrieveAll:(BOOL)activeOnly {
    
    NSPredicate *predicate = nil;
    if (activeOnly) {
        predicate = [NSPredicate predicateWithFormat:@"legends.length > 0"];
    }
    return [super retrieveAll:predicate];
}

- (NSArray <VariableMessageSigns *> *)retrieveHistory:(NSString *)reference {
    
    return [super retrieveHistory:reference];
}

@end

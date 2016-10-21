//
//  OTCoreDataClearViewTraffic.m
//  oneTRANSPORT
//
//  Created by Dominic Frazer Imregh on 13/09/2016.
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

#import "OTCoreDataClearViewTraffic.h"
#import "OTCoreData+Private.h"
#import "NSObject+Collection.h"
#import "OTTransportTypes.h"
#import "TsvObject.h"

#import "CV_Traffic.h"

@interface OTCoreDataClearViewTraffic()

@property (nonatomic, strong) NSDateFormatter *formatter;

@end

@implementation OTCoreDataClearViewTraffic

- (instancetype)initWithCoreData:(id)parent {
    
    if (self = [super initWithCoreData:parent]) {
        self.entityName = kCoreDataEntityClearViewTraffic;
        self.userDefaultsCurrentData = kUserDefaultsStampClearViewTraffic;
        self.dataType = k_CommonType_ClearViewTraffic;
        self.userDefaultsUse = @"oneT_UserDefaultsClearView";
    }
    return self;
}

- (NSArray <NSDictionary *> *)populateTableWithReference:(NSString *)reference data:(id)data timestamp:(NSDate *)date {
    
    NSError *error = nil;
    NSManagedObjectContext *moc = [self.coreData managedObjectContext];
    NSFetchRequest *fetchRequest = [self getFetchRequest];
    [fetchRequest setFetchLimit:1];

    NSArray *array = data;
    for (NSDictionary *item in array) {
        NSDate *timestamp = [self dateFromString:item[@"time"]];
        
        if (timestamp) {
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"reference == %@ && timestamp == %@", reference, timestamp];
            [fetchRequest setPredicate:predicate];
            NSSortDescriptor *sort1 = [[NSSortDescriptor alloc] initWithKey:@"timestamp" ascending:false];
            [fetchRequest setSortDescriptors:@[sort1]];
            
            NSArray *arrayObject = [moc executeFetchRequest:fetchRequest error:&error];
            if (arrayObject.count == 0) {
                CV_Traffic *object = [NSEntityDescription insertNewObjectForEntityForName:self.entityName inManagedObjectContext:moc];
                object.reference    = reference;
                object.timestamp    = timestamp;
                object.creationtime = timestamp;
                object.lane         = [NSObject validateNumberInt:item[@"lane"]];
                object.direction    = [NSObject validateNumberInt:item[@"direction"]];
            }
        }
    }
    [self.coreData saveContext];
    
    NSMutableArray <NSDictionary *> *arrayCommon = [NSMutableArray new];
    return arrayCommon;
}

- (NSArray <CV_Traffic *> *)checkForChanges:(NSArray <NSDictionary *> *)arrayCommon {
    
    return nil;
}

- (void)populateTSV:(NSString *)stringData completion:(PopulateBlock)completionBlock {
    
    NSError *error = nil;
    NSManagedObjectContext *moc = [self.coreData managedObjectContext];
    
    CV_Traffic *object;
    
    NSFetchRequest *fetchRequest = [self getFetchRequest];
    NSArray *arrayExisting = [moc executeFetchRequest:fetchRequest error:&error];
    for (object in arrayExisting) {
        [moc deleteObject:object];
    }
    
    NSArray *arrayColumns;
    NSInteger i = 0;
    NSInteger j = 0;
    NSArray *arrayNodes = [TsvObject prepareTsvArray:stringData];
    for (NSString *row in arrayNodes) {
        arrayColumns = [TsvObject cleanTsvColumns:row];
        if (i == 0) {
            if (![TsvObject validateColumns:arrayColumns arrayCompare:@[@"_id",@"sensor_id",@"timestamp",@"lane",@"direction",@"cin_id",@"creation_time"]]) {
                break;
            }
        } else if (arrayColumns.count >= 7) {
            object = [NSEntityDescription insertNewObjectForEntityForName:self.entityName inManagedObjectContext:moc];
            object.primary_id   = arrayColumns[0];
            object.reference    = arrayColumns[1];
            object.timestamp    = [self dateFromString:arrayColumns[2]];
            object.lane         = @([arrayColumns[3] integerValue]);
            object.direction    = @([arrayColumns[4] integerValue]);
            object.cin_id       = arrayColumns[5];
            object.creationtime = [NSDate dateWithTimeIntervalSince1970:[arrayColumns[6] integerValue]];
            j++;
        }
        i++;
        
        if (i % 100 == 0) {
            NSLog(@"traffic count = %zd", i);
        }
    }
    NSLog(@"Total traffic count = %zd, actual number saved = %zd", i, j);
    [self.coreData saveContext];
    
    completionBlock(i>0);
}

//SELECT 'creationtime', 'direction', COUNT(*) FROM 'CV_Traffic' GROUP BY 'creationtime, direction'
- (NSArray <NSDictionary *> *)retrieveSummary:(NSPredicate *)predicate {
    
    NSError *error = nil;
    NSManagedObjectContext *moc = [self.coreData managedObjectContext];

    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:self.entityName];
    if (predicate) {
        [fetchRequest setPredicate:predicate];
    }
        
    NSExpression *keyPathExpression = [NSExpression expressionForKeyPath:@"direction"];
    NSExpression *countExpression = [NSExpression expressionForFunction:@"count:" arguments:@[keyPathExpression]];
    
    NSExpressionDescription *expressionDescription = [NSExpressionDescription new];
    [expressionDescription setName:@"counter"];
    [expressionDescription setExpression:countExpression];
    [expressionDescription setExpressionResultType:NSInteger32AttributeType];
    
    [fetchRequest setPropertiesToFetch:@[@"creationtime", @"direction", expressionDescription]];
    [fetchRequest setReturnsDistinctResults:YES];

    [fetchRequest setPropertiesToGroupBy:@[@"creationtime", @"direction"]];
    [fetchRequest setResultType:NSDictionaryResultType];

    NSArray *results = [moc executeFetchRequest:fetchRequest error:&error];
    return results;
}

#pragma mark - 

- (NSDate *)dateFromString:(NSString *)string {
    
    return [[self dateFormatter] dateFromString:string];
}

- (NSDateFormatter *)dateFormatter {
    
    if (!self.formatter)
    {
        self.formatter = [NSDateFormatter new];
        [self.formatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
        [self.formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    }
    return self.formatter;
}

@end

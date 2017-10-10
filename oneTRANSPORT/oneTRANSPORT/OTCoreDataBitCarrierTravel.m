//
//  OTCoreDataBitCarrierTravel.m
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

#import "OTCoreDataBitCarrierTravel.h"
#import "OTCoreData+Private.h"
#import "NSObject+Collection.h"
#import "OTTransportTypes.h"
#import "TsvObject.h"

#import "BC_Travel.h"

@implementation OTCoreDataBitCarrierTravel

- (instancetype)initWithCoreData:(id)parent {
    
    if (self = [super initWithCoreData:parent]) {
        self.entityName = kCoreDataEntityBitCarrierTravel;
        self.userDefaultsCurrentData = kUserDefaultsStampBitCarrierTravel;
        self.dataType = k_CommonType_BitCarrierTravel;
        self.userDefaultsUse = @"oneT_UserDefaultsBitCarrier";
    }
    return self;
}

- (NSArray <NSDictionary *> *)populateTableWith:(id)data timestamp:(NSDate *)date {
    
    NSDictionary *item = data;
    
    NSString *reference = [NSObject validateString:item[@"rid"]];
    if (reference.length > 0) {
        NSDate *timestamp = [self dateFromTsvString:item[@"time"]];
        
        NSError *error = nil;
        NSManagedObjectContext *moc = [self.coreData managedObjectContext];
        
        NSFetchRequest *fetchRequest = [self getFetchRequest];
        [fetchRequest setFetchLimit:1];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"travel_summary_id == %@ && timestamp == %@", reference, timestamp];
        [fetchRequest setPredicate:predicate];
        NSSortDescriptor *sort1 = [[NSSortDescriptor alloc] initWithKey:@"timestamp" ascending:false];
        [fetchRequest setSortDescriptors:@[sort1]];
        
        NSArray *arrayObject = [moc executeFetchRequest:fetchRequest error:&error];
        if (arrayObject.count == 0) {
            BC_Travel *object = [NSEntityDescription insertNewObjectForEntityForName:self.entityName inManagedObjectContext:moc];

            object.travel_summary_id = reference;
            object.timestamp = timestamp;
            object.clock_time = timestamp;

            NSDictionary *average = item[@"average"];
            if (average) {
                object.score = [NSObject validateNumberInt:average[@"score"]];
                NSDictionary *publish = average[@"publish"];
                if (publish) {
                    object.elapsed = [NSObject validateNumberInt:publish[@"elapsed"]];
                    object.speed = [NSObject validateNumberDouble:publish[@"speed"]];
                }
            }
            NSArray *traveltimesArray = item[@"traveltimes"];
            if (traveltimesArray.count > 0) {
                NSDictionary *traveltimes = traveltimesArray[0];
                if (traveltimes) {
                    object.from_location = [NSObject validateString:traveltimes[@"from"]];
                    object.to_location = [NSObject validateString:traveltimes[@"to"]];
                }
            }
            
            [self.coreData saveContext];
        }
    }
    
    NSMutableArray <NSDictionary *> *arrayCommon = [NSMutableArray new];
    return arrayCommon;
}

- (NSArray <BC_Travel *> *)checkForChanges:(NSArray <NSDictionary *> *)arrayCommon {

    NSMutableArray <BC_Travel *> *arrayChanges = [NSMutableArray new];
    return arrayChanges;
}

- (void)populateTSV:(NSString *)stringData completion:(PopulateBlock)completionBlock {
    
    NSError *error = nil;
    NSManagedObjectContext *moc = [self.coreData managedObjectContext];
    
    BC_Travel *object;
    
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
            if (![TsvObject validateColumns:arrayColumns arrayCompare:@[@"_id",@"travel_summary_id",@"clock_time",@"from_location",@"to_location",@"score",@"speed",@"elapsed",@"trend",@"cin_id",@"creation_time"]]) {
                break;
            }
        } else if (arrayColumns.count >= 10) {
            object = [NSEntityDescription insertNewObjectForEntityForName:self.entityName inManagedObjectContext:moc];
            object.primary_id        = arrayColumns[0];
            object.travel_summary_id = arrayColumns[1];
            object.clock_time        = [self dateFromTsvString:arrayColumns[2]];
            object.from_location     = arrayColumns[3];
            object.to_location       = arrayColumns[4];
            object.score             = @([arrayColumns[5] floatValue]);
            object.speed             = @([arrayColumns[6] floatValue]);
            object.elapsed           = @([arrayColumns[7] floatValue]);
            object.trend             = @([arrayColumns[8] floatValue]);
            object.cin_id            = arrayColumns[9];
            object.timestamp         = [NSDate dateWithTimeIntervalSince1970:[arrayColumns[10] integerValue]];
            j++;
        }
        i++;

        if (i % 100 == 0) {
            NSLog(@"travel count = %zd", i);
        }
    }
    NSLog(@"Total travel count = %zd, actual number saved = %zd", i, j);
    [self.coreData saveContext];
    
    completionBlock(i>0);
}

@end

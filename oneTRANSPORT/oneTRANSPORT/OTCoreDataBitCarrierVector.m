//
//  OTCoreDataBitCarrierVector.m
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

#import "OTCoreDataBitCarrierVector.h"
#import "OTCoreData+Private.h"
#import "NSObject+Collection.h"
#import "OTTransportTypes.h"
#import "TsvObject.h"

#import "BC_Vector.h"

@implementation OTCoreDataBitCarrierVector

- (instancetype)initWithCoreData:(id)parent {
    
    if (self = [super initWithCoreData:parent]) {
        self.entityName = kCoreDataEntityBitCarrierVector;
        self.userDefaultsCurrentData = kUserDefaultsStampBitCarrierVector;
        self.dataType = k_CommonType_BitCarrierVector;
        self.userDefaultsUse = @"oneT_UserDefaultsBitCarrier";
    }
    return self;
}

- (NSArray <NSDictionary *> *)populateTableWith:(id)data timestamp:(NSDate *)date {
    
    NSDictionary *item = data;
    
    NSString *reference = [NSObject validateString:item[@"vid"]];
    NSDate *timestamp = [self dateFromTsvString:item[@"time"]];
    
    NSError *error = nil;
    NSManagedObjectContext *moc = [self.coreData managedObjectContext];
    
    NSFetchRequest *fetchRequest = [self getFetchRequest];
    [fetchRequest setFetchLimit:1];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"reference == %@ && timestamp == %@", reference, timestamp];
    [fetchRequest setPredicate:predicate];
    NSSortDescriptor *sort1 = [[NSSortDescriptor alloc] initWithKey:@"timestamp" ascending:false];
    [fetchRequest setSortDescriptors:@[sort1]];
    
    NSArray *arrayObject = [moc executeFetchRequest:fetchRequest error:&error];
    if (arrayObject.count == 0) {
        BC_Vector *object = [NSEntityDescription insertNewObjectForEntityForName:self.entityName inManagedObjectContext:moc];
        object.reference = reference;
        object.levelOfService = [NSObject validateString:item[@"levelofservice"]];

        NSDictionary *average = item[@"average"];
        if (average) {
            NSDictionary *calculated = average[@"calculated"];
            if (calculated) {
                object.speed = calculated[@"speed"];
                object.elapsedTime = calculated[@"elapsed"];
            }
        }
        object.timestamp = timestamp;
        [self.coreData saveContext];
    }
    
    NSMutableArray <NSDictionary *> *arrayCommon = [NSMutableArray new];
    return arrayCommon;
}

- (NSArray <BC_Vector *> *)checkForChanges:(NSArray <NSDictionary *> *)arrayCommon {
    
    NSMutableArray <BC_Vector *> *arrayChanges = [NSMutableArray new];
    return arrayChanges;
}

- (NSArray <BC_Vector *> *)retrieveVectors:(NSString *)reference from:(NSDate *)fromDate to:(NSDate *)toDate {
    
    NSError *error = nil;
    NSManagedObjectContext *moc = [self.coreData managedObjectContext];
    
    NSFetchRequest *fetchRequest = [self getFetchRequest];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"reference == %@ && timestamp >= %@ && timestamp <= %@", reference, fromDate, toDate];
    [fetchRequest setPredicate:predicate];
    
    NSSortDescriptor *sort1 = [[NSSortDescriptor alloc] initWithKey:@"timestamp" ascending:false];
    [fetchRequest setSortDescriptors:@[sort1]];
    
    NSArray *array = [moc executeFetchRequest:fetchRequest error:&error];
    return array;
}

- (NSArray <BC_Vector *> *)retrieveVectors:(NSString *)reference max:(NSInteger)max {
    
    NSError *error = nil;
    NSManagedObjectContext *moc = [self.coreData managedObjectContext];
    
    NSFetchRequest *fetchRequest = [self getFetchRequest];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"reference == %@", reference];
    [fetchRequest setPredicate:predicate];
    
    NSSortDescriptor *sort1 = [[NSSortDescriptor alloc] initWithKey:@"timestamp" ascending:false];
    [fetchRequest setSortDescriptors:@[sort1]];
    [fetchRequest setFetchLimit:max];
    
    NSArray *array = [moc executeFetchRequest:fetchRequest error:&error];
    return array;
}

- (void)populateTSV:(NSString *)stringData completion:(PopulateBlock)completionBlock {
    
    NSError *error = nil;
    NSManagedObjectContext *moc = [self.coreData managedObjectContext];
    
    BC_Vector *object;
    
    NSFetchRequest *fetchRequest = [self getFetchRequest];
    NSArray *arrayExisting = [moc executeFetchRequest:fetchRequest error:&error];
    for (object in arrayExisting) {
        [moc deleteObject:object];
    }
    
    NSInteger i = 0;
    NSInteger j = 0;
    NSArray *arrayColumns;
    NSArray *arrayNodes = [TsvObject prepareTsvArray:stringData];
    for (NSString *row in arrayNodes) {
        arrayColumns = [TsvObject cleanTsvColumns:row];
        if (i == 0) {
            if (![TsvObject validateColumns:arrayColumns arrayCompare:@[@"_id",@"vector_id",@"timestamp",@"speed",@"elapsed",@"level_of_service",@"cin_id",@"creation_time"]]) {
                break;
            }
        } else if (arrayColumns.count >= 7) {
            object = [NSEntityDescription insertNewObjectForEntityForName:self.entityName inManagedObjectContext:moc];
            object.primary_id   = arrayColumns[0];
            object.reference        = arrayColumns[1];
            object.timestamp        = [self dateFromTsvString:arrayColumns[2]];
            object.speed            = @([arrayColumns[3] integerValue]);
            object.elapsedTime      = @([arrayColumns[4] integerValue]);
            object.levelOfService   = arrayColumns[5];
            object.cin_id           = arrayColumns[6];
            j++;
        }
        i++;
        
        if (i % 100 == 0) {
            NSLog(@"vector count = %zd, actual number saved = %zd", i, j);
        }
    }
    NSLog(@"Total vector count = %zd", i);
    [self.coreData saveContext];
    
    completionBlock(i>0);
}

@end

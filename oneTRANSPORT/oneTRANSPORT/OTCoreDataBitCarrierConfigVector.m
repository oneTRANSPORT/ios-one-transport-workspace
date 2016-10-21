//
//  OTCoreDataBitCarrierConfigVector.m
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

#import "OTCoreDataBitCarrierConfigVector.h"
#import "OTCoreData+Private.h"
#import "NSObject+Collection.h"
#import "OTTransportTypes.h"
#import "TsvObject.h"

#import "BC_ConfigVector.h"

@implementation OTCoreDataBitCarrierConfigVector

- (instancetype)initWithCoreData:(id)parent {
    
    if (self = [super initWithCoreData:parent]) {
        self.entityName = kCoreDataEntityBitCarrierConfigVector;
        self.userDefaultsCurrentData = kUserDefaultsStampBitCarrierConfigVector;
        self.dataType = k_CommonType_BitCarrierConfigVector;
        self.userDefaultsUse = @"oneT_UserDefaultsBitCarrier";
    }
    return self;
}

- (NSArray <BC_ConfigVector *> *)populateTableWith:(id)data timestamp:(NSDate *)date {
    
    return nil;
}

- (NSArray <BC_ConfigVector *> *)checkForChanges:(NSArray <NSDictionary *> *)arrayCommon {

    return nil;
}

- (void)populateTSV:(NSString *)stringData completion:(PopulateBlock)completionBlock {
    
    NSError *error = nil;
    NSManagedObjectContext *moc = [self.coreData managedObjectContext];
    
    BC_ConfigVector *object;
    
    NSFetchRequest *fetchRequest = [self getFetchRequest];
    NSArray *arrayExisting = [moc executeFetchRequest:fetchRequest error:&error];
    for (object in arrayExisting) {
        [moc deleteObject:object];
    }
    
    NSPredicate *predicate;
    
    NSInteger i = 0;
    NSInteger j = 0;
    NSArray *arrayColumns;
    NSArray *arrayNodes = [TsvObject prepareTsvArray:stringData];
    for (NSString *row in arrayNodes) {
        arrayColumns = [TsvObject cleanTsvColumns:row];
        if (i == 0) {
            if (![TsvObject validateColumns:arrayColumns arrayCompare:@[@"_id",@"vector_id",@"name",@"customer_name",@"from_location",@"to_location",@"distance",@"sketch_id",@"cin_id",@"creation_time"]]) {
                break;
            }
        } else if (arrayColumns.count >= 9) {
            
            NSString *reference = arrayColumns[1];
            NSDate *timestamp = [NSDate dateWithTimeIntervalSince1970:[arrayColumns[9] integerValue]];
            
            predicate = [NSPredicate predicateWithFormat:@"reference == %@", reference];
            [fetchRequest setPredicate:predicate];
            
            BOOL cont = true;
            NSArray *arrayExisting = [moc executeFetchRequest:fetchRequest error:&error];
            if ([arrayExisting count]) {
                object = arrayExisting[0];
                
                if ([object.timestamp timeIntervalSinceDate:timestamp] > 0) {
                    cont = false;
                }
            } else {
                object = [NSEntityDescription insertNewObjectForEntityForName:self.entityName inManagedObjectContext:moc];
                object.reference          = reference;
                j++;
            }
            
            if (cont) {
                object.primary_id       = arrayColumns[0];
                object.name             = arrayColumns[2];
                object.customer_name    = arrayColumns[3];
                object.from_location    = arrayColumns[4];
                object.to_location      = arrayColumns[5];
                object.distance         = @([arrayColumns[6] integerValue]);
                object.sketch_id        = arrayColumns[7];
                object.cin_id           = arrayColumns[8];
                object.timestamp        = timestamp;
            }
        }
        i++;
        
        if (i % 100 == 0) {
            NSLog(@"config vector count = %zd", i);
        }
    }
    NSLog(@"Total config vector count = %zd", i);
    NSLog(@"Total saved config vector count = %zd", j);
    [self.coreData saveContext];
    
    completionBlock(i>0);
}

@end

//
//  OTCoreDataBitCarrierNode.m
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

#import "OTCoreDataBitCarrierNode.h"
#import "OTCoreData+Private.h"
#import "OTCoreDataBase+Private.h"
#import "NSObject+Collection.h"
#import "OTTransportTypes.h"
#import "TsvObject.h"

#import "BC_Node.h"

@implementation OTCoreDataBitCarrierNode

- (instancetype)initWithCoreData:(id)parent {
    
    if (self = [super initWithCoreData:parent]) {
        self.entityName = kCoreDataEntityBitCarrierNode;
        self.userDefaultsCurrentData = kUserDefaultsStampBitCarrierNode;
        self.dataType = k_CommonType_BitCarrierNode;
        self.userDefaultsUse = @"oneT_UserDefaultsBitCarrier";
    }
    return self;
}

- (NSArray <BC_Node *> *)populateTableWith:(id)data timestamp:(NSDate *)date {
    
    NSMutableArray <BC_Node *> *arrayChanges = [NSMutableArray new];
    return arrayChanges;
}

- (NSArray <BC_Node *> *)checkForChanges:(NSArray <NSDictionary *> *)arrayCommon {
    
    NSMutableArray <BC_Node *> *arrayChanges = [NSMutableArray new];
    return arrayChanges;
}

- (NSArray <NSDictionary *> *)returnNodesForCommon {
    
    NSMutableArray <NSDictionary *> *arrayCommon = [NSMutableArray new];
    
    NSError *error = nil;
    NSManagedObjectContext *moc = [self.coreData managedObjectContext];
    
    BC_Node *object;
    
    NSFetchRequest *fetchRequest = [self getFetchRequest];
    NSArray *arrayExisting = [moc executeFetchRequest:fetchRequest error:&error];
    for (object in arrayExisting) {
        
        NSMutableDictionary *dict = [NSMutableDictionary new];
        [dict setValue:object.reference forKey:kCommonReference];
        [dict setValue:[NSObject validateString:object.customer_name] forKey:kCommonTitle];
        [dict setValue:object.latitude  forKey:kCommonLat];
        [dict setValue:object.longitude forKey:kCommonLon];
        [dict setValue:object.timestamp forKey:kCommonTimestamp];
        [arrayCommon addObject:dict];
    }
    
    return arrayCommon;
}

- (void)populateTSV:(NSString *)stringData completion:(PopulateBlock)completionBlock {
    
    [self setImportFilter];
    NSError *error = nil;
    NSManagedObjectContext *moc = [self.coreData managedObjectContext];
    
    BC_Node *object;
    
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
            if(![TsvObject validateColumns:arrayColumns arrayCompare:@[@"_id", @"node_id", @"customer_id", @"customer_name", @"latitude", @"longitude", @"cin_id", @"creation_time"]]) {
                break;
            }
        } else if (arrayColumns.count >= 7) {
            NSNumber *latitude = @([arrayColumns[4] doubleValue]);
            NSNumber *longitude = @([arrayColumns[5] doubleValue]);
            if (![self validForImport:latitude lon:longitude]) {
                NSLog(@"Failed lat/lon for %@, %@", row, self);
            } else {
                object = [NSEntityDescription insertNewObjectForEntityForName:self.entityName inManagedObjectContext:moc];
                object.primary_id     = arrayColumns[0];
                object.reference      = arrayColumns[1];
                object.customer_id    = arrayColumns[2];
                object.customer_name  = arrayColumns[3];
                object.latitude       = latitude;
                object.longitude      = longitude;
                object.cin_id         = arrayColumns[6];
                object.timestamp      = [NSDate dateWithTimeIntervalSince1970:[arrayColumns[7] integerValue]];
                j++;
            }
        }
        i++;
        
        if (i % 100 == 0) {
            NSLog(@"node count = %zd", i);
        }
    }
    NSLog(@"Total node count = %zd, actual number saved = %zd", i, j);
    [self.coreData saveContext];
    
    completionBlock(i>0);
}

@end

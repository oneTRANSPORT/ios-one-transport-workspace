//
//  OTCoreDataBitCarrierSketch.m
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

#import "OTCoreDataBitCarrierSketch.h"
#import "OTCoreData+Private.h"
#import "NSObject+Collection.h"
#import "OTTransportTypes.h"
#import "TsvObject.h"

#import "BC_Sketch.h"

@implementation OTCoreDataBitCarrierSketch

- (instancetype)initWithCoreData:(id)parent {
    
    if (self = [super initWithCoreData:parent]) {
        self.entityName = kCoreDataEntityBitCarrierSketch;
        self.userDefaultsCurrentData = kUserDefaultsStampBitCarrierSketch;
        self.dataType = k_CommonType_BitCarrierSketch;
        self.userDefaultsUse = @"oneT_UserDefaultsBitCarrier";
    }
    return self;
}

- (NSArray <BC_Sketch *> *)populateTableWith:(id)data timestamp:(NSDate *)date {
    
    NSMutableArray <BC_Sketch *> *arrayChanges = [NSMutableArray new];
    return arrayChanges;
}

- (NSArray <BC_Sketch *> *)checkForChanges:(NSArray <NSDictionary *> *)arrayCommon {
    
    NSMutableArray <BC_Sketch *> *arrayChanges = [NSMutableArray new];
    return arrayChanges;
}

- (void)populateTSV:(NSString *)stringData completion:(PopulateBlock)completionBlock {
    
    NSError *error = nil;
    NSManagedObjectContext *moc = [self.coreData managedObjectContext];
    
    BC_Sketch *object;
    
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
            if (![TsvObject validateColumns:arrayColumns arrayCompare:@[@"_id",@"sketch_id",@"vector_id",@"visible",@"copyrights",@"coordinates",@"cin_id",@"creation_time"]]) {
                break;
            }
        } else if (arrayColumns.count >= 6) {
            object = [NSEntityDescription insertNewObjectForEntityForName:self.entityName inManagedObjectContext:moc];
            object.primary_id   = arrayColumns[0];
            object.sketch_id        = arrayColumns[1];
            object.vector_id        = arrayColumns[2];
            object.level_of_service = arrayColumns[3];
            //ignore copyright
            object.lat_lon_array    = arrayColumns[5];
            object.cin_id            = arrayColumns[6];
            object.timestamp         = [NSDate dateWithTimeIntervalSince1970:[arrayColumns[7] integerValue]];
            j++;
        }
        i++;
        
        if (i % 100 == 0) {
            NSLog(@"sketch count = %zd", i);
        }
    }
    NSLog(@"Total sketch count = %zd, actual number saved = %zd", i, j);
    [self.coreData saveContext];
    
    completionBlock(i>0);
}


@end

//
//  OTCoreDataClearViewDevice.m
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

#import "OTCoreDataClearViewDevice.h"
#import "OTCoreData+Private.h"
#import "OTCoreDataBase+Private.h"
#import "NSObject+Collection.h"
#import "OTTransportTypes.h"
#import "TsvObject.h"

#import "CV_Device.h"

@implementation OTCoreDataClearViewDevice

- (instancetype)initWithCoreData:(id)parent {
    
    if (self = [super initWithCoreData:parent]) {
        self.entityName = kCoreDataEntityClearViewDevice;
        self.userDefaultsCurrentData = kUserDefaultsStampClearViewDevice;
        self.dataType = k_CommonType_ClearViewDevice;
        self.userDefaultsUse = @"oneT_UserDefaultsClearView";
    }
    return self;
}

- (NSArray <CV_Device *> *)populateTableWith:(id)data timestamp:(NSDate *)date {
    
    NSMutableArray <CV_Device *> *arrayChanges = [NSMutableArray new];
    return arrayChanges;
}

- (NSArray <CV_Device *> *)checkForChanges:(NSArray <NSDictionary *> *)arrayCommon {
    
    NSMutableArray <CV_Device *> *arrayChanges = [NSMutableArray new];
    return arrayChanges;
}

- (void)populateTSV:(NSString *)stringData completion:(PopulateBlock)completionBlock {
    
    [self setImportFilter];

    NSError *error = nil;
    NSManagedObjectContext *moc = [self.coreData managedObjectContext];
    
    CV_Device *object;
    
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
            if (![TsvObject validateColumns:arrayColumns arrayCompare:@[@"_id",@"sensor_id",@"title",@"description",@"type",@"latitude",@"longitude",@"changed",@"cin_id",@"creation_time"]]) {
                break;
            }
        } else if (arrayColumns.count >= 9 && i > 0) {
            NSNumber *latitude = @([arrayColumns[5] doubleValue]);
            NSNumber *longitude = @([arrayColumns[6] doubleValue]);
            if (![self validForImport:latitude lon:longitude]) {
                NSLog(@"Failed lat/lon for %@, %@", row, self);
            } else {
                object = [NSEntityDescription insertNewObjectForEntityForName:self.entityName inManagedObjectContext:moc];
                object.primary_id     = arrayColumns[0];
                object.reference      = arrayColumns[1];
                object.title          = arrayColumns[2];
                object.comment        = arrayColumns[3];
                object.type           = arrayColumns[4];
                object.latitude       = latitude;
                object.longitude      = longitude;
                object.changed        = [self dateFromTsvString:arrayColumns[7]];
                object.cin_id         = arrayColumns[8];
                object.timestamp      = [NSDate dateWithTimeIntervalSince1970:[arrayColumns[9] integerValue]];
                j++;
            }
        }
        i++;
        
        if (i % 100 == 0) {
            NSLog(@"device count = %zd", i);
        }
    }
    NSLog(@"Total device count = %zd, actual number saved = %zd", i, j);
    [self.coreData saveContext];
    
    completionBlock(i>0);
}

@end

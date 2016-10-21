//
//  OTCoreDataBase.h
//  oneTRANSPORT
//
//  Created by Dominic Frazer Imregh on 19/08/2016.
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

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "OTTransportTypes.h"

@class OTCoreData;

@interface OTCoreDataBase : NSObject

@property (nonatomic, weak) OTCoreData * _Nullable coreData;
@property (nonatomic, copy) NSString * _Nonnull entityName;
@property (nonatomic, copy) NSString * _Nonnull userDefaultsCurrentData;
@property (nonatomic, copy) NSString * _Nonnull dataType;
@property (nonatomic, copy) NSString * _Nonnull userDefaultsUse;

/**
 * Initialises the object and the weak pointer to the coreData object
 */
- (_Nonnull instancetype)initWithCoreData:(id _Nonnull)parent;

/**
 * Get the NSUserDefault setting to decide if data should be requested
 */
- (BOOL)isAllowedToMakeRequest:(LocalAuthority)la;

/**
 * Initialises the fetch request based on the current entityName
 */
- (NSFetchRequest * _Nonnull)getFetchRequest;

/**
 * Gets the timestamp from the NSUserDefaults for the current entity
 */
- (NSDate * _Nonnull)getCurrentTimestamp;

/**
 * Saves the timestamp in the NSUserDefaults for the current entity
 * @param date The date to save
 */
- (void)setTimestamp:(NSDate * _Nonnull)date;

/**
 * Retrieves the total number of records for the current entity
 */
- (NSInteger)retrieveRecordCount;

/**
 * Retrieves all records for the current entity
 * @param predicateAnd An optional predicate to filter the record set
 */
- (NSArray * _Nonnull)retrieveAll:(NSPredicate * _Nullable)predicateAnd;

/**
 * Retrieves all history records for the current entity in timestamp descending order
 * @param reference The reference to fetch the history of
 */
- (NSArray * _Nonnull)retrieveHistory:(NSString * _Nonnull)reference;

/**
 * Remove all records in the current entity
 */
- (void)removeAll;

/**
 * Remove all aged records in the current entity based on the maximum number of hours to store the data for
 */
- (void)removeOld;

/**
 * Populate the table with the specified array of dictionaries and return an array of dictionaries to populate the Common table
 * @param data The data dictionary/array
 * @param date The timestamp of the CIN to apply to the new records
 */
- (NSArray * _Nonnull)populateTableWith:(id _Nonnull)data timestamp:(NSDate * _Nonnull)date;

/**
 * Cross reference the array of common items with the history of the table to establish if key data has changed
 * @param arrayCommon The array of dictionaries (see OTTransportTypes.h kCommonXxxx for a list of definitions)
 */
- (NSArray * _Nonnull)checkForChanges:(NSArray <NSDictionary *> * _Nonnull)arrayCommon;

@end

//
//  OTCoreDataCommon.m
//  oneTRANSPORT
//
//  Created by Dominic Frazer Imregh on 30/08/2016.
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

#import "OTCoreDataBase.h"
#import "Common.h"
#import <CoreLocation/CLLocation.h>

#define kCoreDataEntityCommon @"Common"

@interface OTCoreDataCommon : OTCoreDataBase

/**
 * Populate the Common table with the specified array of dictionaries
 * @param data The data dictionaries containing ["reference"], ["title"], ["lat"], ["lon"], ["timestamp"]
 * @param type The object type which is usually the OTCoreDataBase.dataType
 */
- (void)populateTableWith:(id _Nonnull)data type:(NSString * _Nonnull)type;

/** 
 * Remove the specified reference from the Common table
 * @param reference The reference to remove
 * @param type The type as a string which is usually the OTCoreDataBase.dataType
 */
- (void)removeReference:(NSString * _Nonnull)reference type:(NSString * _Nonnull)type;

/**
 * Retrieve all Common table records
 * @param queryString An optional predicate to filter the record set
 */
- (NSArray <Common *> * _Nonnull)retrieveAll:(NSString * _Nullable)queryString;

/**
 * Retrieve Common table records of a particular type
 * @param type The type required
 */
- (NSArray <Common *> * _Nonnull)retrieveType:(ObjectType)type;

/**
 * Retrieve Common table records of a particular type within a map region
 * @param type The type required
 * @param topLeft The top left coordinate to retrieve data for
 * @param bottomRight The bottom right coordinate to retrieve data for
 */
- (NSArray <Common *> * _Nonnull)retrieveType:(ObjectType)type topLeft:(CLLocationCoordinate2D)topLeft bottomRight:(CLLocationCoordinate2D)bottomRight;

/**
 * Retrieve a specific Common record
 * @param reference The reference to retrieve
 * @param type The object type which is usually the OTCoreDataBase.dataType
 */
- (Common * _Nullable)retrieve:(NSString * _Nonnull)reference type:(ObjectType)type;

/**
 * Return true if the specified record is marked as a favourite
 * @param reference The reference to retrieve
 * @param type The object type which is usually the OTCoreDataBase.dataType
 */
- (bool)isFavourite:(NSString * _Nonnull)reference type:(ObjectType)type;

/**
 * Sets the specified record as favourite
 * @param reference The reference to retrieve
 * @param type The object type which is usually the OTCoreDataBase.dataType
 * @param set True or False
 */
- (void)setFavourite:(NSString * _Nonnull)reference type:(ObjectType)type set:(BOOL)set;

/* Get the objectType string value used to record the object type in core data
 * @param type The ObjectType required
 */
- (NSString * _Nonnull)objectTypeAsString:(ObjectType)type;

/* Get the objectType enum value used to record the object type in core data
 * @param typeString The ObjectType required
*/
- (ObjectType)objectTypeFromString:(NSString * _Nonnull)typeString;

/*
 *
 */
- (NSArray <NSDictionary *> * _Nonnull)retrieveDuplicates:(NSPredicate * _Nullable)predicate;

@end

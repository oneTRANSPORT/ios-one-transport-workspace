//
//  OTCoreDataClearViewDevice.h
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

#import "OTCoreDateBaseTsv.h"

#define kCoreDataEntityClearViewDevice @"CV_Device"
#define kUserDefaultsStampClearViewDevice @"oneT_UserDefaultsStampClearViewDevice"

@class CV_Device;

@interface OTCoreDataClearViewDevice : OTCoreDateBaseTsv

/**
 * Populate the table with the specified array of dictionaries and return an array of dictionaries to populate the Common table
 * @param data The data dictionary/array
 * @param date The timestamp of the CIN to apply to the new records
 */
- (NSArray <CV_Device *> * _Nonnull)populateTableWith:(id _Nonnull)data timestamp:(NSDate * _Nonnull)date;

/**
 * Cross reference the array of common items with the history of the table to establish if key data has changed
 * @param arrayCommon The array of dictionaries (see OTTransportTypes.h kCommonXxxx for a list of definitions)
 */
- (NSArray <CV_Device *> * _Nonnull)checkForChanges:(NSArray <NSDictionary *> * _Nonnull)arrayCommon;

@end

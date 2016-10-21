//
//  OTCoreDataVariableMessageSigns.h
//  oneTRANSPORT
//
//  Created by Dominic Frazer Imregh on 18/08/2016.
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
#import "VariableMessageSigns.h"

#define kCoreDataEntityVariable @"VariableMS"
#define kUserDefaultsStampVariableMS @"oneT_UserDefaultsStampVariableMS"

@interface OTCoreDataVariableMessageSigns : OTCoreDataBase

/**
 * Retrieve all records in the table
 * @param activeOnly Set to true to only return records from the current timestamp
 */
- (NSArray <VariableMessageSigns *> * _Nonnull)retrieveAll:(BOOL)activeOnly;

/**
 * Retrieves all history records for the current entity in timestamp descending order
 * @param reference The reference to fetch the history of
 */
- (NSArray <VariableMessageSigns *> * _Nonnull)retrieveHistory:(NSString * _Nonnull)reference;

@end

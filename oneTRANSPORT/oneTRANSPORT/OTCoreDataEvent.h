//
//  OTCoreDataEvent.h
//  oneTRANSPORT
//
//  Created by Dominic Frazer Imregh on 15/09/2016.
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

#import <oneTRANSPORT/oneTRANSPORT.h>
#import "Event.h"

#define kCoreDataEntityEvent    @"Event"
#define kUserDefaultsStampEvent @"oneT_UserDefaultsStampEvent"

@interface OTCoreDataEvent : OTCoreDataBase

/**
 * Retrieve all records in the table
 */
- (NSArray <Event *> * _Nonnull)retrieveAll;

/**
 * Retrieves all history records for the current entity in timestamp descending order
 * @param reference The reference to fetch the history of
 */
- (NSArray <Event *> * _Nonnull)retrieveHistory:(NSString * _Nonnull)reference;

@end

//
//  OTCoreDataTrafficScoot.h
//  oneTRANSPORT
//
//  Created by Dominic Frazer Imregh on 07/10/2016.
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

@interface OTCoreDataTrafficScoot : OTCoreDataTraffic

#define kCoreDataEntityTrafficScoot @"TrafficScoot"

/**
 * Retrieve traffic array from core data
 * @param activeOnly Set to true to ignore averageSpeed == 0
 */
- (NSArray <TrafficScoot *> * _Nonnull)retrieveAll:(BOOL)activeOnly;

/**
 * Retrieve traffic array history of a specific reference from core data
 * @param reference The traffic item reference
 */
- (NSArray <TrafficScoot *> * _Nonnull)retrieveHistory:(NSString * _Nullable)reference;

@end

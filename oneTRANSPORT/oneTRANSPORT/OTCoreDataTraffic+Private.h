//
//  OTCoreDataTraffic+Private.h
//  oneTRANSPORT
//
//  Created by Dominic Frazer Imregh on 12/10/2016.
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

#import "OTCoreDataTraffic.h"

@interface OTCoreDataTraffic()

/**
 * Generate common data from standard traffic response feed
 * @param item The response item to add
 * @param latitude The latitude of the item to add
 * @param longitude The longitude of the item to add
 */
- (NSMutableDictionary *)buildCommon:(NSDictionary *)item lat:(NSNumber *)latitude lon:(NSNumber *)longitude;

/**
 * Convert standard traffic response data string to an NSDate
 * @param string The response item date string
 */
- (NSDate *)dateFromString:(NSString *)string;

@end

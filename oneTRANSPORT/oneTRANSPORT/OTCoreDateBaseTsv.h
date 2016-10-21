//
//  OTCoreDateBaseTsv.h
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

#import "OTCoreDataBase.h"
#import "OTTransportTypes.h"

@interface OTCoreDateBaseTsv : OTCoreDataBase

/**
 * Returns the TSV date string as an NSDate
 *
 * @param string The TSV date in the format '2016-09-04 19:01:12'
 */
- (NSDate *)dateFromTsvString:(NSString *)string;

/**
 * Empty method implemented by child classes
 *
 * @param stringData The TSV data string
 * @param completionBlock Completion block to execute as populate finishes
 */
- (void)populateTSV:(NSString *)stringData completion:(PopulateBlock)completionBlock;

@end

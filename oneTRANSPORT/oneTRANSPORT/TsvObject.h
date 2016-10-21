//
//  TsvObject.h
//  oneTRANSPORT
//
//  Created by Dominic Frazer Imregh on 12/09/2016.
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

@interface TsvObject : NSObject

/**
 * Prepare arrays from \n separated lines of data, returns rows
 */
+ (NSArray *)prepareTsvArray:(NSString *)stringData;

/**
 * Clean Tsv data by removing "" from around fields and \r, returns cleaned columns
 */
+ (NSArray *)cleanTsvColumns:(NSString *)row;

/**
 * Compare header row of TSV file with expected header, returns true if matching
 */
+ (BOOL)validateColumns:(NSArray *)array arrayCompare:(NSArray *)arrayCompare;

/**
 * Returns the standard date formatter expected for oneTransport dates, e.g. 2016-09-02T18:01:00Z
 */
+ (NSDateFormatter *)formatter;

@end

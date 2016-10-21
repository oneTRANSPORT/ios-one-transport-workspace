//
//  NSObject+Collection.h
//  oneTRANSPORT
//
//  Created by Dominic Frazer Imregh on 16/08/2016.
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

@interface NSObject (Collection)

/**
 * Returns the valid dictionary or an empty dictionary
 */
- (NSDictionary *)validateDictionary:(id)object;

/**
 * Returns the valid array or an empty array
 */
- (NSArray *)validateArray:(id)object;

/**
 * Returns the valid string or an empty string
 */
- (NSString *)validateString:(id)object;

/**
 * Returns the valid NSNumber object or an NSNumber object with 0
 */
- (NSNumber *)validateNumberInt:(id)object;

/**
 * Returns the valid NSNumber object or an NSNumber object with 0.0
 */
- (NSNumber *)validateNumberDouble:(id)object;

@end

//
//  OTLocationRegion.h
//  FlorenceSDK
//
//  Created by Dominic Frazer Imregh on 28/07/2016.
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
#import "OTTypes.h"

@class OTLocationRegionCircular;

@interface OTLocationRegion : NSObject

@property (nonatomic, strong) NSMutableArray <NSString *> * _Nonnull countryCode;  //2-character country code as defined by ISO-3166
#define kKey_CountryCode        @"accc"

@property (nonatomic, strong) OTLocationRegionCircular * _Nonnull circularRegion;
#define kKey_CircularRegion     @"accr"

/**
 * Updates the common resource parameters after a successful communications request
 *
 * @param dict Sub dictionary of params from the ACP
 */
- (void)updateCommonResources:(NSDictionary * _Nonnull)dict;

/**
 * Add the necessary object parameters to a dictionary for a Create/Update request
 *
 * @param method CommandTypeCreate or CommandTypeUpdate
 */
- (NSDictionary * _Nonnull)addPayload:(CommandType)method;

/**
 * Add a country code (if not found) to the existing array of country codes.
 *
 * @param code The 2 character string name of the country code
 */
- (void)addCountryCode:(NSString * _Nonnull)code;

/**
 * Remove a country code (if found) from the existing array of country codes.
 *
 * @param code The 2 character string name of the country code
 */
- (void)removeCountryCode:(NSString * _Nonnull)code;


@end

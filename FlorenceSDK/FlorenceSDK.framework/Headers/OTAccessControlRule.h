//
//  OTAccessControlRule.h
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
#import "OTAccessControlContext.h"
#import "OTLocationRegion.h"

@interface OTAccessControlRule : NSObject

@property (nonatomic, strong) NSMutableArray <NSString *> * _Nonnull accessControlOriginators;
#define kKey_AccessControlOriginators     @"acor"

@property (nonatomic)         AccessControlOperation accessControlOperations;
#define kKey_AccessControlOperations      @"acop"

@property (nonatomic, strong) NSMutableArray <OTAccessControlContext *> * _Nonnull accessControlContexts;
#define kKey_AccessControlContexts        @"acco"

@property (nonatomic, strong) NSMutableArray <OTLocationRegion *> * _Nonnull accessControlLocationRegions;
#define kKey_AccessControlLocationRegions @"aclr"

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
 * Add an originator (if not found) to the existing array of Control Originators.
 *
 * @param originator The string name of the originator, typically the name of an AE
 */
- (void)addControlOriginator:(NSString * _Nonnull)originator;

/**
 * Remove an originator (if found) from the existing array of Control Originators.
 *
 * @param originator The string name of the originator, typically the name of an AE
 */
- (void)removeControlOriginator:(NSString * _Nonnull)originator;

/**
 * Add a context (if not found) to the existing array of Control Contexts.
 *
 * @param context The context to add
 */
- (void)addControlContext:(OTAccessControlContext * _Nonnull)context;
    
/**
 * Remove a context (if found) from the existing array of Control Contexts.
 *
 * @param context The context to remove
 */
- (void)removeControlContext:(OTAccessControlContext * _Nonnull)context;
    
/**
 * Add a region (if not found) to the existing array of Location Regions.
 *
 * @param region The region to add
 */
- (void)addLocationRegion:(OTLocationRegion * _Nonnull)region;
    
/**
 * Remove a region (if found) from the existing array of Location Regions.
 *
 * @param region The region to remove
 */
- (void)removeLocationRegion:(OTLocationRegion * _Nonnull)region;

@end

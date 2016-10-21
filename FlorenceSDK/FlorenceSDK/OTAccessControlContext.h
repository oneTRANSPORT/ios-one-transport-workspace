//
//  OTAccessControlContext.h
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
#import "OTAccessControlIpAddress.h"

@interface OTAccessControlContext : NSObject

@property (nonatomic, strong) NSMutableArray <NSString *> * _Nonnull accessControlWindows;
#define kKey_AccessControlWindows     @"actw"

@property (nonatomic, strong) NSMutableArray <OTAccessControlIpAddress *> * _Nonnull accessControlIpAddresses;
#define kKey_AccessControlIpAddresses @"acip"

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
 * Add a Control Window date string (if not found) to the existing array of control window dates.
 *
 * @param dateString The dateString object
 */
- (void)addControlWindow:(NSString * _Nonnull)dateString;

/**
 * Remove a Control Window date string (if found) from the existing array of control window dates.
 *
 * @param dateString The dateString object
 */
- (void)removeControlWindow:(NSString * _Nonnull)dateString;
    
/**
 * Add an IP Address object (if not found) to the existing array of IP Address objects.
 *
 * @param ipAddr The IP Address object
 */
- (void)addControlIpAddress:(OTAccessControlIpAddress * _Nonnull)ipAddr;
    
/**
 * Remove an IP Address object (if found) from the existing array of IP Address objects.
 *
 * @param ipAddr The IP Address object
 */
- (void)removeControlIpAddress:(OTAccessControlIpAddress * _Nonnull)ipAddr;

@end

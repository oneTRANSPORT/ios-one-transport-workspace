//
//  OTSetOfAcrs.h
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
#import "OTAccessControlRule.h"

@interface OTSetOfAccessControlRules : NSObject

@property (nonatomic, strong) NSMutableArray <OTAccessControlRule *> * _Nonnull accessControlRules;
#define kKey_AccessControlRules     @"acr"

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
 * Add a new rule returning a pointer to the new rule
 *
 */
- (OTAccessControlRule * _Nonnull)addNewRule;

@end

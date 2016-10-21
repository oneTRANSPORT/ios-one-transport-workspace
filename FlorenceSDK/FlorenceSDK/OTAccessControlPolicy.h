//
//  IDAccessControlPolicy.h
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

#import <FlorenceSDK/FlorenceSDK.h>
#import "OTTypes.h"
#import "OTSetOfAccessControlRules.h"

@interface OTAccessControlPolicy : OTObjectAnnounceableResource

#define kKey_Response_Acp        @"m2m:acp"

@property (nonatomic, strong) OTSetOfAccessControlRules * _Nonnull  privileges;
#define kKey_Privileges          @"pv"

@property (nonatomic, strong) OTSetOfAccessControlRules * _Nonnull  selfPrivileges;
#define kKey_SelfPrivileges      @"pvs"

/**
 * Init resource for the ACP (Access Control Policy)
 *
 * @param resourceId The Id of the ACP
 * @param resourceName The name of the ACP
 * @param parent The parent object
 */
- (_Nonnull instancetype)initWithId:(NSString * _Nullable)resourceId
                               name:(NSString * _Nullable)resourceName
                             parent:(id _Nullable)parent;

/**
 * Updates the common resource parameters after a successful communications request
 *
 * @param dict Sub dictionary of params from the ACP
 */
- (void)updateCommonResources:(NSDictionary * _Nonnull)dict;

/**
 * Returns the payload key based on the object type
 *
 */
- (NSString * _Nonnull)payloadKey;

@end

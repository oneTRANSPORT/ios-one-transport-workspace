//
//  OTGroup.h
//  FlorenceSDK
//
//  Created by Dominic Frazer Imregh on 26/07/2016.
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

@interface OTGroup : OTObjectBase

#define kKey_Response_Grp           @"m2m:grp"
#define kKey_Response_Grp_Fotp      @"m2m:agr"

@property (nonatomic, copy)   NSString * _Nonnull  groupName;               
#define kKey_GroupName              @"gn"

@property (nonatomic, copy)   NSString * _Nonnull  fanOutPoint;
#define kKey_FanOutPoint            @"fopt"

@property (nonatomic)         NSInteger  memberType;
#define kKey_MemberType             @"mt"

@property (nonatomic)         NSInteger  currentNumberOfMembers;            
#define kKey_CurrentNumberOfMembers @"cnm"

@property (nonatomic)         NSInteger  maxNumberOfMembers;                
#define kKey_MaxNumberOfMembers     @"mnm"

@property (nonatomic, strong) NSMutableArray <NSString *> * _Nonnull memberIds;
#define kKey_MemberIds              @"mid"

@property (nonatomic, strong) NSMutableArray <NSString *> * _Nonnull memberAccessControlPolicies;
#define kKey_MemberAccessControlPolicies @"macp"

@property (nonatomic)         BOOL       memberTypeValidated;      
#define kKey_MemberTypeValidated    @"mtv"

@property (nonatomic)         NSInteger  consistencyStrategy;
#define kKey_ConsistencyStrategy    @"csy"

/**
 * Init resource for the Group
 *
 * @param resourceId The Id of the Group
 * @param resourceName The name of the Group
 */
- (_Nonnull instancetype)initWithId:(NSString * _Nullable)resourceId
                               name:(NSString * _Nullable)resourceName
                             parent:(id _Nullable)parent;

/**
 * Add object (if not found) to the existing array of URIs
 *
 * @param memberUri The URI of the object to add
 */
- (void)addMember:(NSString * _Nonnull)memberUri;

/**
 * Remove object (if found) from the existing array of URIs
 *
 * @param memberUri The URI of the object to remove
 *
 */
- (void)removeMember:(NSString * _Nonnull)memberUri;

/**
 * Add ACP (if not found) to the existing array of ACPs
 *
 * @param acpName The name of the ACP to add
 */
- (void)addAccessControlPolicy:(NSString * _Nonnull)acpName;

/**
 * Remove ACP (if found) from the existing array of ACPs
 *
 * @param acpName The name of the ACP to remove
 *
 */
- (void)removeAccessControlPolicy:(NSString * _Nonnull)acpName;

@end

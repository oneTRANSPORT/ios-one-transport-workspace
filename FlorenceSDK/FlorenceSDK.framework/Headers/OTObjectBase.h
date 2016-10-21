//
//  OTObjectBase.h
//  FlorenceSDK
//
//  Created by Dominic Frazer Imregh on 07/07/2016.
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

@class OTSessionTask;
@class OTApplicationEntity;

@interface OTObjectBase : NSObject

@property (nonatomic, copy)   NSString * _Nonnull resourceId;
#define kKey_ResourceId             @"ri"

@property (nonatomic, copy)   NSString * _Nonnull resourceName;
#define kKey_ResourceName           @"rn"

@property (nonatomic, strong) NSDate *   _Nonnull resourceCreated;
#define kKey_ResourceCreated        @"ct"

@property (nonatomic, strong) NSDate *   _Nonnull resourceLastUpdated;
#define kKey_ResourceLastUpdated    @"lt"

@property (nonatomic, strong) NSDate *   _Nonnull resourceExpires;
#define kKey_ResourceExpires        @"et"

@property (nonatomic)         NSInteger resourceRevision;
#define kKey_ResourceRevision       @"rr"

@property (nonatomic, strong) NSMutableArray <NSString *> * _Nonnull resourceLabels;
#define kKey_ResourceLabels         @"lbl"

@property (nonatomic, strong) NSMutableArray <NSString *> * _Nonnull accessControlPolicyIds; //Bug? an empty array will fail to update the server
#define kKey_AccessControlPolicyIds @"acpi"

@property (nonatomic, copy)   NSString * _Nonnull requestIdentifier; //for non-blocking requests

@property (nonatomic, weak) id _Nullable     parent;
@property (nonatomic) StatusCode             lastResponseStatusCode;
@property (nonatomic) CommunicationsProgress commsStatus;

/**
 * Returns the AE for the given object.
 * This object could be the AE itself or the method will traverse the parent objects until it reaches the AE
 *
 */
- (OTApplicationEntity * _Nullable)getApplicationEntity;

/**
 * Returns the full path for the given object, e.g. https://csedomain.net/ONETCSE01/C-IOS-AE-NAME/objectName
 *
 * @param subMethod The sub methods are for Group requests, eg. FanOut and Latest
 */
- (NSString * _Nullable)getFullPath:(SubCommandType)subMethod;

/**
 * Returns the path for the given object without the base url, e.g. ONETCSE01/C-IOS-AE-NAME/objectName
 *
 */
- (NSString * _Nullable)getPath;

/**
 * Makes a request to the CSE
 *
 * @param method The methods are: Create, Get, Delete, Discover
 * @param subMethod The sub methods control FanOut, Latest and Oldest extensions for groups and containers
 * @param arrayQuery Addtional URL query items
 * @param session The session object (this should be created prior to the call and can be common for all requests)
 * @param completionBlock The block of type CompletionType to execute on completion or an error
 */
- (void)remoteRequest:(CommandType)method
            subMethod:(SubCommandType)subMethod
 withAdditonalQueries:(NSArray <NSURLQueryItem *> * _Nullable)arrayQuery
              session:(OTSessionTask * _Nonnull)session
      completionBlock:(_Nonnull CompletionType)completionBlock;

/**
 * Makes a request to the CSE
 *
 * @param method The methods are: Create, Get, Delete, Discover
 * @param subMethod The sub methods control FanOut, Latest and Oldest extensions for groups and containers
 * @param session The session object (this should be created prior to the call and can be common for all requests)
 * @param completionBlock The block of type CompletionType to execute on completion or an error
 */
- (void)remoteRequest:(CommandType)method
            subMethod:(SubCommandType)subMethod
              session:(OTSessionTask * _Nonnull)session
      completionBlock:(_Nonnull CompletionType)completionBlock;

/**
 * Updates the common resource parameters after a successful communications request
 *
 * @param dict Sub dictionary of params from m2m:ae, m2m:cnt, m2m:cin, etc
 */
- (void)updateCommonResources:(NSDictionary * _Nonnull)dict;


/**
 * Add a resourceLabel (if not found) to the existing array of resourceLabels.
 *
 * @param label The string name of the resourceLabel
 */
- (void)addResourceLabel:(NSString * _Nonnull)label;

/**
 * Remove a resourceLabel (if found) from the existing array of resourceLabels.
 *
 * @param label The string name of the resourceLabel
 */
- (void)removeResourceLabel:(NSString * _Nonnull)label;

/**
 * Add an accessControlPolicyId (if not found) to the existing array of accessControlPolicyIds.
 *
 * @param policyId The string name of the policyId
 */
- (void)addAccessControlPolicyId:(NSString * _Nonnull)policyId;

/**
 * Remove an accessControlPolicyId (if found) from the existing array of accessControlPolicyIds.
 *
 * @param policyId The string name of the policyId
 */
- (void)removeAccessControlPolicyId:(NSString * _Nonnull)policyId;

@end

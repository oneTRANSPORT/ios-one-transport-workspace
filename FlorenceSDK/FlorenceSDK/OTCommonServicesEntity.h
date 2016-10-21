//
//  OTCommonServicesEntity.h
//  FlorenceSDK
//
//  Created by Dominic Frazer Imregh on 05/07/2016.
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

#import "OTObjectBase.h"

@class OTApplicationEntity;
@class OTSessionTask;
@class OTGroup;
@class OTAccessControlPolicy;

@interface OTCommonServicesEntity : OTObjectBase

@property (nonatomic, copy) NSString * _Nonnull baseUrl;
@property (nonatomic, copy) NSString * _Nonnull appId;
@property (nonatomic, strong) NSMutableArray <OTApplicationEntity *> * _Nonnull arrayAe;
@property (nonatomic, strong) NSMutableArray <OTGroup *> * _Nonnull arrayGroup;
@property (nonatomic, strong) NSMutableArray <OTAccessControlPolicy *> * _Nonnull arrayAcp;

/**
 * Init resource
 *
 * @param baseUrl The Url for the CSE
 * @param resourceId The Id of the CSE
 * @param resourceName The name of the CSE
 */
- (_Nonnull instancetype)initWithBaseUrl:(NSString * _Nonnull)baseUrl
                                   appId:(NSString * _Nonnull)appId
                              resourceId:(NSString * _Nonnull)resourceId
                            resourceName:(NSString * _Nonnull)resourceName;

/**
 * Return the AE object if know by the local CSE object
 *
 * @param resourceId The Id of the required AE
 */
- (OTApplicationEntity * _Nullable)aeWithId:(NSString * _Nonnull)resourceId;

/**
 * Creates a local AE object, returns an existing AE or a newly created AE if the resourceName was not found
 *
 * @param resourceId The Id of the required AE
 * @param resourceName The Name of the required AE
 */
- (OTApplicationEntity * _Nullable)createAeWithId:(NSString * _Nonnull)resourceId
                                             name:(NSString * _Nonnull)resourceName;


/**
 * Return the Group object if know by the local CSE object
 *
 * @param resourceName The name of the required group
 */
- (OTGroup * _Nullable)groupWithName:(NSString * _Nonnull)resourceName;

/**
 * Creates a local Group object, returns an existing Group or a newly created Group if the resourceName was not found
 *
 * @param resourceName The Name of the required Group
 */
- (OTGroup * _Nullable)createGroupWithName:(NSString * _Nonnull)resourceName;

/**
 * Returns the URI for the specified resource name if it is exposed in the local object tree
 *
 * @param resourceName The Name of the required resource
 */
- (NSString * _Nullable)uriForResourceName:(NSString * _Nonnull)resourceName;

/**
 * Return the ACP object if know by the local CSE object
 *
 * @param resourceName The name of the required ACP
 */
- (OTAccessControlPolicy * _Nullable)acpWithName:(NSString * _Nonnull)resourceName;

/**
 * Creates a local ACP object, returns an existing ACP or a newly created ACP if the resourceName was not found
 *
 * @param resourceName The Name of the required ACP
 */
- (OTAccessControlPolicy * _Nonnull)createAcpWithName:(NSString * _Nonnull)resourceName;

@end

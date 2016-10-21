//
//  OTApplicationEntity.h
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

#import "OTObjectAnnounceableResource.h"

@class OTContainer;
@class OTAccessControlPolicy;
@class OTContentInstance;

@interface OTApplicationEntity : OTObjectAnnounceableResource

#define kKey_Response_Ae            @"m2m:ae"

@property (nonatomic, strong) NSMutableArray <OTContainer *> * _Nullable arrayContainers;
@property (nonatomic, strong) NSMutableArray <OTContentInstance *> * _Nonnull arrayContent;

@property (nonatomic, copy)   NSString * _Nonnull applicationId;
#define kKey_ApplicationId          @"api"

@property (nonatomic, strong) NSArray <NSString *> * _Nonnull pointOfAccessList;
#define kKey_PointOfAccessList      @"poa"

@property (nonatomic, copy)   NSString * _Nonnull ontologyReference;
#define kKey_OntologyReference      @"or"

@property (nonatomic)         BOOL                requestReachable;    
#define kKey_RequestReachable       @"rr"

@property (nonatomic, copy)   NSString * _Nonnull nodeLink;
#define kKey_NodeLink               @"nl"

/**
 * Init resource the AE (Application Entity)
 *
 * @param resourceId The Id of the AE
 * @param resourceName The name of the AE
 */
- (_Nonnull instancetype)initWithId:(NSString * _Nullable)resourceId
                               name:(NSString * _Nullable)resourceName
                              appId:(NSString * _Nonnull)appId
                             parent:(id _Nullable)parent;

/**
 * Returns the CNT (Container) object for the specified resource name or nil if not found
 *
 * @param resourceName The name of the CNT
 */
- (OTContainer * _Nullable)containerWithName:(NSString * _Nonnull)resourceName;

/**
 * Returns the CNT (Container) object for the specified resource name and creates a local object if not found
 *
 * @param resourceName The name of the CNT
*/
- (OTContainer * _Nonnull)createContainerWithName:(NSString * _Nonnull)resourceName;

/**
 * Returns the CIN (Content) object for the specified resource name or nil if not found
 *
 * @param resourceName The name of the CIN
 */
- (OTContentInstance * _Nullable)contentWithName:(NSString * _Nonnull)resourceName;

/**
 * Returns the CIN (Content) object for the specified resource name and creates a local object if not found
 *
 * @param resourceName The name of the CNT
 */
- (OTContentInstance * _Nullable)createContentInstanceWithName:(NSString * _Nonnull)resourceName;

/**
 * Makes a request to the CSE and updates the local object with the response data
 *
 * @param session The session object (this should be created prior to the call and can be common for all requests)
 * @param completionBlock The block of type CompletionType to execute on completion or an error
 */
- (void)refreshContents:(OTSessionTask * _Nonnull)session
        completionBlock:(_Nonnull CompletionType)completionBlock;

/**
 * Retrieves and updates the lcoal object from the CSE and then makes requests to retrieve and populate all local child objects
 *
 * @param session The session object (this should be created prior to the call and can be common for all requests)
 * @param completionBlock The block of type CompletionType to execute on completion or an error
 */
- (void)retrieveAndCreateFromList:(OTSessionTask * _Nonnull)session
                  completionBlock:(_Nonnull CompletionType)completionBlock;

/**
 * Returns the ACP (Access Control Policy) object for the specified resource name or nil if not found
 *
 * @param resourceName The name of the ACP
 */
- (OTAccessControlPolicy * _Nullable)acpWithName:(NSString * _Nonnull)resourceName;

/**
 * Returns the ACP (Access Control Policy) object for the specified resource name and creates a local object if not found
 *
 * @param resourceName The name of the ACP
 */
- (OTAccessControlPolicy * _Nullable)createAcpWithName:(NSString * _Nonnull)resourceName;

@end

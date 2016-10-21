//
//  OTObjectBase+Private.h
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

#import "OTObjectBase.h"

@interface OTObjectBase()

/**
 * Init resource base. This is common for AE (Application Entity), CNT (Container), CIN (ContentInstance) objects
 *
 * @param resourceId The Id of the AE/CNT/CIN
 * @param resourceName The name of the AE/CNT/CIN
 */
- (_Nonnull instancetype)initWithId:(NSString * _Nullable)resourceId
                               name:(NSString * _Nullable)resourceName
                             parent:(id _Nullable)parent;

/**
 * Populate the payload for create and update methods
 *
 * @param dictSub Dictionary of params to add to
 * @param method Either Create or Update method type
 */
- (void)setPayload:(NSMutableDictionary * _Nonnull)dictSub method:(CommandType)method;

/**
 * Returns the payload key based on the object type
 *
 */
- (NSString * _Nonnull)payloadKey;

/**
 * Returns the M2M date string as an NSDate
 *
 * @param string The M2M date
 */
- (NSDate * _Nonnull)dateFromString:(NSString * _Nonnull)string;

/**
 * Empty method that is implemented by the individual AE/CN objects
 * Makes a request to the CSE and updates the local object with the response data
 *
 * @param session The session object (this should be created prior to the call and can be common for all requests)
 * @param completionBlock The block of type CompletionType to execute on completion or an error
 */
- (void)refreshContents:(OTSessionTask * _Nonnull)session
        completionBlock:(_Nonnull CompletionType)completionBlock;

/**
 * Empty method that is implemented by the individual AE/CN objects
 * Retrieves and updates the lcoal object from the CSE and then makes requests to retrieve and populate all local child objects
 *
 * @param session The session object (this should be created prior to the call and can be common for all requests)
 * @param completionBlock The block of type CompletionType to execute on completion or an error
 */
- (void)retrieveAndCreateFromList:(OTSessionTask * _Nonnull)session
                  completionBlock:(_Nonnull CompletionType)completionBlock;

@end
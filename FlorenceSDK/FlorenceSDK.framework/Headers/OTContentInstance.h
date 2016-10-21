//
//  OTContentInstance.h
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

@class OTApplicationEntity;

@interface OTContentInstance : OTObjectAnnounceableResource

#define kKey_Response_Cin           @"m2m:cin"

@property (nonatomic, copy)   NSString * _Nonnull creator;
#define kKey_Creator                @"cr"

@property (nonatomic, copy)   NSString * _Nonnull contentInfo;
#define kKey_ContentInfo            @"cnf"

@property (nonatomic, copy)   NSString * _Nonnull content;     
#define kKey_Content                @"con"

@property (nonatomic)         NSInteger  contentSize;             
#define kKey_ContentSize            @"cs"

@property (nonatomic)         NSInteger  stateTag;
#define kKey_StateTag               @"st"

/**
 * Init resource for the CIN (ContentInstance)
 *
 * @param resourceId The Id of the CIN
 * @param resourceName The name of the CIN
 */
- (_Nonnull instancetype)initWithId:(NSString * _Nullable)resourceId
                               name:(NSString * _Nullable)resourceName
                             parent:(id _Nullable)parent;

/**
 * Makes repeated requests to the CSE and updates the local object with the response data
 *
 * @param session The session object (this should be created prior to the call and can be common for all requests)
 * @param interval The number of seconds before the next refresh attempt is made
 * @param completionBlock The block of type CompletionType to execute on completion or an error
 */
- (void)refreshContents:(OTSessionTask * _Nonnull)session
               interval:(NSTimeInterval)interval
        completionBlock:(_Nonnull CompletionType)completionBlock;

/**
 * Cancels the repeated requests
 *
 */
- (void)cancelRefresh;

@end

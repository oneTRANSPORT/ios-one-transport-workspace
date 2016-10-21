//
//  IDSessionTask.h
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

#import <Foundation/Foundation.h>
#import "OTTypes.h"

@interface OTSessionTask : NSObject

@property (nonatomic, copy) NSString * _Nullable auth;
@property (nonatomic, copy) NSString * _Nullable origin;

#define kKeyUserDefaults_TimeOut        @"InterDigital_UserDefaultsTimeout"
#define kKeyUserDefaults_Connections    @"InterDigital_UserDefaultsConnections"
#define kDefaultTimeout                 10
#define kDefaultConnections             3
#define kMaxConnections                 5

/**
 * Set the authentication username and password for the session
 *
 * @param auth The auth token or nil
 */
- (void)setAuth:(NSString * _Nonnull)auth origin:(NSString * _Nonnull)origin;

/**
 * Set the default time out and number of connections for communications requests
 *
 * @param timeout The timeout in seconds for each request (default is 10)
 * @param connections The number of concurrent connections (default is 3, maximum is 5)
 */
- (void)setTimeOut:(NSInteger)timeout connections:(NSInteger)connections;

/** 
 * Cancel all requests in the request queue
 * cancellation within the completion blocks
 *
 */
- (void)cancelRequestQueue;

/**
 * Make remote request for Create, Get, Delete, Discover
 *
 * @param request The request returned by the OTUrlRequestMap method prepareRequest::
 * @param completionBlock The block of type CompletionType to execute on completion or an error
 */
- (void)executeRequest:(NSURLRequest * _Nonnull)request
            completion:(_Nonnull CompletionType)completionBlock;

@end

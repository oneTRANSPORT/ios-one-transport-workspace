//
//  OTUrlRequestMap.h
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
@class OTObjectBase;

@interface OTUrlRequestMap : NSObject

/**
 * Prepare request for Create, Get, Delete, Discover with overriding URL
 *
 * @param method The methods are: Create, Get, Delete, Discover
 * @param subMethod The sub methods are for Group requests, eg. FanOut and Latest
 * @param authName The user name for basic authentication
 * @param authPassword The user password for basic authentication
 * @param resource The CSE/AE/CN/CI/Grp object to derive the request from
 * @param url The URL to use to replace the dynamically generated URL
 */
+ (NSURLRequest * _Nullable)prepareRequest:(CommandType)method
                                 subMethod:(SubCommandType)subMethod
                                      auth:(NSString * _Nonnull)auth
                                    origin:(NSString * _Nonnull)origin
                               forResource:(id _Nonnull)resource
                                   withURL:(NSURL * _Nonnull)url;

/**
 * Prepare request for Create, Get, Delete, Discover with additional URL parameters
 *
 * @param method The methods are: Create, Get, Delete, Discover
 * @param subMethod The sub methods are for Group requests, eg. FanOut and Latest
 * @param authName The user name for basic authentication
 * @param authPassword The user password for basic authentication
 * @param resource The CSE/AE/CN/CI/Grp object to derive the request from
 * @param arrayQuery Any additional query components that you wish to append to the URL
 */
+ (NSURLRequest * _Nullable)prepareRequest:(CommandType)method
                                 subMethod:(SubCommandType)subMethod
                                      auth:(NSString * _Nonnull)auth
                                    origin:(NSString * _Nonnull)origin
                               forResource:(id _Nonnull)resource
                      withAdditonalQueries:(NSArray * _Nullable)arrayQuery;

/**
 * Prepare request for Create, Get, Delete, Discover
 *
 * @param method The methods are: Create, Get, Delete, Discover
 * @param subMethod The sub methods are for Group requests, eg. FanOut and Latest
 * @param authName The user name for basic authentication
 * @param authPassword The user password for basic authentication
 * @param resource The CSE/AE/CN/CI/Grp object to derive the request from
 */
+ (NSURLRequest * _Nullable)prepareRequest:(CommandType)method
                                 subMethod:(SubCommandType)subMethod
                                      auth:(NSString * _Nonnull)auth
                                    origin:(NSString * _Nonnull)origin
                               forResource:(id _Nonnull)resource;

/**
 * Returns the URL for the given resource
 *
 * @param method The methods are: Create, Get, Delete, Discover
 * @param subMethod The sub methods are for Group requests, eg. FanOut and Latest
 * @param resource The CSE/AE/CN/CI/Grp object to derive the request from
 */
+ (NSURL * _Nullable)generateUrl:(CommandType)method
                       subMethod:(SubCommandType)subMethod
                     forResource:(id _Nonnull)resource;

@end

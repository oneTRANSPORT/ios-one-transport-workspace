//
//  BaseTest.h
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

#import <XCTest/XCTest.h>

#ifndef BaseTest_h
#define BaseTest_h

#define k_APP_ID        @"C-IOS-APPID"

#define k_APP_USERNAME  @"username"
#define k_APP_PASSWORD  @"password"

#define k_CSE_BASEURL_DEV   @"http://13.90.209.19:9011"
#define k_CSE_ID        @"ONE-CSE-01"
#define k_CSE_NAME      @"ONETCSE01"

#define k_AE_ID         @"C-IOS2"
#define k_AE_NAME       @"C-IOS-AE-NAME2"

#define k_CNT_NAME      @"carparkSqlData"

#define k_CIN_NAME      @"contentName"

#endif

@interface BaseTest : XCTestCase

@end

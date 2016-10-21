//
//  ServiceMapTests.m
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

#import "BaseTest.h"
#import "OTCommonServicesEntity.h"
#import "OTApplicationEntity.h"
#import "OTContainer.h"
#import "OTGroup.h"
#import "OTAccessControlPolicy.h"

#import "OTUrlRequestMap.h"

@interface ServiceMapTests : BaseTest

@property (nonatomic, strong) OTCommonServicesEntity *cse;

@end

#define k_SubContainerName  @"123"

@implementation ServiceMapTests

#pragma mark - Application Entity URL

- (OTApplicationEntity *)getAe {
    
    self.cse = [[OTCommonServicesEntity alloc] initWithBaseUrl:k_CSE_BASEURL_DEV appId:k_APP_ID resourceId:k_CSE_ID resourceName:k_CSE_NAME];
    return [self.cse createAeWithId:k_AE_ID name:k_AE_NAME];
}

- (OTContainer *)getContainer {
    OTApplicationEntity *ae = [self getAe];
    
    return [ae createContainerWithName:k_CNT_NAME];
}

- (NSURLRequest *)getRequestAeTest:(CommandType)method {
    
    OTApplicationEntity *ae = [self getAe];
    return [OTUrlRequestMap prepareRequest:method subMethod:SubCommandTypeNone auth:@"" origin:@"" forResource:ae];
}

- (void)testUrlGeneration_Ae_Create {
    
    NSURLRequest *request = [self getRequestAeTest:CommandTypeCreate];
    
    NSString *expectedResponse = [NSString stringWithFormat:@"%@/%@", k_CSE_BASEURL_DEV, k_CSE_NAME];
    XCTAssertTrue([request.URL.absoluteString hasPrefix:expectedResponse]);
    XCTAssertTrue([@"POST" isEqualToString:request.HTTPMethod]);
}

- (void)testUrlGeneration_Ae_Get {
    
    NSURLRequest *request = [self getRequestAeTest:CommandTypeGet];
    
    NSString *expectedResponse = [NSString stringWithFormat:@"%@/%@/%@", k_CSE_BASEURL_DEV, k_CSE_NAME, k_AE_NAME];
    XCTAssertTrue([request.URL.absoluteString hasPrefix:expectedResponse]);
    XCTAssertTrue([@"GET" isEqualToString:request.HTTPMethod]);
}

- (void)testUrlGeneration_Ae_Discover {
    
    NSURLRequest *request = [self getRequestAeTest:CommandTypeDiscover];
    
    NSString *expectedResponse = [NSString stringWithFormat:@"%@/%@/%@?fu=1&rty=3", k_CSE_BASEURL_DEV, k_CSE_NAME, k_AE_NAME]; //discovering containers
    XCTAssertTrue([expectedResponse isEqualToString:request.URL.absoluteString]);
    XCTAssertTrue([@"GET" isEqualToString:request.HTTPMethod]);
}

#pragma mark - Container URL

- (NSURLRequest *)getRequestContainerTest:(CommandType)method {

    OTContainer *container = [self getContainer];
    
    return [OTUrlRequestMap prepareRequest:method subMethod:SubCommandTypeNone auth:@"" origin:@"" forResource:container];
}


- (void)testUrlGeneration_Container_Create {
    NSURLRequest *request = [self getRequestContainerTest:CommandTypeCreate];
    
    NSString *expectedResponse = [NSString stringWithFormat:@"%@/%@/%@", k_CSE_BASEURL_DEV, k_CSE_NAME, k_AE_NAME];
    XCTAssertTrue([request.URL.absoluteString hasPrefix:expectedResponse]);
    XCTAssertTrue([@"POST" isEqualToString:request.HTTPMethod]);
}

- (void)testUrlGeneration_Container_Get {
    
    NSURLRequest *request = [self getRequestContainerTest:CommandTypeGet];
    
    NSString *expectedResponse = [NSString stringWithFormat:@"%@/%@/%@/%@", k_CSE_BASEURL_DEV, k_CSE_NAME, k_AE_NAME, k_CNT_NAME];
    XCTAssertTrue([request.URL.absoluteString hasPrefix:expectedResponse]);
    XCTAssertTrue([@"GET" isEqualToString:request.HTTPMethod]);
}

- (void)testUrlGeneration_Container_Discover {
    
    NSURLRequest *request = [self getRequestContainerTest:CommandTypeDiscover];
    
    NSString *expectedResponse = [NSString stringWithFormat:@"%@/%@/%@/%@?fu=1&rty=4", k_CSE_BASEURL_DEV, k_CSE_NAME, k_AE_NAME, k_CNT_NAME];
    XCTAssertTrue([expectedResponse isEqualToString:request.URL.absoluteString]);
    XCTAssertTrue([@"GET" isEqualToString:request.HTTPMethod]);
}

#pragma mark - Container Within Container URL

- (NSURLRequest *)getRequestContainerWithinContainerTest:(CommandType)method {

    OTContainer *container = [self getContainer];
    OTContainer *containerSub = [container createContainerWithName:k_SubContainerName];
    
    return [OTUrlRequestMap prepareRequest:method subMethod:SubCommandTypeNone auth:@"" origin:@"" forResource:containerSub];
}

- (void)testUrlGeneration_ContainerWithinContainer_Create {
    
    NSURLRequest *request = [self getRequestContainerWithinContainerTest:CommandTypeCreate];
    
    NSString *expectedResponse = [NSString stringWithFormat:@"%@/%@/%@/%@", k_CSE_BASEURL_DEV, k_CSE_NAME, k_AE_NAME, k_CNT_NAME];
    XCTAssertTrue([request.URL.absoluteString hasPrefix:expectedResponse]);
    XCTAssertTrue([@"POST" isEqualToString:request.HTTPMethod]);
}

- (void)testUrlGeneration_ContainerWithinContainer_Get {
    
    NSURLRequest *request = [self getRequestContainerWithinContainerTest:CommandTypeGet];
    
    NSString *expectedResponse = [NSString stringWithFormat:@"%@/%@/%@/%@/%@", k_CSE_BASEURL_DEV, k_CSE_NAME, k_AE_NAME, k_CNT_NAME, k_SubContainerName];
    XCTAssertTrue([request.URL.absoluteString hasPrefix:expectedResponse]);
    XCTAssertTrue([@"GET" isEqualToString:request.HTTPMethod]);
}

- (void)testUrlGeneration_ContainerWithinContainer_Discover {
    
    NSURLRequest *request = [self getRequestContainerWithinContainerTest:CommandTypeDiscover];
    
    NSString *expectedResponse = [NSString stringWithFormat:@"%@/%@/%@/%@/%@?fu=1&rty=4", k_CSE_BASEURL_DEV, k_CSE_NAME, k_AE_NAME, k_CNT_NAME, k_SubContainerName];
    XCTAssertTrue([expectedResponse isEqualToString:request.URL.absoluteString]);
    XCTAssertTrue([@"GET" isEqualToString:request.HTTPMethod]);
}

#pragma mark - Content URL

- (NSURLRequest *)getRequestContentTest:(CommandType)method {
    
    OTContainer *container = [self getContainer];
    OTContentInstance *content = [container createContentInstanceWithName:k_CIN_NAME];
    
    return [OTUrlRequestMap prepareRequest:method subMethod:SubCommandTypeNone auth:@"" origin:@"" forResource:content];
}

- (void)testUrlGeneration_Content_Create {
    
    NSURLRequest *request = [self getRequestContentTest:CommandTypeCreate];
    
    NSString *expectedResponse = [NSString stringWithFormat:@"%@/%@/%@/%@", k_CSE_BASEURL_DEV, k_CSE_NAME, k_AE_NAME, k_CNT_NAME];
    XCTAssertTrue([request.URL.absoluteString hasPrefix:expectedResponse]);
    XCTAssertTrue([@"POST" isEqualToString:request.HTTPMethod]);
}

- (void)testUrlGeneration_Content_Get {
    
    NSURLRequest *request = [self getRequestContentTest:CommandTypeGet];
    
    NSString *expectedResponse = [NSString stringWithFormat:@"%@/%@/%@/%@/%@", k_CSE_BASEURL_DEV, k_CSE_NAME, k_AE_NAME, k_CNT_NAME, k_CIN_NAME];
    XCTAssertTrue([request.URL.absoluteString hasPrefix:expectedResponse]);
    XCTAssertTrue([@"GET" isEqualToString:request.HTTPMethod]);
}

- (void)testUrlGeneration_Content_Get_Plus_Additional {
    
    OTContainer *container = [self getContainer];
    OTContentInstance *content = [container createContentInstanceWithName:k_CIN_NAME];
    
    NSMutableArray *arrayQuery = [NSMutableArray new];
    [arrayQuery addObject:[NSURLQueryItem queryItemWithName:@"rcn" value:@"6"]];

    NSURLRequest *request = [OTUrlRequestMap prepareRequest:CommandTypeGet subMethod:SubCommandTypeNone auth:@"" origin:@"" forResource:content withAdditonalQueries:arrayQuery];

    NSString *expectedResponse = [NSString stringWithFormat:@"%@/%@/%@/%@/%@?rcn=6", k_CSE_BASEURL_DEV, k_CSE_NAME, k_AE_NAME, k_CNT_NAME, k_CIN_NAME];
    XCTAssertTrue([request.URL.absoluteString hasPrefix:expectedResponse]);
    XCTAssertTrue([@"GET" isEqualToString:request.HTTPMethod]);
}

- (void)testUrlGeneration_Content_Discover {
    
    NSURLRequest *request = [self getRequestContentTest:CommandTypeDiscover];
    
    NSString *expectedResponse = [NSString stringWithFormat:@"%@/%@/%@/%@/%@?fu=1&rty=4", k_CSE_BASEURL_DEV, k_CSE_NAME, k_AE_NAME, k_CNT_NAME, k_CIN_NAME];
    XCTAssertTrue([request.URL.absoluteString hasPrefix:expectedResponse]);
    XCTAssertTrue([@"GET" isEqualToString:request.HTTPMethod]);
}

#pragma mark - Headers

- (void)testHeaderGeneration_Ae {
    
    OTCommonServicesEntity *cse = [[OTCommonServicesEntity alloc] initWithBaseUrl:k_CSE_BASEURL_DEV appId:k_APP_ID resourceId:k_CSE_ID resourceName:k_CSE_NAME];
    [cse createAeWithId:k_AE_ID name:k_AE_NAME];
    
    OTApplicationEntity *ae = [cse aeWithId:k_AE_ID];
    
    NSURLRequest *request = [OTUrlRequestMap prepareRequest:CommandTypeCreate subMethod:SubCommandTypeNone auth:@"<bearer>" origin:@"<origin>" forResource:ae];
    
    XCTAssertTrue ([@"<origin>" isEqualToString:request.allHTTPHeaderFields[@"X-M2M-Origin"]]);
    XCTAssertFalse([k_CNT_NAME isEqualToString:request.allHTTPHeaderFields[@"X-M2M-NM"]]);
    XCTAssertTrue ([@"Bearer <bearer>" isEqualToString:request.allHTTPHeaderFields[@"Authorization"]]);
}


- (void)testHeaderGeneration_Container {
    
    OTContainer *container = [self getContainer];
    
    NSURLRequest *request = [OTUrlRequestMap prepareRequest:CommandTypeCreate subMethod:SubCommandTypeNone auth:@"<bearer>" origin:@"<origin>" forResource:container];
    
    XCTAssertTrue ([@"<origin>" isEqualToString:request.allHTTPHeaderFields[@"X-M2M-Origin"]]);
    XCTAssertTrue([k_CNT_NAME isEqualToString:request.allHTTPHeaderFields[@"X-M2M-NM"]]);
}

#pragma mark - Payload

- (void)testAePayload {
 
    OTApplicationEntity *ae = [self getAe];

    NSURLRequest *request = [OTUrlRequestMap prepareRequest:CommandTypeCreate subMethod:SubCommandTypeNone auth:@"" origin:@"" forResource:ae];
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:request.HTTPBody options:kNilOptions error:nil];

    XCTAssertNotNil(dict[@"ae"]);
    XCTAssertNotNil(dict[@"ae"][kKey_ApplicationId]);
    XCTAssertNotNil(dict[@"ae"][kKey_ResourceName]);
}

- (void)testCntPayload {
    
    OTContainer *container = [self getContainer];

    NSURLRequest *request = [OTUrlRequestMap prepareRequest:CommandTypeCreate subMethod:SubCommandTypeNone auth:@"" origin:@"" forResource:container];
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:request.HTTPBody options:kNilOptions error:nil];
    
    XCTAssertNotNil(dict[@"cnt"]);
    XCTAssertNotNil(dict[@"cnt"][kKey_ResourceName]);
}

- (void)testCinPayload {
    
    OTContainer *container = [self getContainer];
    OTContentInstance *content = [container createContentInstanceWithName:k_CIN_NAME];
    
    NSURLRequest *request = [OTUrlRequestMap prepareRequest:CommandTypeCreate subMethod:SubCommandTypeNone auth:@"" origin:@"" forResource:content];
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:request.HTTPBody options:kNilOptions error:nil];
    
    XCTAssertNotNil(dict[@"cin"]);
    XCTAssertNotNil(dict[@"cin"][kKey_ResourceName]);
}

- (void)testGrpPayload {
    
    [self getAe];
    OTGroup *group = [self.cse createGroupWithName:@"Group"];
    
    NSURLRequest *request = [OTUrlRequestMap prepareRequest:CommandTypeCreate subMethod:SubCommandTypeNone auth:@"" origin:@"" forResource:group];
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:request.HTTPBody options:kNilOptions error:nil];
    
    XCTAssertNotNil(dict[@"grp"]);
    XCTAssertNotNil(dict[@"grp"][kKey_ResourceName]);
}

- (void)testGrpPayloadFanOut {
    
    [self getAe];
    OTGroup *group = [self.cse createGroupWithName:@"Group"];
    
    NSURLRequest *request = [OTUrlRequestMap prepareRequest:CommandTypeCreate subMethod:SubCommandTypeFanOut auth:@"" origin:@"" forResource:group];
    
    XCTAssertTrue([request.URL.absoluteString hasSuffix:@"/fopt"]);
}

- (void)testAcpPayload {
    
    [self getAe];
    OTAccessControlPolicy *acp = [self.cse createAcpWithName:@"Acp"];
    
    NSURLRequest *request = [OTUrlRequestMap prepareRequest:CommandTypeCreate subMethod:SubCommandTypeNone auth:@"" origin:@"" forResource:acp];
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:request.HTTPBody options:kNilOptions error:nil];
    
    XCTAssertNotNil(dict[@"acp"]);
    XCTAssertNotNil(dict[@"acp"][kKey_ResourceName]);
}

@end

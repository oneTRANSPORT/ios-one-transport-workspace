//
//  ContentInstanceTests.m
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

@interface ContentInstanceTests : BaseTest

@property (nonatomic, strong) OTCommonServicesEntity *cse;

@end

@implementation ContentInstanceTests

- (OTApplicationEntity *)getAe {
    
    self.cse = [[OTCommonServicesEntity alloc] initWithBaseUrl:k_CSE_BASEURL_DEV appId:k_APP_ID resourceId:k_CSE_ID resourceName:k_CSE_NAME];
    [self.cse createAeWithId:k_AE_ID name:k_AE_NAME];
    
    OTApplicationEntity *ae = [self.cse aeWithId:k_AE_ID];
    return ae;
}

- (OTContainer *)getContainer {
    
    OTApplicationEntity *ae = [self getAe];
    return [ae createContainerWithName:k_CNT_NAME];
}

- (void)testContentInstanceCreate {

    OTContainer *container = [self getContainer];
    [container createContentInstanceWithName:k_CIN_NAME];
    
    XCTAssertTrue(container.arrayContent.count == 1);
}

- (void)testContentInstanceCreateDuplicate {
    
    OTContainer *container = [self getContainer];
    [container createContentInstanceWithName:k_CIN_NAME];
    [container createContentInstanceWithName:k_CIN_NAME];
    
    XCTAssertTrue(container.arrayContent.count == 1);
}

- (void)testContentInstanceTwoDifferent {
    
    OTContainer *container = [self getContainer];
    [container createContentInstanceWithName:k_CIN_NAME];
    [container createContentInstanceWithName:@"123"];
    
    XCTAssertTrue(container.arrayContent.count == 2);
}

- (void)testContentInstanceCreateOnAe {
    
    OTApplicationEntity *ae = [self getAe];
    [ae createContentInstanceWithName:k_CIN_NAME];
    
    XCTAssertTrue(ae.arrayContent.count == 1);
}

- (void)testContentInstanceCreateDuplicateOnAe {
    
    OTApplicationEntity *ae = [self getAe];
    [ae createContentInstanceWithName:k_CIN_NAME];
    [ae createContentInstanceWithName:k_CIN_NAME];
    
    XCTAssertTrue(ae.arrayContent.count == 1);
}

- (void)testContentInstanceTwoDifferentOnAe {
    
    OTApplicationEntity *ae = [self getAe];
    [ae createContentInstanceWithName:k_CIN_NAME];
    [ae createContentInstanceWithName:@"123"];
    
    XCTAssertTrue(ae.arrayContent.count == 2);
}

@end

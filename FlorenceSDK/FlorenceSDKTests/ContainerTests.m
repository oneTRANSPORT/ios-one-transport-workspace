//
//  ContainerTests.m
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

@interface ContainerTests : BaseTest

@property (nonatomic, strong) OTCommonServicesEntity *cse;

@end

@implementation ContainerTests

- (OTApplicationEntity *)getAe {
    
    self.cse = [[OTCommonServicesEntity alloc] initWithBaseUrl:k_CSE_BASEURL_DEV appId:k_APP_ID resourceId:k_CSE_ID resourceName:k_CSE_NAME];
    return [self.cse createAeWithId:k_AE_ID name:k_AE_NAME];
}

- (void)testContainerCreate {
    
    OTApplicationEntity *ae = [self getAe];
    [ae createContainerWithName:k_CNT_NAME];

    XCTAssertTrue(ae.arrayContainers.count == 1);
}

- (void)testContainerCreateDuplicate {
    
    OTApplicationEntity *ae = [self getAe];
    [ae createContainerWithName:k_CNT_NAME];
    [ae createContainerWithName:k_CNT_NAME];
    
    XCTAssertTrue(ae.arrayContainers.count == 1);
}

- (void)testContainerCreateTwoDifferent {
    
    OTApplicationEntity *ae = [self getAe];
    [ae createContainerWithName:@"123"];
    [ae createContainerWithName:@"234"];
    
    XCTAssertTrue(ae.arrayContainers.count == 2);
}

@end

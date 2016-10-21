//
//  GroupTests.m
//  FlorenceSDK
//
//  Created by Dominic Frazer Imregh on 28/07/2016.
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

@interface GroupTests : BaseTest

@end

#define k_GRP_NAME_1 @"Group1"
#define k_GRP_NAME_2 @"Group2"

@implementation GroupTests

- (OTCommonServicesEntity *)getCse {
    
    return [[OTCommonServicesEntity alloc] initWithBaseUrl:k_CSE_BASEURL_DEV appId:k_APP_ID resourceId:k_CSE_ID resourceName:k_CSE_NAME];
}

- (void)testGroupCreate {
    
    OTCommonServicesEntity *cse = [self getCse];
    [cse createGroupWithName:k_GRP_NAME_1];
    
    XCTAssertTrue(cse.arrayGroup.count == 1);
}

- (void)testGroupCreateDuplicate {
    
    OTCommonServicesEntity *cse = [self getCse];
    [cse createGroupWithName:k_GRP_NAME_1];
    [cse createGroupWithName:k_GRP_NAME_1];
    
    XCTAssertTrue(cse.arrayGroup.count == 1);
}

- (void)testGroupCreateTwoDifferent {
    
    OTCommonServicesEntity *cse = [self getCse];
    [cse createGroupWithName:k_GRP_NAME_1];
    [cse createGroupWithName:k_GRP_NAME_2];
    
    XCTAssertTrue(cse.arrayGroup.count == 2);
}

@end

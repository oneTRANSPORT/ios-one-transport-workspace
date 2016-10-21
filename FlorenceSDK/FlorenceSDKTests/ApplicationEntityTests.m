//
//  ApplicationEntityTests.m
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

@interface ApplicationEntityTests : BaseTest

@end

@implementation ApplicationEntityTests

- (OTCommonServicesEntity *)getCse {
    
    return [[OTCommonServicesEntity alloc] initWithBaseUrl:k_CSE_BASEURL_DEV appId:k_APP_ID resourceId:k_CSE_ID resourceName:k_CSE_NAME];
}

- (void)testAeCreate {
    
    OTCommonServicesEntity *cse = [self getCse];
    [cse createAeWithId:k_AE_ID name:k_AE_NAME];
    
    XCTAssertTrue(cse.arrayAe.count == 1);
    
    OTApplicationEntity *ae = [cse aeWithId:k_AE_ID];
    XCTAssertTrue([ae.resourceId isEqualToString:k_AE_ID]);
    XCTAssertNotNil(ae.arrayContainers);
}

- (void)testAeCreateDuplicate {

    OTCommonServicesEntity *cse = [self getCse];
    [cse createAeWithId:k_AE_ID name:k_AE_NAME];
    [cse createAeWithId:k_AE_ID name:k_AE_NAME];
    
    XCTAssertTrue(cse.arrayAe.count == 1);
}

- (void)testAeCreateTwoDifferent {
    
    OTCommonServicesEntity *cse = [self getCse];
    [cse createAeWithId:@"123" name:k_AE_NAME];
    [cse createAeWithId:@"234" name:k_AE_NAME];
    
    XCTAssertTrue(cse.arrayAe.count == 2);
}

@end

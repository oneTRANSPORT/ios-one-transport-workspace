//
//  OneTransportBCNode.m
//  oneTRANSPORT
//
//  Created by Dominic Frazer Imregh on 13/09/2016.
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

#import "OneTransportBaseTests.h"

@interface OneTransportBCNode : OneTransportBaseTests

@end

@implementation OneTransportBCNode

- (NSString *)stringSimple {

    return @"_id\tnode_id\tcustomer_id\tcustomer_name\tlatitude\tlongitude\tcin_id\tcreation_time\t1\t1159\t2\t2-A43 at Blisworth\t52.177441\t-0.955571\tcin19890203T144936602520576139987200866048\t1471392011";
}

- (NSString *)stringFail {
    
    return @"_id\tnode_id\tcustomer_id\tlatitude\tlongitude\tcin_id\tcreation_time\t1\t1159\t2\t2-A43 at Blisworth\t52.177441\t-0.955571\tcin19890203T144936602520576139987200866048\t1471392011";
}

- (void)testImportSuccess {
        
    PopulateBlock completionBlock = ^(BOOL success) {
        XCTAssertTrue(success);
    };
    
    [self.singleton.bitCarrierNode populateTSV:[self stringSimple] completion:completionBlock];
}

- (void)testImportFail {
    
    PopulateBlock completionBlock = ^(BOOL success) {
        XCTAssertFalse(success);
    };
    
    [self.singleton.bitCarrierNode populateTSV:[self stringFail] completion:completionBlock];
}

@end

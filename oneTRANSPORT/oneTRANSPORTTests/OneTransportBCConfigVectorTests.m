//
//  OneTransportBCConfigVector.m
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

@interface OneTransportBCConfigVector : OneTransportBaseTests

@end

@implementation OneTransportBCConfigVector

- (NSString *)stringSimple {
    
    return @"_id\tvector_id\tname\tcustomer_name\tfrom_location\tto_location\tdistance\tsketch_id\tcin_id\tcreation_time\t1\t276\t276\t2->14\t1159\t1165\t6147\t1\tcin19790102T052044284102444140493914752768\t1467798797";
}

- (NSString *)stringFail {
    
    return @"_id\tvector_id\tname\tcustomer_name\tto_location\tdistance\tsketch_id\tcin_id\tcreation_time\t1\t276\t276\t2->14\t1159\t1165\t6147\t1\tcin19790102T052044284102444140493914752768\t1467798797";
}

- (void)testImportSuccess {
    
    PopulateBlock completionBlock = ^(BOOL success) {
        XCTAssertTrue(success);
    };
    
    [self.singleton.bitCarrierConfigVector populateTSV:[self stringSimple] completion:completionBlock];
}

- (void)testImportFail {
    
    PopulateBlock completionBlock = ^(BOOL success) {
        XCTAssertFalse(success);
    };
    
    [self.singleton.bitCarrierConfigVector populateTSV:[self stringFail] completion:completionBlock];
}

@end

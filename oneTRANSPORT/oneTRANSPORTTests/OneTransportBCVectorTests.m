//
//  OneTransportBCVector.m
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

@interface OneTransportBCVector : OneTransportBaseTests

@end

@implementation OneTransportBCVector

- (NSString *)stringSimple {
    
    return @"_id\tvector_id\ttimestamp\tspeed\telapsed\tlevel_of_service\tcin_id\tcreation_time\t2\t282\t2016-09-03T11:50:00Z\t70.06965\t491.0\tgreen\tcin19700101T191028069028140234941646592\t1472903452";
}

- (NSString *)stringFail {
    
    return @"_id\tvector_id\ttimestamp\tspeed\telapsed\tcin_id\tcreation_time\t2\t282\t2016-09-03T11:50:00Z\t70.06965\t491.0\tgreen\tcin19700101T191028069028140234941646592\t1472903452";
}

- (void)testImportSuccess {
    
    PopulateBlock completionBlock = ^(BOOL success) {
        XCTAssertTrue(success);
    };
    
    [self.singleton.bitCarrierVector populateTSV:[self stringSimple] completion:completionBlock];
}

- (void)testImportFail {
    
    PopulateBlock completionBlock = ^(BOOL success) {
        XCTAssertFalse(success);
    };
    
    [self.singleton.bitCarrierVector populateTSV:[self stringFail] completion:completionBlock];
}

@end

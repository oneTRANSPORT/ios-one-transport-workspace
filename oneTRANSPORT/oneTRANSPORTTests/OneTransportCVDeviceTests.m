//
//  OneTransportCVDevice.m
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

@interface OneTransportCVDevice : OneTransportBaseTests

@end

@implementation OneTransportCVDevice

- (NSString *)stringSimple {
    
    return @"_id\tsensor_id\ttitle\tdescription\ttype\tlatitude\tlongitude\tchanged\tcin_id\tcreation_time\t1\t1745\tSilverstone01\tSite 1, Marshal Campground\tM680\t52.083884\t-1.019874\t2016-06-27 12:09:19\tcin20010121T094659980070419139872948041472\t1467712661";
}

- (NSString *)stringFail {
    
    return @"_id\tsensor_id\ttitle\tdescription\ttype\tlatitude\tlongitude\tchanged\tcin_id\t1\t1745\tSilverstone01\tSite 1, Marshal Campground\tM680\t52.083884\t-1.019874\t2016-06-27 12:09:19\tcin20010121T094659980070419139872948041472\t1467712661";
}

- (void)testImportSuccess {
    
    PopulateBlock completionBlock = ^(BOOL success) {
        XCTAssertTrue(success);
    };
    
    [self.singleton.clearViewDevice populateTSV:[self stringSimple] completion:completionBlock];
}

- (void)testImportFail {
    
    PopulateBlock completionBlock = ^(BOOL success) {
        XCTAssertFalse(success);
    };
    
    [self.singleton.clearViewDevice populateTSV:[self stringFail] completion:completionBlock];
}

@end

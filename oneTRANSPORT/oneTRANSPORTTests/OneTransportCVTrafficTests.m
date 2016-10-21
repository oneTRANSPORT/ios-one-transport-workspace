//
//  OneTransportCVTraffic.m
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

@interface OneTransportCVTraffic : OneTransportBaseTests

@end

@implementation OneTransportCVTraffic

- (NSArray *)arraySimple {
    
    NSString *contentsJson = @"[{\"vehicleNumber\":0,\"time\":\"2016-08-25 14:11:29\",\"lane\":1,\"subSite\":1,\"indexMark\":null,\"speed\":1,\"length\":1.8,\"headway\":25.5,\"grossWeight\":null,\"gap\":25.5,\"direction\":false,\"vehicleClass\":0,\"overhang\":null,\"classScheme\":3,\"chassisHeightCode\":4,\"wheelbase\":null,\"axleData\":[],\"occupancyTime\":6480,\"resultCode\":null,\"deltaTime\":89500}]";

    if (contentsJson.length > 0) {
        return [NSJSONSerialization JSONObjectWithData:[contentsJson dataUsingEncoding:NSUTF8StringEncoding] options:0 error:NULL];
    } else {
        return [NSArray new];
    }
}

- (NSArray *)arraySimpleChanged {
    
    NSString *contentsJson = @"[{\"vehicleNumber\":0,\"time\":\"2016-08-25 14:11:29\",\"lane\":2,\"subSite\":1,\"indexMark\":null,\"speed\":1,\"length\":1.8,\"headway\":25.5,\"grossWeight\":null,\"gap\":25.5,\"direction\":false,\"vehicleClass\":0,\"overhang\":null,\"classScheme\":3,\"chassisHeightCode\":4,\"wheelbase\":null,\"axleData\":[],\"occupancyTime\":6480,\"resultCode\":null,\"deltaTime\":89500}]";
    if (contentsJson.length > 0) {
        return [NSJSONSerialization JSONObjectWithData:[contentsJson dataUsingEncoding:NSUTF8StringEncoding] options:0 error:NULL];
    } else {
        return [NSArray new];
    }
}

- (void)testEmptyArray {
    
    [self.singleton.clearViewTraffic removeAll];
    
    [self.singleton.clearViewTraffic populateTableWith:[NSArray new] timestamp:[NSDate date]];
    
    NSArray *arrayRetrieved = [self.singleton.clearViewTraffic retrieveAll:nil];
    XCTAssertTrue(arrayRetrieved.count == 0);
}

- (void)testAdded {
    
    [self.singleton.clearViewTraffic removeAll];
    
    NSArray *array = [self arraySimple];
    NSArray *arrayCommon = [self.singleton.clearViewTraffic populateTableWithReference:@"123" data:array timestamp:[NSDate date]];
    XCTAssertTrue(arrayCommon.count == 0);
    
    NSArray *arrayRetrieved = [self.singleton.clearViewTraffic retrieveAll:nil];
    XCTAssertTrue(arrayRetrieved.count == 1);
    
    NSArray *arrayChanges = [self.singleton.clearViewTraffic checkForChanges:arrayCommon];
    XCTAssertTrue(arrayChanges.count == 0);
}

- (void)testChanged {
    
    [self.singleton.clearViewTraffic removeAll];
    
    NSArray *array;
    array = [self arraySimple];
    [self.singleton.clearViewTraffic populateTableWithReference:@"123" data:array timestamp:[NSDate date]];
    array = [self arraySimpleChanged];
    [self.singleton.clearViewTraffic populateTableWithReference:@"123" data:array timestamp:[NSDate date]];
    
    NSArray *arrayRetrieved = [self.singleton.clearViewTraffic retrieveAll:nil];
    XCTAssertTrue(arrayRetrieved.count == 1);
}

- (void)testOverwrite {
    
    [self.singleton.clearViewTraffic removeAll];
    
    NSArray *array = [self arraySimple];
    NSDate *date = [NSDate date];
    [self.singleton.clearViewTraffic populateTableWithReference:@"123" data:array timestamp:date];
    [self.singleton.clearViewTraffic populateTableWithReference:@"123" data:array timestamp:date];
    
    NSArray *arrayRetrieved = [self.singleton.clearViewTraffic retrieveAll:nil];
    XCTAssertTrue(arrayRetrieved.count == 1);
}

- (void)testRemove {
    
    NSArray *array = [self arraySimple];
    [self.singleton.clearViewTraffic populateTableWithReference:@"123" data:array timestamp:[NSDate date]];
    [self.singleton.clearViewTraffic removeAll];
    
    NSArray *arrayRetrieved = [self.singleton.clearViewTraffic retrieveAll:nil];
    XCTAssertTrue(arrayRetrieved.count == 0);
}

- (NSString *)stringTsvSimple {
    
    return @"_id\tsensor_id\ttimestamp\tlane\tdirection\tcin_id\tcreation_time\t7\t1747\t2016-09-02 17:15:43\t1\t1\tcin19700101T192901070141140541645940480\t1472833079";
}

- (NSString *)stringTsvFail {
    
    return @"_id\tsensor_id\ttimestamp\tlane\tdirection\tcin_id\t7\t1747\t2016-09-02 17:15:43\t1\t1\tcin19700101T192901070141140541645940480\t1472833079";
}

- (void)testImportSuccess {
    
    PopulateBlock completionBlock = ^(BOOL success) {
        XCTAssertTrue(success);
    };
    
    [self.singleton.clearViewTraffic populateTSV:[self stringTsvSimple] completion:completionBlock];
}

- (void)testImportFail {
    
    PopulateBlock completionBlock = ^(BOOL success) {
        XCTAssertFalse(success);
    };
    
    [self.singleton.clearViewTraffic populateTSV:[self stringTsvFail] completion:completionBlock];
}

@end

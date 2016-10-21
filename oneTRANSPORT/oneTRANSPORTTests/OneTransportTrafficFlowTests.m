//
//  OneTransportTrafficFlowTests.m
//  oneTRANSPORT
//
//  Created by Dominic Frazer Imregh on 18/08/2016.
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

@interface OneTransportTrafficFlowTests : OneTransportBaseTests

@end

@implementation OneTransportTrafficFlowTests

- (NSDictionary *)dictSimple {
    
    NSMutableArray *array = [NSMutableArray new];
    
    NSMutableDictionary *dict;
    dict = [NSMutableDictionary new];
    [dict setObject:@"TRAFFIC1" forKey:@"fromDescriptor"];
    [dict setObject:@"ABC123" forKey:@"id"];
    [dict setObject:@"51.628210000000003" forKey:@"fromLatitude"];
    [dict setObject:@"-0.75028269999999997" forKey:@"fromLongitude"];
    [dict setObject:@"29" forKey:@"vehicleFlow"];
    [dict setObject:@"2016-09-15T09:00:00Z" forKey:@"time"];
    [array addObject:dict];
    
    dict = [NSMutableDictionary new];
    [dict setObject:@"TRAFFIC2" forKey:@"fromDescriptor"];
    [dict setObject:@"XYZ789" forKey:@"id"];
    [dict setObject:@"51.864356999999998" forKey:@"fromLatitude"];
    [dict setObject:@"-0.70586899999999997" forKey:@"fromLongitude"];
    [dict setObject:@"31" forKey:@"vehicleFlow"];
    [dict setObject:@"2016-09-15T09:00:00Z" forKey:@"time"];
    [array addObject:dict];
    
    dict = [NSMutableDictionary new];
    [dict setObject:array forKey:@"con"];
    return dict;
}

- (NSDictionary *)dictSimpleChanged {
    
    NSMutableArray *array = [NSMutableArray new];
    
    NSMutableDictionary *dict;
    dict = [NSMutableDictionary new];
    [dict setObject:@"TRAFFIC1" forKey:@"fromDescriptor"];
    [dict setObject:@"ABC123" forKey:@"id"];
    [dict setObject:@"51.628210000000003" forKey:@"fromLatitude"];
    [dict setObject:@"-0.75028269999999997" forKey:@"fromLongitude"];
    [dict setObject:@"30" forKey:@"vehicleFlow"];
    [dict setObject:@"2016-09-15T10:00:00Z" forKey:@"time"];
    [array addObject:dict];
    
    dict = [NSMutableDictionary new];
    [dict setObject:@"TRAFFIC2" forKey:@"fromDescriptor"];
    [dict setObject:@"XYZ789" forKey:@"id"];
    [dict setObject:@"51.864356999999998" forKey:@"fromLatitude"];
    [dict setObject:@"-0.70586899999999997" forKey:@"fromLongitude"];
    [dict setObject:@"32" forKey:@"vehicleFlow"];
    [dict setObject:@"2016-09-15T10:00:00Z" forKey:@"time"];
    [array addObject:dict];
    
    dict = [NSMutableDictionary new];
    [dict setObject:array forKey:@"con"];
    return dict;
}

- (void)testEmptyArray {
    
    [self.singleton.trafficFlow removeAll];
    
    [self.singleton.trafficFlow populateTableWith:[NSArray new] timestamp:[NSDate date]];
    
    NSArray *arrayRetrieved = [self.singleton.trafficFlow retrieveAll:nil];
    XCTAssertTrue(arrayRetrieved.count == 0);
}

- (void)testAdded {
    
    [self.singleton.trafficFlow removeAll];
    
    NSDictionary *dict = [self dictSimple];
    NSArray *arrayCommon = [self.singleton.trafficFlow populateTableWith:dict[@"con"] timestamp:[NSDate date]];
    XCTAssertTrue(arrayCommon.count == 2);
    
    NSArray *arrayRetrieved = [self.singleton.trafficFlow retrieveAll:nil];
    XCTAssertTrue(arrayRetrieved.count == 2);

    NSArray *arrayChanges = [self.singleton.trafficFlow checkForChanges:arrayCommon];
    XCTAssertTrue(arrayChanges.count == 2);
}

- (void)testChanged {
    
    [self.singleton.trafficFlow removeAll];
    
    NSArray *arrayCommon;
    NSDictionary *dict;
    dict = [self dictSimple];
    arrayCommon = [self.singleton.trafficFlow populateTableWith:dict[@"con"] timestamp:[NSDate date]];
    dict = [self dictSimpleChanged];
    arrayCommon = [self.singleton.trafficFlow populateTableWith:dict[@"con"] timestamp:[NSDate dateWithTimeIntervalSinceNow:10]];
    XCTAssertTrue(arrayCommon.count == 2);

    NSArray *arrayRetrieved = [self.singleton.trafficFlow retrieveAll:nil];
    XCTAssertTrue(arrayRetrieved.count == 4);
    
    NSArray *arrayChanges = [self.singleton.trafficFlow checkForChanges:arrayCommon];
    XCTAssertTrue(arrayChanges.count == 2);
}

- (void)testOverwrite {
    
    [self.singleton.trafficFlow removeAll];
    
    NSDictionary *dict = [self dictSimple];
    NSDate *date = [NSDate date];
    [self.singleton.trafficFlow populateTableWith:dict[@"con"] timestamp:date];
    [self.singleton.trafficFlow populateTableWith:dict[@"con"] timestamp:date];
    
    NSArray *arrayRetrieved = [self.singleton.trafficFlow retrieveAll:nil];
    XCTAssertTrue(arrayRetrieved.count == 2);
}

- (void)testRemove {
    
    NSDictionary *dict = [self dictSimple];
    [self.singleton.trafficFlow populateTableWith:dict[@"con"] timestamp:[NSDate date]];
    [self.singleton.trafficFlow removeAll];
    
    NSArray *arrayRetrieved = [self.singleton.trafficFlow retrieveAll:nil];
    XCTAssertTrue(arrayRetrieved.count == 0);
}

@end


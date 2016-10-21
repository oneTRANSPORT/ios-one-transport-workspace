//
//  OneTransportEventTests.m
//  oneTRANSPORT
//
//  Created by Dominic Frazer Imregh on 15/09/2016.
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

@interface OneTransportEventTests : OneTransportBaseTests

@end

@implementation OneTransportEventTests

- (NSDictionary *)dictSimple {
    
    NSMutableArray *array = [NSMutableArray new];
    
    NSMutableDictionary *dict;
    NSMutableDictionary *dictLocation;
    
    dict = [NSMutableDictionary new];
    [dict setObject:@"TRAFFIC1" forKey:@"id"];
    [dict setObject:@"51.628210000000003" forKey:@"latitude"];
    [dict setObject:@"-0.75028269999999997" forKey:@"longitude"];
    dictLocation = [NSMutableDictionary new];
    [dictLocation setObject:@"TRAFFIC1 Description" forKey:@"content"];
    [dict setObject:dictLocation forKey:@"description"];
    [array addObject:dict];
    
    dict = [NSMutableDictionary new];
    [dict setObject:@"TRAFFIC2" forKey:@"id"];
    [dict setObject:@"51.864356999999998" forKey:@"latitude"];
    [dict setObject:@"-0.70586899999999997" forKey:@"longitude"];
    dictLocation = [NSMutableDictionary new];
    [dictLocation setObject:@"TRAFFIC2 Description" forKey:@"content"];
    [dict setObject:dictLocation forKey:@"description"];
    [array addObject:dict];

    dict = [NSMutableDictionary new];
    [dict setObject:array forKey:@"con"];
    return dict;
}

- (NSDictionary *)dictSimpleChanged {
    
    NSMutableArray *array = [NSMutableArray new];
    
    NSMutableDictionary *dict;
    NSMutableDictionary *dictLocation;
    
    dict = [NSMutableDictionary new];
    [dict setObject:@"TRAFFIC1" forKey:@"id"];
    [dict setObject:@"51.628210000000003" forKey:@"latitude"];
    [dict setObject:@"-0.75028269999999997" forKey:@"longitude"];
    dictLocation = [NSMutableDictionary new];
    [dictLocation setObject:@"TRAFFIC1 Description Change" forKey:@"content"];
    [dict setObject:dictLocation forKey:@"description"];
    [array addObject:dict];
    
    dict = [NSMutableDictionary new];
    [dict setObject:@"TRAFFIC2" forKey:@"id"];
    [dict setObject:@"51.864356999999998" forKey:@"latitude"];
    [dict setObject:@"-0.70586899999999997" forKey:@"longitude"];
    dictLocation = [NSMutableDictionary new];
    [dictLocation setObject:@"TRAFFIC2 Description Change" forKey:@"content"];
    [dict setObject:dictLocation forKey:@"description"];
    [array addObject:dict];

    dict = [NSMutableDictionary new];
    [dict setObject:array forKey:@"con"];
    return dict;
}

- (NSDictionary *)dictSimpleReduced {
    
    NSMutableArray *array = [NSMutableArray new];
    
    NSMutableDictionary *dict;
    NSMutableDictionary *dictLocation;
    
    dict = [NSMutableDictionary new];
    [dict setObject:@"TRAFFIC1" forKey:@"id"];
    [dict setObject:@"51.628210000000003" forKey:@"latitude"];
    [dict setObject:@"-0.75028269999999997" forKey:@"longitude"];
    dictLocation = [NSMutableDictionary new];
    [dictLocation setObject:@"TRAFFIC1 Description Change" forKey:@"content"];
    [dict setObject:dictLocation forKey:@"description"];
    [array addObject:dict];
    
    dict = [NSMutableDictionary new];
    [dict setObject:array forKey:@"con"];
    return dict;
}

- (void)testEmptyArray {
    
    [self.singleton.events removeAll];
    
    [self.singleton.events populateTableWith:[NSArray new] timestamp:[NSDate date]];
    
    NSArray *arrayRetrieved = [self.singleton.events retrieveAll];
    XCTAssertTrue(arrayRetrieved.count == 0);
}

- (void)testAdded {
    
    [self.singleton.events removeAll];
    
    NSDictionary *dict = [self dictSimple];
    NSArray *arrayCommon = [self.singleton.events populateTableWith:dict[@"con"] timestamp:[NSDate date]];
    XCTAssertTrue(arrayCommon.count == 2);
    
    NSArray *arrayRetrieved = [self.singleton.events retrieveAll:nil];
    XCTAssertTrue(arrayRetrieved.count == 2);
    
    NSArray *arrayChanges = [self.singleton.events checkForChanges:arrayCommon];
    XCTAssertTrue(arrayChanges.count == 2);
}

- (void)testChanged {
    
    [self.singleton.events removeAll];
    
    NSArray *arrayCommon;
    NSDictionary *dict;
    dict = [self dictSimple];
    arrayCommon = [self.singleton.events populateTableWith:dict[@"con"] timestamp:[NSDate date]];
    dict = [self dictSimpleChanged];
    arrayCommon = [self.singleton.events populateTableWith:dict[@"con"] timestamp:[NSDate date]];
    XCTAssertTrue(arrayCommon.count == 2);
    
    NSArray *arrayRetrieved = [self.singleton.events retrieveAll:nil];
    XCTAssertTrue(arrayRetrieved.count == 4);
    
    NSArray *arrayChanges = [self.singleton.events checkForChanges:arrayCommon];
    XCTAssertTrue(arrayChanges.count == 2);
}

- (void)testOverwrite {
    
    [self.singleton.events removeAll];
    
    NSDictionary *dict = [self dictSimple];
    NSDate *date = [NSDate date];
    [self.singleton.events populateTableWith:dict[@"con"] timestamp:date];
    [self.singleton.events populateTableWith:dict[@"con"] timestamp:date];
    
    NSArray *arrayRetrieved = [self.singleton.events retrieveAll:nil];
    XCTAssertTrue(arrayRetrieved.count == 2);
}

- (void)testRemove {
    
    NSDictionary *dict = [self dictSimple];
    [self.singleton.events populateTableWith:dict[@"con"] timestamp:[NSDate date]];
    [self.singleton.events removeAll];
    
    NSArray *arrayRetrieved = [self.singleton.events retrieveAll:nil];
    XCTAssertTrue(arrayRetrieved.count == 0);
}


@end

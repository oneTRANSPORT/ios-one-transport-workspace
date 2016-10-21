//
//  OneTransportBCTravel.m
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

@interface OneTransportBCTravel : OneTransportBaseTests

@end

@implementation OneTransportBCTravel

- (NSDictionary *)arraySimple {
    
    NSString *contentsJson = @"{\"rid\":\"143\",\"time\":\"2016-09-21T07:44:00Z\",\"traveltimes\":[{\"tid\":\"11\",\"offset\":0,\"from\":\"10\",\"to\":\"15\"}],\"average\":{\"score\":98,\"publish\":{\"speed\":63.335495,\"elapsed\":617,\"trend\":-25.21212},\"calculated\":{\"speed\":63.335495,\"elapsed\":617,\"readings\":1}},\"last\":{\"score\":98,\"publish\":{\"speed\":75.586075,\"elapsed\":517},\"calculated\":{\"speed\":75.586075,\"elapsed\":517,\"readings\":1}}}";
    
    if (contentsJson.length > 0) {
        return [NSJSONSerialization JSONObjectWithData:[contentsJson dataUsingEncoding:NSUTF8StringEncoding] options:0 error:NULL];
    } else {
        return [NSDictionary new];
    }
}

- (NSDictionary *)arraySimpleChanged {
    
    NSString *contentsJson = @"{\"rid\":\"143\",\"time\":\"2016-09-21T07:44:00Z\",\"traveltimes\":[{\"tid\":\"11\",\"offset\":0,\"from\":\"10\",\"to\":\"15\"}],\"average\":{\"score\":98,\"publish\":{\"speed\":73.335495,\"elapsed\":617,\"trend\":-25.21212},\"calculated\":{\"speed\":63.335495,\"elapsed\":617,\"readings\":1}},\"last\":{\"score\":98,\"publish\":{\"speed\":75.586075,\"elapsed\":517},\"calculated\":{\"speed\":75.586075,\"elapsed\":517,\"readings\":1}}}";
    if (contentsJson.length > 0) {
        return [NSJSONSerialization JSONObjectWithData:[contentsJson dataUsingEncoding:NSUTF8StringEncoding] options:0 error:NULL];
    } else {
        return [NSDictionary new];
    }
}

- (void)testEmptyArray {
    
    [self.singleton.bitCarrierTravel removeAll];
    
    [self.singleton.bitCarrierTravel populateTableWith:[NSDictionary new] timestamp:[NSDate date]];
    
    NSArray *arrayRetrieved = [self.singleton.bitCarrierTravel retrieveAll:nil];
    XCTAssertTrue(arrayRetrieved.count == 0);
}

- (void)testAdded {
    
    [self.singleton.bitCarrierTravel removeAll];
    
    NSDictionary *array = [self arraySimple];
    NSArray *arrayCommon = [self.singleton.bitCarrierTravel populateTableWith:array timestamp:[NSDate date]];
    XCTAssertTrue(arrayCommon.count == 0);
    
    NSArray *arrayRetrieved = [self.singleton.bitCarrierTravel retrieveAll:nil];
    XCTAssertTrue(arrayRetrieved.count == 1);
    
    NSArray *arrayChanges = [self.singleton.bitCarrierTravel checkForChanges:arrayCommon];
    XCTAssertTrue(arrayChanges.count == 0);
}

- (void)testChanged {
    
    [self.singleton.bitCarrierTravel removeAll];
    
    NSDictionary *array;
    array = [self arraySimple];
    [self.singleton.bitCarrierTravel populateTableWith:array timestamp:[NSDate date]];
    array = [self arraySimpleChanged];
    [self.singleton.bitCarrierTravel populateTableWith:array timestamp:[NSDate date]];
    
    NSArray *arrayRetrieved = [self.singleton.bitCarrierTravel retrieveAll:nil];
    XCTAssertTrue(arrayRetrieved.count == 1);
}

- (void)testOverwrite {
    
    [self.singleton.bitCarrierTravel removeAll];
    
    NSDictionary *array = [self arraySimple];
    NSDate *date = [NSDate date];
    [self.singleton.bitCarrierTravel populateTableWith:array timestamp:date];
    [self.singleton.bitCarrierTravel populateTableWith:array timestamp:date];
    
    NSArray *arrayRetrieved = [self.singleton.bitCarrierTravel retrieveAll:nil];
    XCTAssertTrue(arrayRetrieved.count == 1);
}

- (void)testRemove {
    
    NSDictionary *array = [self arraySimple];
    [self.singleton.bitCarrierTravel populateTableWith:array timestamp:[NSDate date]];
    [self.singleton.bitCarrierTravel removeAll];
    
    NSArray *arrayRetrieved = [self.singleton.bitCarrierTravel retrieveAll:nil];
    XCTAssertTrue(arrayRetrieved.count == 0);
}

- (NSString *)stringSimple {
    
    return @"_id\ttravel_summary_id\tclock_time\tfrom_location\tto_location\tscore\tspeed\telapsed\ttrend\tcin_id\tcreation_time\t5\t11\t2016-09-02T18:01:00Z\t10\t15\t100.0\t2.7568254\t14175.0\t2631.214\tcin19700101T021526008126140541620762368\t1472839463";
}

- (NSString *)stringFail {
    
    return @"_id\ttravel_summary_id\tclock_time\tfrom_location\tto_location\tscore\telapsed\ttrend\tcin_id\tcreation_time\t5\t11\t2016-09-02T18:01:00Z\t10\t15\t100.0\t2.7568254\t14175.0\t2631.214\tcin19700101T021526008126140541620762368\t1472839463";
}

- (void)testImportSuccess {
    
    PopulateBlock completionBlock = ^(BOOL success) {
        XCTAssertTrue(success);
    };
    
    [self.singleton.bitCarrierTravel populateTSV:[self stringSimple] completion:completionBlock];
}

- (void)testImportFail {
    
    PopulateBlock completionBlock = ^(BOOL success) {
        XCTAssertFalse(success);
    };
    
    [self.singleton.bitCarrierTravel populateTSV:[self stringFail] completion:completionBlock];
}

@end

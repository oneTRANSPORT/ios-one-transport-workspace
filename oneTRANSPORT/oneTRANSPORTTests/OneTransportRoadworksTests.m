//
//  OneTransportRoadworksTests.m
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

@interface OTSingleton()

- (void)purgeOrphanedCommon;

@end

@interface OneTransportRoadworksTests : OneTransportBaseTests

@end

@implementation OneTransportRoadworksTests

- (NSDictionary *)dictSimple {
    
    NSMutableArray *array = [NSMutableArray new];
    
    NSMutableDictionary *dict;
    
    dict = [NSMutableDictionary new];
    [dict setObject:@"TRAFFIC1" forKey:@"comment"];
    [dict setObject:@"ABC123" forKey:@"id"];
    [dict setObject:@"51.628210000000003" forKey:@"latitude"];
    [dict setObject:@"-0.75028269999999997" forKey:@"longitude"];
    [dict setObject:@"Comment Here" forKey:@"comment"];
    [array addObject:dict];
    
    dict = [NSMutableDictionary new];
    [dict setObject:@"TRAFFIC2" forKey:@"comment"];
    [dict setObject:@"XYZ789" forKey:@"id"];
    [dict setObject:@"51.864356999999998" forKey:@"latitude"];
    [dict setObject:@"-0.70586899999999997" forKey:@"longitude"];
    [dict setObject:@"Comment Here" forKey:@"comment"];
    [array addObject:dict];
    
    dict = [NSMutableDictionary new];
    [dict setObject:array forKey:@"con"];
    return dict;
}

- (NSDictionary *)dictSimpleChanged {
    
    NSMutableArray *array = [NSMutableArray new];
    
    NSMutableDictionary *dict;
    
    dict = [NSMutableDictionary new];
    [dict setObject:@"TRAFFIC1" forKey:@"comment"];
    [dict setObject:@"ABC123" forKey:@"id"];
    [dict setObject:@"51.628210000000003" forKey:@"latitude"];
    [dict setObject:@"-0.75028269999999997" forKey:@"longitude"];
    [dict setObject:@"Comment Here" forKey:@"comment"];
    [array addObject:dict];
    
    dict = [NSMutableDictionary new];
    [dict setObject:@"TRAFFIC2" forKey:@"comment"];
    [dict setObject:@"XYZ789" forKey:@"id"];
    [dict setObject:@"51.864356999999998" forKey:@"latitude"];
    [dict setObject:@"-0.70586899999999997" forKey:@"longitude"];
    [dict setObject:@"Comment Here Changed" forKey:@"comment"];
    [array addObject:dict];
    
    dict = [NSMutableDictionary new];
    [dict setObject:array forKey:@"con"];
    return dict;
}

- (NSDictionary *)dictSimpleReduced {
    
    NSMutableArray *array = [NSMutableArray new];
    
    NSMutableDictionary *dict;
    
    dict = [NSMutableDictionary new];
    [dict setObject:@"TRAFFIC1" forKey:@"comment"];
    [dict setObject:@"ABC123" forKey:@"id"];
    [dict setObject:@"51.628210000000003" forKey:@"latitude"];
    [dict setObject:@"-0.75028269999999997" forKey:@"longitude"];
    [dict setObject:@"Comment Here" forKey:@"comment"];
    [array addObject:dict];

    dict = [NSMutableDictionary new];
    [dict setObject:array forKey:@"con"];
    return dict;
}

- (void)testEmptyArray {
    
    [self.singleton.roadworks removeAll];
    
    [self.singleton.roadworks populateTableWith:[NSArray new] timestamp:[NSDate date]];
    
    NSArray *arrayRetrieved = [self.singleton.roadworks retrieveAll];
    XCTAssertTrue(arrayRetrieved.count == 0);
}

- (void)testAdded {
    
    [self.singleton.roadworks removeAll];
    
    NSDictionary *dict = [self dictSimple];
    NSArray *arrayCommon = [self.singleton.roadworks populateTableWith:dict[@"con"] timestamp:[NSDate date]];
    XCTAssertTrue(arrayCommon.count == 2);

    NSArray *arrayRetrieved = [self.singleton.roadworks retrieveAll:nil];
    XCTAssertTrue(arrayRetrieved.count == 2);
    
    NSArray *arrayChanges = [self.singleton.roadworks checkForChanges:arrayCommon];
    XCTAssertTrue(arrayChanges.count == 2);
}

- (void)testChanged {
    
    [self.singleton.roadworks removeAll];
    
    NSDate *timestamp = [NSDate date];
    
    NSArray *arrayCommon;
    NSDictionary *dict;
    dict = [self dictSimple];
    arrayCommon = [self.singleton.roadworks populateTableWith:dict[@"con"] timestamp:timestamp];
    dict = [self dictSimpleChanged];
    arrayCommon = [self.singleton.roadworks populateTableWith:dict[@"con"] timestamp:[timestamp dateByAddingTimeInterval:10]];
    XCTAssertTrue(arrayCommon.count == 2);
    
    NSArray *arrayRetrieved = [self.singleton.roadworks retrieveAll:nil];
    XCTAssertTrue(arrayRetrieved.count == 4);           //roadworks always removes redundant records
    
    NSArray *arrayChanges = [self.singleton.roadworks checkForChanges:arrayCommon];
    XCTAssertTrue(arrayChanges.count == 1);
}

- (void)testPurge {
    
    [self.singleton.roadworks removeAll];
    
    NSDate *timestamp = [NSDate date];

    NSArray *arrayCommon;
    NSDictionary *dict;
    dict = [self dictSimple];
    arrayCommon = [self.singleton.roadworks populateTableWith:dict[@"con"] timestamp:timestamp];
    [self.singleton.common populateTableWith:arrayCommon type:self.singleton.roadworks.dataType];
    dict = [self dictSimpleReduced];
    arrayCommon = [self.singleton.roadworks populateTableWith:dict[@"con"] timestamp:[timestamp dateByAddingTimeInterval:10]];
    [self.singleton.common populateTableWith:arrayCommon type:self.singleton.roadworks.dataType];
    XCTAssertTrue(arrayCommon.count == 1);
    
    NSArray *arrayRetrieved = [self.singleton.roadworks retrieveAll:nil];
    XCTAssertTrue(arrayRetrieved.count == 3);
    
    NSArray *arrayChanges = [self.singleton.roadworks checkForChanges:arrayCommon];
    XCTAssertTrue(arrayChanges.count == 0);
    
    [self.singleton purgeOrphanedCommon];   //purge should no nothing because history exists for all roadworks
    arrayCommon = [self.singleton.common retrieveAll:nil];
    XCTAssertTrue(arrayCommon.count == 2);
    
    NSManagedObjectContext *moc = [self.singleton.roadworks.coreData managedObjectContext];
    Roadworks *object;
    NSFetchRequest *fetchRequest = [self.singleton.roadworks getFetchRequest];
    NSArray *arrayExisting = [moc executeFetchRequest:fetchRequest error:nil];
    for (object in arrayExisting) {
        [moc deleteObject:object];
    }

    [self.singleton purgeOrphanedCommon];   //purge should not remove everything because no history exists for any roadworks
    arrayCommon = [self.singleton.common retrieveAll:nil];
    XCTAssertTrue(arrayCommon.count == 0);
}

- (void)testOverwrite {
    
    [self.singleton.roadworks removeAll];
    
    NSDictionary *dict = [self dictSimple];
    NSDate *date = [NSDate date];
    [self.singleton.roadworks populateTableWith:dict[@"con"] timestamp:date];
    [self.singleton.roadworks populateTableWith:dict[@"con"] timestamp:date];
    
    NSArray *arrayRetrieved = [self.singleton.roadworks retrieveAll:nil];
    XCTAssertTrue(arrayRetrieved.count == 2);
}

- (void)testRemove {
    
    NSDictionary *dict = [self dictSimple];
    [self.singleton.roadworks populateTableWith:dict[@"con"] timestamp:[NSDate date]];
    [self.singleton.roadworks removeAll];
    
    NSArray *arrayRetrieved = [self.singleton.roadworks retrieveAll:nil];
    XCTAssertTrue(arrayRetrieved.count == 0);
}

@end

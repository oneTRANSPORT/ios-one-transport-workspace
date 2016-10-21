//
//  OneTransportPrimitivesTests.m
//  oneTRANSPORT
//
//  Created by Dominic Frazer Imregh on 02/09/2016.
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

#import "OTSingleton.h"
#import "OTCoreDataCommon.h"
#import "VariableMessageSigns+CoreDataProperties.h"
#import "TrafficFlow+CoreDataProperties.h"
#import "CarParks+CoreDataProperties.h"
#import "Roadworks+CoreDataProperties.h"

@interface OneTransportPrimitivesTests : OneTransportBaseTests

@end

@implementation OneTransportPrimitivesTests

- (void)testCommon {
    
    NSManagedObjectContext *moc = [self.singleton.coreData managedObjectContext];
    Common *object = [NSEntityDescription insertNewObjectForEntityForName:kCoreDataEntityCommon inManagedObjectContext:moc];
 
    XCTAssertTrue([object.title isEqualToString:@""]);
}

- (void)testVariableMS {
    
    NSManagedObjectContext *moc = [self.singleton.coreData managedObjectContext];
    VariableMessageSigns *object = [NSEntityDescription insertNewObjectForEntityForName:kCoreDataEntityVariable inManagedObjectContext:moc];

    XCTAssertTrue(object.localizedCounter == 0);
    XCTAssertTrue([object.localizedMessage isEqualToString:@""]);
    
    object.legends = @"Message\n123\n456";
    XCTAssertTrue([object.localizedMessage isEqualToString:@"Message 123 456"]);
}

- (void)testTraffic {
    
    NSManagedObjectContext *moc = [self.singleton.coreData managedObjectContext];
    TrafficFlow *object = [NSEntityDescription insertNewObjectForEntityForName:kCoreDataEntityTrafficFlow inManagedObjectContext:moc];
    
    XCTAssertTrue(object.localizedCounter == 0);
    XCTAssertTrue([object.localizedMessage isEqualToString:@""]);
    
    object.vehicleFlow = @(5);

    [OTSingleton.sharedInstance setKph:true];
    XCTAssertTrue([object.localizedMessage isEqualToString:@"Flow per minute = 5 vehicles"]);

    [OTSingleton.sharedInstance setKph:false];
    XCTAssertTrue([object.localizedMessage isEqualToString:@"Flow per minute = 5 vehicles"]);
}

- (void)testCarParks {
    
    NSManagedObjectContext *moc = [self.singleton.coreData managedObjectContext];
    CarParks *object = [NSEntityDescription insertNewObjectForEntityForName:kCoreDataEntityCarParks inManagedObjectContext:moc];
    
    XCTAssertTrue(object.localizedCounter == -2);
    XCTAssertTrue([object.localizedMessage isEqualToString:@"Spaces available"]);
    
    object.capacity = @(99);
    object.full = @(1);
    XCTAssertTrue(object.localizedCounter == -1);
    XCTAssertTrue([object.localizedMessage isEqualToString:@"Capacity 99, no spaces"]);

    object.capacity = @(100);
    object.full = @(0);
    object.occupancy = @(10);
    XCTAssertTrue(object.localizedCounter == 10);
    XCTAssertTrue([object.localizedMessage isEqualToString:@"Capacity 100, 10% full"]);
}

- (void)testRoadWorks {
    
    NSManagedObjectContext *moc = [self.singleton.coreData managedObjectContext];
    Roadworks *object = [NSEntityDescription insertNewObjectForEntityForName:kCoreDataEntityRoadworks inManagedObjectContext:moc];
    
    XCTAssertTrue(object.localizedCounter == 0);
    XCTAssertTrue([object.localizedMessage isEqualToString:@""]);
    
    object.comment = @"ROADWORKS HERE";
    XCTAssertTrue([object.localizedMessage isEqualToString:@"ROADWORKS HERE"]);

    object.comment = @"TYPE : GDP : Event Location : The M1 southbound between junctions J13  and J11 : Event Reason : Road repairs : Event Status : Currently Active : Event Period : expect disruption until 05:00 on 28th April 2017";
    XCTAssertTrue([object.localizedMessage isEqualToString:@"Road repairs\nThe M1 southbound between junctions J13  and J11"]);
 
    object.comment = @"TYPE : GDP : Location : The M1 northbound between junctions J10 and J12 : Reason : Roadworks : Status : Currently Active : Period : from 13:04 on 11 December 2015 to 05:00 on 28 April 2017";
    XCTAssertTrue([object.localizedMessage isEqualToString:@"Roadworks\nThe M1 northbound between junctions J10 and J12"]);
}

@end

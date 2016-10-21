//
//  ObjectBaseTests.m
//  FlorenceSDK
//
//  Created by Dominic Frazer Imregh on 07/07/2016.
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

#import <XCTest/XCTest.h>
#import "OTObjectBase+Private.h"

@interface ObjectBaseTests : XCTestCase

@end

@implementation ObjectBaseTests

- (void)testDate1 {
    NSString *dateString = @"20160807T101344";
    
    OTObjectBase *object = [OTObjectBase new];
    NSDate *date = [object dateFromString:dateString];
    
    if (date) {
        NSCalendar *calendar = [NSCalendar currentCalendar];
        [calendar setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
        NSDateComponents *components = [calendar components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear | NSCalendarUnitHour
                                                   fromDate:date];
        XCTAssertEqual(components.day, 7);
        XCTAssertEqual(components.month, 8);
        XCTAssertEqual(components.year, 2016);
        XCTAssertEqual(components.hour, 10);
    } else {
        XCTAssertNotNil(date);
    }
}

- (void)testDate2 {
    NSString *dateString = @"20991231T235959";
    
    OTObjectBase *object = [OTObjectBase new];
    NSDate *date = [object dateFromString:dateString];
    
    if (date) {
        NSCalendar *calendar = [NSCalendar currentCalendar];
        [calendar setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
        NSDateComponents *components = [calendar components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear | NSCalendarUnitHour
                                                   fromDate:date];
        XCTAssertEqual(components.day, 31);
        XCTAssertEqual(components.month, 12);
        XCTAssertEqual(components.year, 2099);
        XCTAssertEqual(components.hour, 23);
    } else {
        XCTAssertNotNil(date);
    }
}

- (void)testDateAlpha {
    NSString *dateString = @"HELLOWORLD";
    
    OTObjectBase *object = [OTObjectBase new];
    NSDate *date = [object dateFromString:dateString];
    
    XCTAssertNil(date);
}

- (void)testDateBadYear {
    NSString *dateString = @"2010807T101344";
    
    OTObjectBase *object = [OTObjectBase new];
    NSDate *date = [object dateFromString:dateString];
    
    if (date) {
        NSCalendar *calendar = [NSCalendar currentCalendar];
        [calendar setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
        NSDateComponents *components = [calendar components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear | NSCalendarUnitHour
                                                   fromDate:date];
        XCTAssertEqual(components.day, 7);
        XCTAssertEqual(components.month, 8);
        XCTAssertEqual(components.year, 201);
        XCTAssertEqual(components.hour, 10);
    } else {
        XCTAssertNotNil(date);
    }
}

- (void)testDateBadTime {
    NSString *dateString = @"2010807T1344";
    
    OTObjectBase *object = [OTObjectBase new];
    NSDate *date = [object dateFromString:dateString];
    
    XCTAssertNil(date);
}

- (void)testDateEmpty {
    NSString *dateString = @"";
    
    OTObjectBase *object = [OTObjectBase new];
    NSDate *date = [object dateFromString:dateString];
    
    if (date) {
        NSCalendar *calendar = [NSCalendar currentCalendar];
        [calendar setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
        NSDateComponents *components = [calendar components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear | NSCalendarUnitHour
                                                   fromDate:date];
        XCTAssertEqual(components.day, 1);
        XCTAssertEqual(components.month, 1);
        XCTAssertEqual(components.year, 2000);
        XCTAssertEqual(components.hour, 0);
    } else {
        XCTAssertNotNil(date);
    }
}

- (void)testDateNil {
    NSString *dateString = nil;
    
    OTObjectBase *object = [OTObjectBase new];
    NSDate *date = [object dateFromString:dateString];
    
    XCTAssertNil(date);
}

@end

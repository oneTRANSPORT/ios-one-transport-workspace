//
//  OneTransportCommonTests.m
//  oneTRANSPORT
//
//  Created by Dominic Frazer Imregh on 05/09/2016.
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
#import "OTTransportTypes.h"

@interface OneTransportCommonTests : OneTransportBaseTests

@end

@implementation OneTransportCommonTests

- (NSDictionary *)dictSimple {
    
    NSMutableArray *array = [NSMutableArray new];
    
    NSMutableDictionary *dict;
    dict = [NSMutableDictionary new];
    [dict setObject:@"TRAFFIC1" forKey:@"name"];
    [dict setObject:@"ABC123" forKey:@"locationId"];
    [dict setObject:@"51.628210000000003" forKey:@"latitude"];
    [dict setObject:@"-0.75028269999999997" forKey:@"longitude"];
    [dict setObject:[NSArray arrayWithObjects:@"CONGESTION", nil] forKey:@"vmsLegends"];
    [array addObject:dict];
    
    dict = [NSMutableDictionary new];
    [dict setObject:@"TRAFFIC2" forKey:@"name"];
    [dict setObject:@"XYZ789" forKey:@"locationId"];
    [dict setObject:@"51.864356999999998" forKey:@"latitude"];
    [dict setObject:@"-0.70586899999999997" forKey:@"longitude"];
    [dict setObject:[NSArray arrayWithObjects:@"CONGESTION", nil] forKey:@"vmsLegends"];
    [array addObject:dict];
    
    dict = [NSMutableDictionary new];
    [dict setObject:array forKey:@"con"];
    return dict;
}

- (void)testFavourite {
    
    [self.singleton.variableMS removeAll];
    
    NSDictionary *dict = [self dictSimple];
    NSArray *arrayCommon = [self.singleton.variableMS populateTableWith:dict[@"con"] timestamp:[NSDate date]];
    [self.singleton.common populateTableWith:arrayCommon type:self.singleton.variableMS.dataType];
    XCTAssertTrue(arrayCommon.count == 2);
    
    BOOL favourite;
    
    ObjectType type = (ObjectType)ObjectTypeVariableMessageSigns;
    [self.singleton.common setFavourite:@"ABC123" type:type set:true];
    favourite = [self.singleton.common isFavourite:@"ABC123" type:type];
    XCTAssertTrue(favourite);

    [self.singleton.common setFavourite:@"ABC123" type:type set:false];
    favourite = [self.singleton.common isFavourite:@"ABC123" type:type];
    XCTAssertFalse(favourite);
}

@end

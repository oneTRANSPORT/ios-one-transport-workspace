//
//  OneTransportBCSketch.m
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

@interface OneTransportBCSketch : OneTransportBaseTests

@end

@implementation OneTransportBCSketch

- (NSString *)stringSimple {
    
    return @"_id\tsketch_id\tvector_id\tvisible\tcopyrights\tcoordinates\tcin_id\tcreation_time\t1\t1\t276\t1\t[{\"lat\":52.177415577542504, \"lon\":-0.9554690223566572},{\"lat\":52.17309288543352, \"lon\":-0.957378755174918},{\"lat\":52.16865132590965, \"lon\":-0.9596210819110648},{\"lat\":52.16196512028643, \"lon\":-0.9630543094497152},{\"lat\":52.15988534756617, \"lon\":-0.9641701083997002},{\"lat\":52.15733156965089, \"lon\":-0.9652429920055173},{\"lat\":52.155922979961424, \"lon\":-0.9657794338084256},{\"lat\":52.154632830670735, \"lon\":-0.966423163971934}]\tcin19700513T15410411461264140490819352320\t1472123036";
}

- (NSString *)stringFail {
    
    return @"_id\tsketch_id\tvector_id\tvisible\tcoordinates\tcin_id\tcreation_time\t1\t1\t276\t1\t[{\"lat\":52.177415577542504, \"lon\":-0.9554690223566572},{\"lat\":52.17309288543352, \"lon\":-0.957378755174918},{\"lat\":52.16865132590965, \"lon\":-0.9596210819110648},{\"lat\":52.16196512028643, \"lon\":-0.9630543094497152},{\"lat\":52.15988534756617, \"lon\":-0.9641701083997002},{\"lat\":52.15733156965089, \"lon\":-0.9652429920055173},{\"lat\":52.155922979961424, \"lon\":-0.9657794338084256},{\"lat\":52.154632830670735, \"lon\":-0.966423163971934}]\tcin19700513T15410411461264140490819352320\t1472123036";
}

- (void)testImportSuccess {
        
    PopulateBlock completionBlock = ^(BOOL success) {
        XCTAssertTrue(success);
    };
    
    [self.singleton.bitCarrierSketch populateTSV:[self stringSimple] completion:completionBlock];
}

- (void)testImportFail {
    
    PopulateBlock completionBlock = ^(BOOL success) {
        XCTAssertFalse(success);
    };
    
    [self.singleton.bitCarrierSketch populateTSV:[self stringFail] completion:completionBlock];
}

@end

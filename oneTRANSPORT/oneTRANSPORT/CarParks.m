//
//  CarParks.m
//  oneTRANSPORT
//
//  Created by Dominic Frazer Imregh on 16/08/2016.
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

#import "CarParks.h"

@implementation CarParks

- (NSString *)localizedMessage {
    
    if (self.capacity.integerValue > 0) {
        NSString *spaces;
        if (self.localizedCounter >= 0) {
            spaces = [NSString stringWithFormat:@"%zd%% full", self.localizedCounter];
        } else {
            spaces = self.full.boolValue ? @"no spaces" : @"spaces available";
        }
        return [NSString stringWithFormat:@"Capacity %zd, %@", self.capacity.integerValue, spaces];
    } else {
        NSString *spaces = self.full.boolValue ? @"No spaces" : @"Spaces available";
        return spaces;
    }
}

- (NSInteger)localizedCounter {
    
    if (self.full.boolValue) {
        return -1;
    } else {
        if (self.occupancy.integerValue > 0) {
            return (self.occupancy.floatValue / self.capacity.floatValue) * 100;
        } else {
            return -2;
        }
    }
}

- (NSInteger)localizedCounterSub {
    
    return self.capacity.integerValue;
}

@end

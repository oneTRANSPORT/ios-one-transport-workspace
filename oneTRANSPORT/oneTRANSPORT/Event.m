//
//  Event.m
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

#import "Event.h"

@implementation Event

- (NSString *)impactOnTraffic {
    
    if ([self primitiveValueForKey:@"impactOnTraffic"] == NULL) {
        return @"";
    } else {
        return [self primitiveValueForKey:@"impactOnTraffic"];
    }
}

- (NSString *)validityStatus {
    
    if ([self primitiveValueForKey:@"validityStatus"] == NULL) {
        return @"";
    } else {
        return [self primitiveValueForKey:@"validityStatus"];
    }
}

- (NSString *)localizedMessage {
    
    return self.impactOnTraffic;
}

- (NSInteger)localizedCounter {
    
    return [self localizedCounterSub];
}

- (NSInteger)localizedCounterSub {
    
    return [self.validityStatus isEqualToString:@"active"];
}

@end

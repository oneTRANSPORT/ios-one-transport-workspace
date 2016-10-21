//
//  TrafficScoot+CoreDataClass.m
//  oneTRANSPORT
//
//  Created by Dominic Frazer Imregh on 07/10/2016.
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

#import "TrafficScoot.h"
#import "OTTransportTypes.h"

@implementation TrafficScoot

#define kKphToMiles     0.621371

- (NSString *)localizedMessage {
    
    BOOL kph = [[NSUserDefaults standardUserDefaults] boolForKey:kUserDefaultsKph];
    
    NSInteger flowRate = self.currentFlow.integerValue;
    NSInteger avSpeed = [self localizedSpeed];
    
    NSMutableString *string = [NSMutableString new];
    if (flowRate > 0) {
        [string appendFormat:@"Flow per minute = %zd vehicles", flowRate];
    }
    
    if (avSpeed > 0) {
        NSString *speedUnit;
        if (kph) {
            speedUnit = @"kph";
        } else {
            speedUnit = @"mph";
        }
        if (string.length > 0) {
            [string appendString:@"\n"];
        }
        [string appendFormat:@"Average speed = %zd %@", avSpeed, speedUnit];
    }
    
    if (string.length > 0) {
        [string appendString:@"\n"];
    }
    [string appendFormat:@"Congestion = %zd%%", self.congestionPercent.integerValue];

    return [NSString stringWithString:string];
}

- (NSInteger)localizedCounter {
    
    return [self localizedSpeed];
}

- (NSInteger)localizedCounterSub {
    
    return self.congestionPercent.integerValue;
}

- (NSInteger )localizedSpeed {
    
    BOOL kph = [[NSUserDefaults standardUserDefaults] boolForKey:kUserDefaultsKph];
    
    NSInteger avSpeed = self.averageSpeed.integerValue;
    if (!kph) {
        float floatAvSpeed = avSpeed;
        avSpeed = floatAvSpeed * kKphToMiles;
    }
    
    return avSpeed;
}

@end

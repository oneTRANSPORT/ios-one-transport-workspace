//
//  VariableMessageSigns.m
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

#import "VariableMessageSigns.h"

@implementation VariableMessageSigns

- (NSString *)localizedMessage {
    
    if (self.legends == nil) {
        return @"";
    }
    NSString *strip = [self.legends stringByReplacingOccurrencesOfString:@"\n" withString:@" "];
    for (int i=0; i<=2; i++) {
        strip = [strip stringByReplacingOccurrencesOfString:@"  " withString:@" "];
    }
    while ([strip hasPrefix:@" "]) {
        strip = [strip stringByReplacingCharactersInRange:NSMakeRange(0, 1) withString:@""];
    }
    return strip;
}

- (NSInteger)localizedCounter {
    
    return 0;
}

- (NSInteger)localizedCounterSub {
    
    return 0;
}

@end

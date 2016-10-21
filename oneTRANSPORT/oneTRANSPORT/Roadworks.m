//
//  Roadworks.m
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

#import "Roadworks.h"

@implementation Roadworks

- (NSString *)localizedMessage {
    
    if (self.comment == nil) {
        return @"";
    }
    
    if (![self.comment containsString:@": Event Location :"] && ![self.comment containsString:@": Location "]) {
        return self.comment;
    } else {
        NSString *reason = @"";
        NSString *location = @"";
        NSString *closures = @"";
     
        NSArray *array = [self.comment componentsSeparatedByString:@" : "];
        NSMutableDictionary *dict = [NSMutableDictionary new];
        for (int i=0; i<array.count; i+=2) {
            [dict setValue:array[i + 1] forKey:array[i]];
        }
        
        if (dict[@"Event Location"]) {
            reason = dict[@"Event Reason"];
            location = dict[@"Event Location"];
        } else if (dict[@"Location"]) {
            reason = dict[@"Reason"];
            location = dict[@"Location"];
        }
        closures = dict[@"Lane Closures"];
        if ([closures hasPrefix:@"TYPE"]) {
            closures = @"";
        }
        location = [location stringByReplacingOccurrencesOfString:@"^The" withString:@""];
    
        NSMutableString *string = [NSMutableString new];
        if (reason.length > 0) {
            [string appendString:reason];
        }
        if (location.length > 0) {
            if (string.length > 0) {
                [string appendString:@"\n"];
            }
            [string appendString:location];
        }
        if (closures.length > 0) {
            if (string.length > 0) {
                [string appendString:@"\n"];
            }
            [string appendString:closures];
        }
        
        return [NSString stringWithString:string];
    }
}

- (NSInteger)localizedCounter {
    
    return 0;
}

- (NSInteger)localizedCounterSub {
    
    return 0;
}

@end

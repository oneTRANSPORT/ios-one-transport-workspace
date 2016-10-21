//
//  NSObject+Extras.m
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

#import "NSObject+Collection.h"

@implementation NSObject (Collection)

- (NSDictionary *)validateDictionary:(id)object {
    
    if (object != nil && [object isKindOfClass:[NSDictionary class]]) {
        return object;
    } else {
        return [NSDictionary new];
    }
}

- (NSArray *)validateArray:(id)object {
    
    if (object != nil && [object isKindOfClass:[NSArray class]]) {
        return object;
    } else {
        return [NSArray new];
    }
}

- (NSString *)validateString:(id)object {
    
    if (object != nil && [object isKindOfClass:[NSString class]]) {
        return object;
    } else {
        return @"";
    }
}

- (NSNumber *)validateNumberInt:(id)object {
    
    if (object != nil && [object isKindOfClass:[NSNumber class]]) {
        return object;
    } else if ([object isKindOfClass:[NSString class]]) {
        return @([object integerValue]);
    } else {
        return @(0);
    }
}

- (NSNumber *)validateNumberDouble:(id)object {
    
    if (object != nil && [object isKindOfClass:[NSNumber class]]) {
        return object;
    } else if ([object isKindOfClass:[NSString class]]) {
        return @([object doubleValue]);
    } else {
        return @(0);
    }
}

@end

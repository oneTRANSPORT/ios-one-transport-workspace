//
//  OTSetOfAcrs.m
//  FlorenceSDK
//
//  Created by Dominic Frazer Imregh on 28/07/2016.
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

#import "OTSetOfAccessControlRules.h"

@implementation OTSetOfAccessControlRules

- (instancetype)init {
    
    if (self = [super init]) {
        _accessControlRules = [NSMutableArray new];
    }
    return self;
}

- (void)dealloc {
    
    [_accessControlRules removeAllObjects];
}

- (void)updateCommonResources:(NSDictionary *)dict {
    
    [_accessControlRules removeAllObjects];
    for (NSDictionary *dictSub in dict[kKey_AccessControlRules]) {
        OTAccessControlRule *rule = [OTAccessControlRule new];
        [rule updateCommonResources:dictSub];
        [_accessControlRules addObject:rule];
    }
}

- (NSDictionary *)addPayload:(CommandType)method {
    
    NSMutableArray *array = [NSMutableArray new];
    for (OTAccessControlRule *acr in _accessControlRules) {
        [array addObject:[acr addPayload:method]];
    }
    return [NSDictionary dictionaryWithObject:array forKey:kKey_AccessControlRules];
}

- (OTAccessControlRule *)addNewRule {
    
    OTAccessControlRule *rule = [OTAccessControlRule new];
    [_accessControlRules addObject:rule];

    return rule;
}

@end

//
//  OTAccessControlContext.m
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

#import "OTAccessControlContext.h"

@implementation OTAccessControlContext

- (instancetype)init {
    
    if (self = [super init]) {
        _accessControlWindows = [NSMutableArray new];
        _accessControlIpAddresses = [NSMutableArray new];
    }
    return self;
}

- (void)dealloc {
    
    [_accessControlWindows removeAllObjects];
    [_accessControlIpAddresses removeAllObjects];
}

- (void)updateCommonResources:(NSDictionary * _Nonnull)dict {
    
    [_accessControlWindows removeAllObjects];
    for (NSString *string in dict[kKey_AccessControlWindows]) {
        [_accessControlWindows addObject:[string copy]];
    }
    
    [_accessControlIpAddresses removeAllObjects];
    for (NSDictionary *dictIp in dict[kKey_AccessControlIpAddresses]) {
        OTAccessControlIpAddress *ip = [OTAccessControlIpAddress new];
        [ip updateCommonResources:dictIp];
        [_accessControlIpAddresses addObject:ip];
    }
}

- (NSDictionary *)addPayload:(CommandType)method {
    
    NSMutableDictionary *dict = [NSMutableDictionary new];
    
    NSMutableArray *array = [NSMutableArray new];
    for (NSString *string in _accessControlWindows) {
        [array addObject:[string copy]];
    }
    if (array.count) {
        [dict setObject:array forKey:kKey_AccessControlWindows];
    }
    
    array = [NSMutableArray new];
    for (OTAccessControlIpAddress *acip in _accessControlIpAddresses) {
        [array addObject:[acip addPayload:method]];
    }
    if (array.count) {
        [dict setObject:array forKey:kKey_AccessControlIpAddresses];
    }
    
    return [NSDictionary dictionaryWithDictionary:dict];
}

#pragma mark - Array helpers

- (void)addControlWindow:(NSString *)dateString {
    
    BOOL found = false;
    for (NSString *string in _accessControlWindows) {
        if ([string isEqualToString:dateString]) {
            found =  true;
            break;
        }
    }
    if (!found) {
        [_accessControlWindows addObject:[dateString copy]];
    }
}

- (void)removeControlWindow:(NSString *)dateString {
    
    for (NSString *string in _accessControlWindows) {
        if ([string isEqualToString:dateString]) {
            [_accessControlWindows removeObject:string];
            break;
        }
    }
}

- (void)addControlIpAddress:(OTAccessControlIpAddress *)ipAddr {
    
    if (![_accessControlIpAddresses containsObject:ipAddr]) {
        [_accessControlIpAddresses addObject:ipAddr];
    }
}

- (void)removeControlIpAddress:(OTAccessControlIpAddress *)ipAddr {
    
    if ([_accessControlIpAddresses containsObject:ipAddr]) {
        [_accessControlIpAddresses removeObject:ipAddr];
    }
}

@end

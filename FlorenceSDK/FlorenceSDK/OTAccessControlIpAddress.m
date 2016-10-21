//
//  OTAccessControlIpAddress.m
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

#import "OTAccessControlIpAddress.h"
#import "NSObject+Extras.h"

@implementation OTAccessControlIpAddress

- (instancetype)init {
    
    if (self = [super init]) {
        _ipv4Address = @"";
        _ipv6Address = @"";
    }
    return self;
}

- (void)updateCommonResources:(NSDictionary * _Nonnull)dict {
    
    _ipv4Address = [NSObject validateString:dict[kKey_Ipv4Address]];
    _ipv6Address = [NSObject validateString:dict[kKey_Ipv6Address]];
}

- (NSDictionary *)addPayload:(CommandType)method {
    
    NSMutableDictionary *dict = [NSMutableDictionary new];
    if (_ipv4Address.length) {
        [dict setObject:_ipv4Address forKey:kKey_Ipv4Address];
    }
    if (_ipv6Address.length) {
        [dict setObject:_ipv6Address forKey:kKey_Ipv6Address];
    }
    return [NSDictionary dictionaryWithDictionary:dict];
}

@end

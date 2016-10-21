//
//  OTAccessControlRule.m
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

#import "OTAccessControlRule.h"
#import "NSObject+Extras.h"

@implementation OTAccessControlRule

- (instancetype)init {
    
    if (self = [super init]) {
        _accessControlOriginators = [NSMutableArray new];
        _accessControlOperations = AccessControlOperationALL;
        _accessControlContexts = [NSMutableArray new];
        _accessControlLocationRegions = [NSMutableArray new];
    }
    return self;
}

- (void)dealloc {
    
    [_accessControlOriginators removeAllObjects];
    [_accessControlContexts removeAllObjects];
    [_accessControlLocationRegions removeAllObjects];
}

- (void)updateCommonResources:(NSDictionary * _Nonnull)dict {
    
    _accessControlOperations = (AccessControlOperation)[NSObject validateInt:dict[kKey_AccessControlOperations]];
    
    [_accessControlOriginators removeAllObjects];
    for (NSString *string in dict[kKey_AccessControlOriginators]) {
        [_accessControlOriginators addObject:[string copy]];
    }

    [_accessControlContexts removeAllObjects];
    for (NSDictionary *dictContext in dict[kKey_AccessControlContexts]) {
        OTAccessControlContext *context = [OTAccessControlContext new];
        [context updateCommonResources:dictContext];
        [_accessControlContexts addObject:context];
    }

    [_accessControlLocationRegions removeAllObjects];
    for (NSDictionary *dictRegion in dict[kKey_AccessControlLocationRegions]) {
        OTLocationRegion *region = [OTLocationRegion new];
        [region updateCommonResources:dictRegion];
        [_accessControlLocationRegions addObject:region];
    }
}

- (NSDictionary *)addPayload:(CommandType)method {
    
    NSMutableDictionary *dict = [NSMutableDictionary new];
    NSMutableArray *array;
    
    [dict setObject:@(_accessControlOperations) forKey:kKey_AccessControlOperations];
    
    array = [NSMutableArray new];
    for (NSString *string in _accessControlOriginators) {
        [array addObject:[string copy]];
    }
    if (array.count) {
        [dict setObject:array forKey:kKey_AccessControlOriginators];
    }
    
    array = [NSMutableArray new];
    for (OTAccessControlContext *context in _accessControlContexts) {
        [array addObject:[context addPayload:method]];
    }
    if (array.count) {
        [dict setObject:array forKey:kKey_AccessControlContexts];
    }
    
    array = [NSMutableArray new];
    for (OTLocationRegion *region in _accessControlLocationRegions) {
        [array addObject:[region addPayload:method]];
    }
    if (array.count) {
        [dict setObject:array forKey:kKey_AccessControlLocationRegions];
    }
    
    return [NSDictionary dictionaryWithDictionary:dict];
}

#pragma mark - Array helpers

- (void)addControlOriginator:(NSString *)originator {
    
    BOOL found = false;
    for (NSString *string in _accessControlOriginators) {
        if ([string isEqualToString:originator]) {
            found =  true;
            break;
        }
    }
    if (!found) {
        [_accessControlOriginators addObject:[originator copy]];
    }
}

- (void)removeControlOriginator:(NSString *)originator {
    
    for (NSString *string in _accessControlOriginators) {
        if ([string isEqualToString:originator]) {
            [_accessControlOriginators removeObject:string];
            break;
        }
    }
}

- (void)addControlContext:(OTAccessControlContext *)context {
    
    if (![_accessControlContexts containsObject:context]) {
        [_accessControlContexts addObject:context];
    }
}

- (void)removeControlContext:(OTAccessControlContext *)context {
    
    if ([_accessControlContexts containsObject:context]) {
        [_accessControlContexts removeObject:context];
    }
}

- (void)addLocationRegion:(OTLocationRegion *)region {
    
    if (![_accessControlLocationRegions containsObject:region]) {
        [_accessControlLocationRegions addObject:region];
    }
}

- (void)removeLocationRegion:(OTLocationRegion *)region {
    
    if ([_accessControlLocationRegions containsObject:region]) {
        [_accessControlLocationRegions removeObject:region];
    }
}

@end

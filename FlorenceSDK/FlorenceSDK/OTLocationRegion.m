//
//  OTLocationRegion.m
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

#import "OTLocationRegion.h"
#import "OTLocationRegionCircular.h"

@implementation OTLocationRegion

- (instancetype)init {
    
    if (self = [super init]) {
        _countryCode = [NSMutableArray new];
        _circularRegion = [OTLocationRegionCircular new];
    }
    return self;
}

- (void)dealloc {
    
    [_countryCode removeAllObjects];
}

- (void)updateCommonResources:(NSDictionary * _Nonnull)dict {
    
    [_countryCode removeAllObjects];
    for (NSString *string in dict[kKey_CountryCode]) {
        [_countryCode addObject:[string copy]];
    }
    
    NSMutableArray *array = [NSMutableArray new];
    for (NSString *string in dict[kKey_CircularRegion]) {
        [array addObject:@([string doubleValue])];
    }
    if (array.count >= 3) {
        _circularRegion.coordinate = CGPointMake([array[0] floatValue], [array[1] floatValue]);
        _circularRegion.radius = [array[2] floatValue];
    }
}

- (NSDictionary *)addPayload:(CommandType)method {
    
    NSMutableDictionary *dict = [NSMutableDictionary new];
    
    NSMutableArray *array;

    array = [NSMutableArray new];
    for (NSString *string in _countryCode) {
        [array addObject:[string copy]];
    }
    if (array.count) {
        [dict setObject:array forKey:kKey_CountryCode];
    }

    array = [NSMutableArray new];
    [array addObject:@(_circularRegion.coordinate.x)];
    [array addObject:@(_circularRegion.coordinate.y)];
    [array addObject:@(_circularRegion.radius)];
    [dict setObject:array forKey:kKey_CircularRegion];

    return [NSDictionary dictionaryWithDictionary:dict];
}

#pragma mark - Array helpers

- (void)addCountryCode:(NSString *)code {
    
    BOOL found = false;
    for (NSString *string in _countryCode) {
        if ([string isEqualToString:code]) {
            found =  true;
            break;
        }
    }
    if (!found) {
        [_countryCode addObject:[code copy]];
    }
}

- (void)removeCountryCode:(NSString *)code {
    
    for (NSString *string in _countryCode) {
        if ([string isEqualToString:code]) {
            [_countryCode removeObject:string];
            break;
        }
    }
}

@end

//
//  IDObjectAnnounceableResource.m
//  FlorenceSDK
//
//  Created by Dominic Frazer Imregh on 20/07/2016.
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

#import "OTObjectBase+Private.h"
#import "OTObjectAnnounceableResource+Private.h"
#import "NSObject+Extras.h"

@implementation OTObjectAnnounceableResource

- (void)updateCommonResources:(NSDictionary *)dict {
    [super updateCommonResources:dict];

    if (dict[kKey_AnnounceTo]) {
        if ([dict[kKey_AnnounceTo] isKindOfClass:[NSArray class]]) {
            NSMutableArray *array = [NSMutableArray new];
            for (NSString *item in dict[kKey_AnnounceTo]) {
                [array addObject:[item copy]];
            }
            _announceTo = [NSArray arrayWithArray:array];
        }
    }
    
    if (dict[kKey_AnnouncedAttribute]) {
        _announcedAttribute          = [NSObject validateString:dict[kKey_AnnouncedAttribute]];
    }
}

@end

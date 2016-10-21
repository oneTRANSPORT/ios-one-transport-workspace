//
//  IDAccessControlPolicy.m
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

#import "OTAccessControlPolicy+Private.h"

@implementation OTAccessControlPolicy

- (instancetype)initWithId:(NSString *)resourceId
                      name:(NSString *)resourceName
                    parent:(id)parent {
    
    if (self = [super initWithId:resourceId name:resourceName parent:parent]) {

        self.privileges = [OTSetOfAccessControlRules new];
        self.selfPrivileges = [OTSetOfAccessControlRules new];
    }
    return self;
}

- (void)updateCommonResources:(NSDictionary *)dict {
    [super updateCommonResources:dict];
    
    self.privileges = [OTSetOfAccessControlRules new];
    [self.privileges updateCommonResources:dict[kKey_Privileges]];
    
    self.selfPrivileges = [OTSetOfAccessControlRules new];
    [self.selfPrivileges updateCommonResources:dict[kKey_SelfPrivileges]];
}

- (void)setPayload:(NSMutableDictionary *)dictSub method:(CommandType)method {

    [dictSub setObject:[self.privileges addPayload:method] forKey:kKey_Privileges];
    [dictSub setObject:[self.selfPrivileges addPayload:method] forKey:kKey_SelfPrivileges];
    
    if (method == CommandTypeCreate) {
        [dictSub setObject:self.resourceName forKey:kKey_ResourceName];
    } else {
    }
}

- (NSString *)payloadKey {
    
    return kKey_AccessControlPolicy;
}

#pragma mark - Content

@end

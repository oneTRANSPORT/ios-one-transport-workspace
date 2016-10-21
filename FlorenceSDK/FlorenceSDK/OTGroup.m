//
//  OTGroup.m
//  FlorenceSDK
//
//  Created by Dominic Frazer Imregh on 26/07/2016.
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

#import "OTGroup+Private.h"
#import "NSObject+Extras.h"

@implementation OTGroup

- (instancetype)initWithId:(NSString *)resourceId
                      name:(NSString *)resourceName
                    parent:(id)parent {
    
    if (self = [super initWithId:resourceId name:resourceName parent:parent]) {
        _maxNumberOfMembers = 10;
        _groupName = resourceName;
        _memberIds = [NSMutableArray new];
        _memberAccessControlPolicies = [NSMutableArray new];
    }
    return self;
}

- (void)dealloc {
    
    [_memberIds removeAllObjects];
    [_memberAccessControlPolicies removeAllObjects];
}

- (void)updateCommonResources:(NSDictionary *)dict {
    [super updateCommonResources:dict];
    
    if (dict[kKey_GroupName]) {
        _groupName              = [NSObject validateString:dict[kKey_GroupName]];
    }
    if (dict[kKey_FanOutPoint]) {
        _fanOutPoint            = [NSObject validateString:dict[kKey_FanOutPoint]];
    }
    if (dict[kKey_MemberType]) {
        _memberType             = [NSObject validateInt:dict[kKey_MemberType]];
    }
    if (dict[kKey_CurrentNumberOfMembers]) {
        _currentNumberOfMembers = [NSObject validateInt:dict[kKey_CurrentNumberOfMembers]];
    }
    if (dict[kKey_MaxNumberOfMembers]) {
        _maxNumberOfMembers     = [NSObject validateInt:dict[kKey_MaxNumberOfMembers]];
    }
    if (dict[kKey_MemberIds]) {
        if ([dict[kKey_MemberIds] isKindOfClass:[NSArray class]]) {
            [_memberIds removeAllObjects];
            for (NSString *item in dict[kKey_MemberIds]) {
                [_memberIds addObject:[item copy]];
            }
        }
    }
    if (dict[kKey_MemberAccessControlPolicies]) {
        if ([dict[kKey_MemberAccessControlPolicies] isKindOfClass:[NSArray class]]) {
            [_memberAccessControlPolicies removeAllObjects];
            for (NSString *item in dict[kKey_MemberAccessControlPolicies]) {
                [_memberAccessControlPolicies addObject:[item copy]];
            }
        }
    }
    if (dict[kKey_MemberTypeValidated]) {
        _memberTypeValidated    = [NSObject validateBool:dict[kKey_MemberTypeValidated]];
    }
    if (dict[kKey_ConsistencyStrategy]) {
        _consistencyStrategy    = [NSObject validateInt:dict[kKey_ConsistencyStrategy]];
    }
}

- (void)setPayload:(NSMutableDictionary *)dictSub method:(CommandType)method {
    
    [dictSub setValue:self.memberIds forKey:kKey_MemberIds];
    [dictSub setValue:@(self.maxNumberOfMembers) forKey:kKey_MaxNumberOfMembers];
    if (self.accessControlPolicyIds.count) {
        [dictSub setValue:self.accessControlPolicyIds forKey:kKey_AccessControlPolicyIds];
    }
    
    if (method == CommandTypeCreate) {
    } else {
    }
}

- (NSString *)payloadKey {
    
    return @"grp";
}

#pragma mark - Content

- (BOOL)foundMember:(NSString *)memberUri {
    
    BOOL found = false;
    for (NSString *uri in _memberIds) {
        if ([uri isEqualToString:memberUri]) {
            found = true;
            break;
        }
    }
    return found;
}

- (void)addMember:(NSString *)memberUri {
    
    if (![self foundMember:memberUri]) {
        [_memberIds addObject:memberUri];
    }
}

- (void)removeMember:(NSString *)memberUri {
    
    if (![self foundMember:memberUri]) {
        for (int i=0; i<_memberIds.count; i++) {
            if ([_memberIds[i] isEqualToString:memberUri]) {
                [_memberIds removeObjectAtIndex:i];
                break;
            }
        }
    }
}

- (BOOL)foundAccessControlPolicy:(NSString *)acpName {
    
    BOOL found = false;
    for (NSString *string in _memberAccessControlPolicies) {
        if ([string isEqualToString:acpName]) {
            found = true;
            break;
        }
    }
    return found;
}

- (void)addAccessControlPolicy:(NSString *)acpName {
    
    if (![self foundAccessControlPolicy:acpName]) {
        [_memberAccessControlPolicies addObject:[acpName copy]];
    }
}

- (void)removeAccessControlPolicy:(NSString *)acpName {
    
    if (![self foundMember:acpName]) {
        for (int i=0; i<_memberAccessControlPolicies.count; i++) {
            if ([_memberAccessControlPolicies[i] isEqualToString:acpName]) {
                [_memberAccessControlPolicies removeObjectAtIndex:i];
                break;
            }
        }
    }
}

@end

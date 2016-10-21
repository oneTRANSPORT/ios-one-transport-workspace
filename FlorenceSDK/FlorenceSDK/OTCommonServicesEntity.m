//
//  OTCommonServicesEntity.m
//  FlorenceSDK
//
//  Created by Dominic Frazer Imregh on 05/07/2016.
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

#import "OTCommonServicesEntity+Private.h"
#import "OTApplicationEntity.h"
#import "OTGroup.h"
#import "OTAccessControlPolicy.h"

@implementation OTCommonServicesEntity

- (instancetype)initWithBaseUrl:(NSString *)baseUrl
                          appId:(NSString *)appId
                     resourceId:(NSString *)resourceId
                   resourceName:(NSString *)resourceName {
    
    if (self = [super initWithId:resourceId name:resourceName parent:nil]) {
        self.baseUrl = baseUrl;
        self.appId = appId;
        self.arrayAe = [NSMutableArray new];
        self.arrayGroup = [NSMutableArray new];
        self.arrayAcp = [NSMutableArray new];
    }
    return self;
}

- (void)dealloc {

    [_arrayAe removeAllObjects];
    [_arrayGroup removeAllObjects];
    [_arrayAcp removeAllObjects];
}

- (OTApplicationEntity *)aeWithId:(NSString *)resourceId {
 
    for (OTApplicationEntity *ae in self.arrayAe) {
        if ([ae.resourceId isEqualToString:resourceId]) {
            return ae;
        }
    }
    return nil;
}

- (OTApplicationEntity *)createAeWithId:(NSString *)resourceId name:(NSString *)resourceName {
    
    OTApplicationEntity *ae = [self aeWithId:resourceId];
    if (!ae) {
        ae = [[OTApplicationEntity alloc] initWithId:resourceId name:resourceName appId:self.appId parent:self];
        [self.arrayAe addObject:ae];
    }
    
    return ae;
}

#pragma mark - Groups

- (OTGroup *)groupWithName:(NSString *)resourceName {
    
    for (OTGroup *group in self.arrayGroup) {
        if ([group.resourceName isEqualToString:resourceName]) {
            return group;
        }
    }
    return nil;
}

- (OTGroup *)createGroupWithName:(NSString *)resourceName {
    
    OTGroup *group = [self groupWithName:resourceName];
    if (!group) {
        group = [[OTGroup alloc] initWithId:nil name:resourceName parent:self];
        [self.arrayGroup addObject:group];
    }
    
    return group;
}

- (NSString *)uriForResourceName:(NSString *)resourceName {

    NSString *uri = nil;
    for (OTApplicationEntity *ae in self.arrayAe) {
        for (OTContainer *container in ae.arrayContainers) {
            uri = [self uriForResourceName:resourceName inContainer:container];
            if (uri) {
                break;
            }
        }
    }
    
    return uri;
}

- (NSString *)uriForResourceName:(NSString *)resourceName inContainer:(OTContainer *)container {

    NSString *uri = nil;
    if ([resourceName isEqualToString:container.resourceName]) {
        uri = [container getPath];
    } else {
        for (OTContainer *containerSub in container.arrayContainers) {
            uri = [self uriForResourceName:resourceName inContainer:containerSub];
            if (uri) {
                break;
            }
        }
    }

    return uri;
}

#pragma mark - Access Control Policy

- (OTAccessControlPolicy *)acpWithName:(NSString *)resourceName {
    
    for (OTAccessControlPolicy *acp in self.arrayAcp) {
        if ([acp.resourceName isEqualToString:resourceName]) {
            return acp;
        }
    }
    return nil;
}

- (OTAccessControlPolicy *)createAcpWithName:(NSString *)resourceName {
    
    OTAccessControlPolicy *acp = [self acpWithName:resourceName];
    if (!acp) {
        acp = [[OTAccessControlPolicy alloc] initWithId:nil name:resourceName parent:self];
        [self.arrayAcp addObject:acp];
    }
    
    return acp;
}

@end

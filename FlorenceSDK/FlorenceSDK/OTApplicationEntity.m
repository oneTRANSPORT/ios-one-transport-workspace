//
//  OTApplicationEntity.m
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

#import "OTApplicationEntity+Private.h"
#import "NSObject+Extras.h"
#import "OTContainer.h"
#import "OTContentInstance.h"
#import "OTAccessControlPolicy.h"

@implementation OTApplicationEntity

- (instancetype)initWithId:(NSString *)resourceId
                      name:(NSString *)resourceName
                     appId:(NSString *)appId
                    parent:(id)parent {
    
    if (self = [super initWithId:resourceId name:resourceName parent:parent]) {
        self.applicationId = appId;
        self.arrayContainers = [NSMutableArray new];
        self.arrayContent = [NSMutableArray new];
    }
    return self;
}

- (void)dealloc {
    
    [_arrayContainers removeAllObjects];
    [_arrayContent removeAllObjects];
}

- (void)updateCommonResources:(NSDictionary *)dict {
    [super updateCommonResources:dict];
    
    if (dict[kKey_ApplicationId]) {
        _applicationId          = [NSObject validateString:dict[kKey_ApplicationId]];
    }
    if (dict[kKey_OntologyReference]) {
        _ontologyReference      = [NSObject validateString:dict[kKey_OntologyReference]];
    }
    if (dict[kKey_RequestReachable]) {
        _requestReachable       = [NSObject validateBool:dict[kKey_RequestReachable]];
    }
    if (dict[kKey_NodeLink]) {
        _nodeLink               = [NSObject validateString:dict[kKey_NodeLink]];
    }
    
    if (dict[kKey_PointOfAccessList]) {
        if ([dict[kKey_PointOfAccessList] isKindOfClass:[NSArray class]]) {
            NSMutableArray *array = [NSMutableArray new];
            for (NSString *item in dict[kKey_PointOfAccessList]) {
                [array addObject:[item copy]];
            }
            _pointOfAccessList = [NSArray arrayWithArray:array];
        }
    }
}

- (void)setPayload:(NSMutableDictionary *)dictSub method:(CommandType)method {

    if (self.pointOfAccessList.count) {
        [dictSub setValue:self.pointOfAccessList forKey:kKey_PointOfAccessList];
    }
    [dictSub setValue:self.ontologyReference forKey:kKey_OntologyReference];

    [dictSub setValue:self.resourceLabels forKey:kKey_ResourceLabels];
    
    [dictSub setValue:@(self.requestReachable) forKey:kKey_RequestReachable];
    
    if (self.accessControlPolicyIds.count) {
        [dictSub setValue:self.accessControlPolicyIds forKey:kKey_AccessControlPolicyIds];
    }
    
    if (method == CommandTypeCreate) {
        [dictSub setValue:self.applicationId forKey:kKey_ApplicationId];
    } else {
    }
}

- (NSString *)payloadKey {
    
    return @"ae";
}

#pragma mark - Container

- (OTContainer *)containerWithName:(NSString *)resourceName {

    for (OTContainer *container in self.arrayContainers) {
        if ([container.resourceName isEqualToString:resourceName]) {
            return container;
        }
    }
    return nil;
}

- (OTContainer *)createContainerWithName:(NSString *)resourceName {

    OTContainer *container = [self containerWithName:resourceName];
    if (!container) {
        container = [[OTContainer alloc] initWithId:nil name:resourceName parent:self];
        [self.arrayContainers addObject:container];
    }
    return container;
}

- (void)refreshContents:(OTSessionTask *)session completionBlock:(CompletionType)completionBlock {
    
    CompletionType receivedResponseBlock = ^(NSDictionary *response, NSError *error) {
        if (error == nil) {
            self.commsStatus = CommunicationsProgressDone;

            NSDictionary *dict = response[kKey_Response_Ae];
            [self updateCommonResources:dict];
            
            NSDictionary *dictAe = [NSDictionary dictionaryWithObject:self forKey:@"ae"];
            completionBlock(dictAe, error);
        } else {
            self.commsStatus = CommunicationsProgressFail;
            completionBlock(nil, error);
        }
    };

    [self remoteRequest:CommandTypeGet subMethod:SubCommandTypeNone session:session completionBlock:receivedResponseBlock];
}

- (void)retrieveAndCreateFromList:(OTSessionTask *)session completionBlock:(CompletionType)completionBlock {
    
    CompletionType receivedRefreshBlock = ^(NSDictionary *response, NSError *error) {
        if (error == nil) {
            self.commsStatus = CommunicationsProgressDone;
            OTContainer *container = response[@"cn"];
            [container retrieveAndCreateFromList:session completionBlock:completionBlock];
        } else {
            self.commsStatus = CommunicationsProgressFail;
            completionBlock(nil, error);
        }
    };

  CompletionType receivedResponseBlock = ^(NSDictionary *response, NSError *error) {
        if (error == nil) {
            self.commsStatus = CommunicationsProgressDone;
            
            BOOL done = false;
            NSDictionary *dictCh = response[@"m2m:ae"];
            NSArray *arrayCnt = dictCh[@"ch"];
            for (NSDictionary *dictCnt in arrayCnt) {
                NSString *containerName = dictCnt[@"-nm"];
                
                [self createContainerWithName:containerName];
                if ([[NSUserDefaults standardUserDefaults] boolForKey:kKeyUserDefaults_Trace]) {
                    DLog(@"Container Name = %@", containerName);
                }
                
                OTContainer *container = [self containerWithName:containerName];
                if (container) {
                    [container refreshContents:session completionBlock:receivedRefreshBlock];
                    done = true;
                }
            }
            if (!done) {
                completionBlock(nil, nil);
            }
        } else {
            self.commsStatus = CommunicationsProgressFail;
            completionBlock(nil, error);
        }
    };
    
    [self remoteRequest:CommandTypeDiscoverViaRcn subMethod:SubCommandTypeNone session:session completionBlock:receivedResponseBlock];

}

#pragma mark - Content

- (OTContentInstance *)contentWithName:(NSString *)resourceName {
    
    for (OTContentInstance *content in self.arrayContent) {
        if ([content.resourceName isEqualToString:resourceName]) {
            return content;
        }
    }
    return nil;
}

- (OTContentInstance *)createContentInstanceWithName:(NSString *)resourceName {
    
    OTContentInstance *content = [self contentWithName:resourceName];
    if (!content) {
        content = [[OTContentInstance alloc] initWithId:nil name:resourceName parent:self];
        [self.arrayContent addObject:content];
    }
    return content;
}

#pragma mark - Access Control Policy

- (OTAccessControlPolicy *)acpWithName:(NSString *)resourceName {
    
    OTCommonServicesEntity *cse = (OTCommonServicesEntity *)self.parent;
    for (OTAccessControlPolicy *acp in cse.arrayAcp) {
        if ([acp.resourceName isEqualToString:resourceName]) {
            return acp;
        }
    }
    return nil;
}

- (OTAccessControlPolicy *)createAcpWithName:(NSString *)resourceName {
    
    OTAccessControlPolicy *acp = [self acpWithName:resourceName];
    if (!acp) {
        OTCommonServicesEntity *cse = (OTCommonServicesEntity *)self.parent;
        acp = [[OTAccessControlPolicy alloc] initWithId:nil name:resourceName parent:self];
        [cse.arrayAcp addObject:acp];
    }
    return acp;
}

@end

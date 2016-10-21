//
//  OTContainer.m
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

#import "OTContainer+Private.h"
#import "NSObject+Extras.h"
#import "OTContentInstance.h"
#import "OTApplicationEntity.h"

@implementation OTContainer

- (instancetype)initWithId:(NSString *)resourceId
                      name:(NSString *)resourceName
                    parent:(id)parent {

    if (self = [super initWithId:resourceId name:resourceName parent:parent]) {
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
    
    if (dict[kKey_Creator]) {
        _creator                    = [NSObject validateString:dict[kKey_Creator]];
    }
    if (dict[kKey_CurrentByteSize]) {
        _currentByteSize            = [NSObject validateInt:dict[kKey_CurrentByteSize]];
    }
    if (dict[kKey_CurrentNumberOfInstances]) {
        _currentNumberOfInstances   = [NSObject validateInt:dict[kKey_CurrentNumberOfInstances]];
    }
    if (dict[kKey_MaxByteSize]) {
        _maxByteSize                = [NSObject validateInt:dict[kKey_MaxByteSize]];
    }
    if (dict[kKey_MaxInstanceAge]) {
        _maxInstanceAge             = [NSObject validateInt:dict[kKey_MaxInstanceAge]];
    }
    if (dict[kKey_MaxNumberOfInstances]) {
        _maxNumberOfInstances       = [NSObject validateInt:dict[kKey_MaxNumberOfInstances]];
    }
    if (dict[kKey_StateTag]) {
        _stateTag                   = [NSObject validateInt:dict[kKey_StateTag]];
    }
    if (dict[kKey_Content]) {
        _content                    = [NSObject validateString:dict[kKey_Content]];
    }
}

- (void)setPayload:(NSMutableDictionary *)dictSub method:(CommandType)method {
    
    [dictSub setValue:self.resourceLabels forKey:kKey_ResourceLabels];

    if (self.accessControlPolicyIds.count) {
        [dictSub setValue:self.accessControlPolicyIds forKey:kKey_AccessControlPolicyIds];
    }
    
    if (method == CommandTypeCreate) {
        [dictSub setValue:self.creator forKey:kKey_Creator];
    } else {
    }
}

- (NSString *)payloadKey {

    return @"cnt";
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

- (void)refreshContents:(OTSessionTask *)session completionBlock:(CompletionType)completionBlock {
    
    CompletionType receivedResponseBlock = ^(NSDictionary *response, NSError *error) {
        if (error == nil) {
            self.commsStatus = CommunicationsProgressDone;

            NSDictionary *dict = response[kKey_Response_Cnt];
            [self updateCommonResources:dict];
            
            NSArray *arrayLabels = dict[kKey_ResourceLabels];
            if (arrayLabels.count) {
                self.label = arrayLabels[0];
            }
            NSDictionary *dictCnt = [NSDictionary dictionaryWithObject:self forKey:@"cn"];
            completionBlock(dictCnt, error);
        } else {
            completionBlock(nil, error);
        }
    };
    
    [self remoteRequest:CommandTypeGet subMethod:SubCommandTypeNone session:session completionBlock:receivedResponseBlock];
}

- (void)retrieveAndCreateFromList:(OTSessionTask *)session completionBlock:(CompletionType)completionBlock {
    
    CompletionType receivedRefreshBlock = ^(NSDictionary *response, NSError *error) {
        if (error == nil) {
            completionBlock(nil, nil);
//            OTContentInstance *content = response[@"ci"];
//            [content retrieveAndCreateFromList:session completionBlock:completionBlock];
        } else {
            completionBlock(nil, error);
        }
    };
    
//    CompletionType receivedResponseBlock = ^(NSDictionary *response, NSError *error) {
//        if (error == nil) {
//            self.commsStatus = CommunicationsProgressDone;
//
//            BOOL done = false;
//            NSArray *arrayCin = response[@"m2m:uril"];
//            for (NSString *idCin in arrayCin) {
//                NSArray *components = [idCin componentsSeparatedByString:@"/"];
//                NSString *contentName = [components lastObject];
//
//                if ([[NSUserDefaults standardUserDefaults] boolForKey:kKeyUserDefaults_Trace]) {
//                    DLog(@"Content Name = %@", contentName);
//                }
//                
//                OTContentInstance *content = [self createContentInstanceWithName:contentName];
//                if (content) {
//                    [content refreshContents:session completionBlock:receivedRefreshBlock];
//                    done = true;
//                }
//            }
//            if (!done) {
//                completionBlock(nil, nil);
//            }
//        } else {
//            completionBlock(nil, error);
//        }
//    };
//    
//    [self remoteRequest:CommandTypeDiscover subMethod:SubCommandTypeNone session:session completionBlock:receivedResponseBlock];

    CompletionType receivedResponseBlock = ^(NSDictionary *response, NSError *error) {
        if (error == nil) {
            self.commsStatus = CommunicationsProgressDone;
            
            BOOL done = false;
            NSDictionary *dictCh = response[kKey_Response_Cnt];
            NSArray *arrayCnt = dictCh[@"ch"];
            for (NSDictionary *dictCnt in arrayCnt) {
                NSString *contentName = dictCnt[@"-nm"];
                
                if ([[NSUserDefaults standardUserDefaults] boolForKey:kKeyUserDefaults_Trace]) {
                    DLog(@"Content Name = %@", contentName);
                }
                
                OTContentInstance *content = [self createContentInstanceWithName:contentName];
                if (content) {
                    [content refreshContents:session completionBlock:receivedRefreshBlock];
                    done = true;
                }
            }
            if (!done) {
                completionBlock(nil, nil);
            }
        } else {
            completionBlock(nil, error);
        }
    };
    
    [self remoteRequest:CommandTypeDiscoverViaRcn subMethod:SubCommandTypeNone session:session completionBlock:receivedResponseBlock];
}

@end

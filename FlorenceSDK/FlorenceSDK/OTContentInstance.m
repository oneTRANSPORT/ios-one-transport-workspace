//
//  OTContentInstance.m
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

#import "OTContentInstance+Private.h"
#import "NSObject+Extras.h"
#import "OTContainer.h"

@interface OTContentInstance()

@property (nonatomic) BOOL cancelled;

@end

@implementation OTContentInstance

- (instancetype)initWithId:(NSString *)resourceId
                      name:(NSString *)resourceName
                    parent:(id)parent {
    
    if (self = [super initWithId:resourceId name:resourceName parent:parent]) {

        _content = @"40";                   //defaults
        _contentInfo = @"text/plain:0";
    }
    return self;
}

- (void)dealloc {
    
    [self cancelRefresh];
}

- (void)updateCommonResources:(NSDictionary *)dict {
    [super updateCommonResources:dict];
    
    if (dict[kKey_Creator]) {
        _creator            = [NSObject validateString:dict[kKey_Creator]];
    }
    if (dict[kKey_ContentInfo]) {
        _contentInfo        = [NSObject validateString:dict[kKey_ContentInfo]];
    }
    if (dict[kKey_Content]) {
        _content            = [NSObject validateString:dict[kKey_Content]];
    }
    if (dict[kKey_ContentSize]) {
        _contentSize        = [NSObject validateInt:dict[kKey_ContentSize]];
    }
    if (dict[kKey_StateTag]) {
        _stateTag           = [NSObject validateInt:dict[kKey_StateTag]];
    }
}

- (void)setPayload:(NSMutableDictionary *)dictSub method:(CommandType)method {
    
    [dictSub setValue:self.contentInfo forKey:kKey_ContentInfo];
    [dictSub setValue:self.content forKey:kKey_Content];
    if (self.accessControlPolicyIds.count) {
        [dictSub setValue:self.accessControlPolicyIds forKey:kKey_AccessControlPolicyIds];
    }
    
    if (method == CommandTypeCreate) {
    } else {
    }
}

- (NSString *)payloadKey {
    
    return @"cin";
}

#pragma mark - Content

- (void)refreshContents:(OTSessionTask *)session completionBlock:(CompletionType)completionBlock {
    
    CompletionType receivedResponseBlock = ^(NSDictionary *response, NSError *error) {
        if (error == nil) {
            self.commsStatus = CommunicationsProgressDone;

            NSDictionary *dict = response[kKey_Response_Cin];
            [self updateCommonResources:dict];

            NSDictionary *dictCin = [NSDictionary dictionaryWithObject:self forKey:@"ci"];          //TODO - is this correct??
            completionBlock(dictCin, error);
        } else {
            self.commsStatus = CommunicationsProgressFail;
            completionBlock(nil, error);
        }
    };
    
    [self remoteRequest:CommandTypeGet subMethod:SubCommandTypeNone session:session completionBlock:receivedResponseBlock];
}

- (void)refreshContents:(OTSessionTask *)session interval:(NSTimeInterval)interval completionBlock:(CompletionType)completionBlock {

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, interval * NSEC_PER_SEC), dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{

        if (!_cancelled) {
            [self refreshContents:session completionBlock:completionBlock];
            [self refreshContents:session interval:interval completionBlock:[completionBlock copy]];
        }
    });
}

- (void)cancelRefresh {
    
    _cancelled = true;
}

@end

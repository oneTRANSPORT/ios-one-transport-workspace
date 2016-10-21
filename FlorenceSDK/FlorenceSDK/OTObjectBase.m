//
//  OTObjectBase.m
//  FlorenceSDK
//
//  Created by Dominic Frazer Imregh on 07/07/2016.
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
#import "NSObject+Extras.h"

#import "OTUrlRequestMap.h"
#import "OTSessionTask.h"

#import "OTCommonServicesEntity.h"
#import "OTApplicationEntity.h"
#import "OTContainer.h"
#import "OTGroup.h"
#import "OTAccessControlPolicy.h"

@implementation OTObjectBase

- (instancetype)initWithId:(NSString *)resourceId
                               name:(NSString *)resourceName
                             parent:(id)parent {
    
    if (self = [super init]) {
        self.resourceId = resourceId;
        self.resourceName = resourceName;
        self.parent = parent;
        self.commsStatus = CommunicationsProgressNeverCalled;
        self.resourceLabels = [NSMutableArray new];
        self.accessControlPolicyIds = [NSMutableArray new];
    }
    return self;
}

- (void)updateCommonResources:(NSDictionary *)dict {
    
    if (dict[kKey_ResourceId]) {
        _resourceId          = [NSObject validateString:dict[kKey_ResourceId]];
    }
    if (dict[kKey_ResourceName]) {
        _resourceName        = [NSObject validateString:dict[kKey_ResourceName]];
    }
    if (dict[kKey_ResourceRevision]) {
        _resourceRevision    = [NSObject validateInt:dict[kKey_ResourceRevision]];
    }
    if (dict[kKey_ResourceCreated]) {
        _resourceCreated     = [self dateFromString:[NSObject validateString:dict[kKey_ResourceCreated]]];
    }
    if (dict[kKey_ResourceExpires]) {
        _resourceExpires     = [self dateFromString:[NSObject validateString:dict[kKey_ResourceExpires]]];
    }
    if (dict[kKey_ResourceLastUpdated]) {
        _resourceLastUpdated = [self dateFromString:[NSObject validateString:dict[kKey_ResourceLastUpdated]]];
    }
    
    if (dict[kKey_ResourceLabels]) {
        if ([dict[kKey_ResourceLabels] isKindOfClass:[NSArray class]]) {
            [_resourceLabels removeAllObjects];
            for (NSString *item in dict[kKey_ResourceLabels]) {
                [_resourceLabels addObject:[item copy]];
            }
        }
    }

    if (dict[kKey_AccessControlPolicyIds]) {
        if ([dict[kKey_AccessControlPolicyIds] isKindOfClass:[NSArray class]]) {
            [_accessControlPolicyIds removeAllObjects];
            for (NSString *item in dict[kKey_AccessControlPolicyIds]) {
                [_accessControlPolicyIds addObject:[item copy]];
            }
        }
    }
}

- (void)setPayload:(NSMutableDictionary *)dictSub method:(CommandType)method { }

- (NSString *)payloadKey {
    return @"DeveloperError-KeyMissingInObject";
}

#pragma mark -

- (OTApplicationEntity *)getApplicationEntity {
    
    if ([self isKindOfClass:[OTCommonServicesEntity class]]) {
        OTCommonServicesEntity *cse = (OTCommonServicesEntity *)self;
        if (cse.arrayAe.count) {
            return cse.arrayAe[0];
        } else {
            return nil;
        }
    } else if ([self isKindOfClass:[OTApplicationEntity class]]) {
        return (OTApplicationEntity *)self;
    } else if ([self.parent isKindOfClass:[OTApplicationEntity class]]) {
        return self.parent;
    } else {
        return [((OTObjectBase *)self.parent) getApplicationEntity];
    }
}

- (NSString * _Nullable)getFullPath:(SubCommandType)subMethod {

    NSURL *url = [OTUrlRequestMap generateUrl:CommandTypeGet subMethod:subMethod forResource:self];
    return url.absoluteString;
}

- (NSString * _Nullable)getPath {
    
    NSURL *url = [OTUrlRequestMap generateUrl:CommandTypeGet subMethod:SubCommandTypeNone forResource:self];
    NSString *urlString = url.absoluteString;
    
    OTApplicationEntity *ae = [self getApplicationEntity];
    OTCommonServicesEntity *cse = ae.parent;
    NSString *baseUrl = [NSString stringWithFormat:@"%@/", cse.baseUrl];
    
    urlString = [urlString stringByReplacingOccurrencesOfString:baseUrl withString:@""];
    return urlString;
}

- (void)remoteRequest:(CommandType)method
            subMethod:(SubCommandType)subMethod
 withAdditonalQueries:(NSArray <NSURLQueryItem *> *)arrayQuery
              session:(OTSessionTask *)session
      completionBlock:(CompletionType)completionBlock {

    CompletionType completionBlockWrapper = ^(NSDictionary *response, NSError *error) {
        if (response[kKeyRqiResponse]) {
            NSArray *components = [response[kKeyRqiResponse] componentsSeparatedByString:@":"];
            if (components.count >= 1) {
                self.requestIdentifier = components[0];
            }
        }
        
        if (response[HEADER_RESPONSE_STATUS_CODE]) {
            StatusCode statusCode = [response[HEADER_RESPONSE_STATUS_CODE] integerValue];
            self.lastResponseStatusCode = statusCode;
        } else {
            self.lastResponseStatusCode = error.code;
        }
        
        NSDictionary *dict = nil;
        if ([self isKindOfClass:[OTApplicationEntity class]]) {
            dict = response[kKey_Response_Ae];
        } else if ([self isKindOfClass:[OTContainer class]]) {
            dict = response[kKey_Response_Cnt];
        } else if ([self isKindOfClass:[OTContentInstance class]]) {
            dict = response[kKey_Response_Cin];
        } else if ([self isKindOfClass:[OTGroup class]]) {
            dict = response[kKey_Response_Grp];
        } else if ([self isKindOfClass:[OTAccessControlPolicy class]]) {
            dict = response[kKey_Response_Acp];
        }
        if (error == nil && dict != nil) {
            [self updateCommonResources:dict];
            self.commsStatus = CommunicationsProgressDone;
        } else {
            self.commsStatus = CommunicationsProgressFail;
        }
        
        completionBlock(response, error);
    };

    self.commsStatus = CommunicationsProgressWorking;
    NSURLRequest *request = [OTUrlRequestMap prepareRequest:method subMethod:subMethod auth:session.auth origin:session.origin forResource:self withAdditonalQueries:arrayQuery];
    if (session) {
        [session executeRequest:request completion:completionBlockWrapper];
    } else {
        NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:@"Programmer Error - No Session Defined", @"NSLocalizedDescription",
                                  request.URL.absoluteString, @"NSErrorFailingURLStringKey",
                                  nil];
        NSError *error = [NSError errorWithDomain:request.URL.absoluteString code:0 userInfo:userInfo];
        completionBlockWrapper(nil, error);
    }
}

- (void)remoteRequest:(CommandType)method
            subMethod:(SubCommandType)subMethod
              session:(OTSessionTask *)session
      completionBlock:(CompletionType)completionBlock {
    
    [self remoteRequest:method subMethod:subMethod withAdditonalQueries:nil session:session completionBlock:completionBlock];
}

- (void)refreshContents:(OTSessionTask *)session completionBlock:(CompletionType)completionBlock { }

- (void)retrieveAndCreateFromList:(OTSessionTask *)session completionBlock:(CompletionType)completionBlock { }

- (void)addResourceLabel:(NSString *)label {
    
    BOOL found = false;
    for (NSString *string in _resourceLabels) {
        if ([string isEqualToString:label]) {
            found =  true;
            break;
        }
    }
    if (!found) {
        [_resourceLabels addObject:[label copy]];
    }
}

- (void)removeResourceLabel:(NSString *)label {
    
    for (NSString *string in _resourceLabels) {
        if ([string isEqualToString:label]) {
            [_resourceLabels removeObject:string];
            break;
        }
    }
}

- (void)addAccessControlPolicyId:(NSString *)policyId {
    
    BOOL found = false;
    for (NSString *string in _accessControlPolicyIds) {
        if ([string isEqualToString:policyId]) {
            found =  true;
            break;
        }
    }
    if (!found) {
        [_accessControlPolicyIds addObject:[policyId copy]];
    }
}

- (void)removeAccessControlPolicyId:(NSString *)policyId {
    
    for (NSString *string in _accessControlPolicyIds) {
        if ([string isEqualToString:policyId]) {
            [_accessControlPolicyIds removeObject:string];
            break;
        }
    }
}

#pragma mark - Dates
- (NSDate *)dateFromString:(NSString *)string {
    
    return [[self dateFormatter] dateFromString:string];
}

static NSDateFormatter *formatter = nil;
- (NSDateFormatter *)dateFormatter {
    
    if (!formatter)
    {
        formatter = [NSDateFormatter new];
        [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
        [formatter setDateFormat:@"yyyyMMdd'T'HHmmss"];
    }
    return formatter;
}

@end

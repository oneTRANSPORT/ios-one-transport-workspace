//
//  OTUrlRequestMap.m
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

#import "OTUrlRequestMap.h"

#import "OTObjectBase+Private.h"
#import "OTCommonServicesEntity.h"
#import "OTApplicationEntity.h"
#import "OTContainer.h"
#import "OTContentInstance.h"
#import "OTGroup.h"
#import "OTAccessControlPolicy.h"

@implementation OTUrlRequestMap

+ (NSString *)getUserAgent {
    return @"OneM2M-iOS";
}

+ (NSString *)getContentType {
    return @"application/json";
}

+ (NSURLRequest *)prepareRequest:(CommandType)method
                       subMethod:(SubCommandType)subMethod
                            auth:(NSString *)auth
                          origin:(NSString *)origin
                     forResource:(id)resource
                         withURL:(NSURL *)url {

    NSURLRequest *request = [OTUrlRequestMap prepareRequest:method subMethod:subMethod auth:auth origin:origin forResource:resource];
    NSMutableURLRequest *mutableRequest = [request copy];
    [mutableRequest setURL:url];
    
    return mutableRequest;
}

+ (NSURLRequest *)prepareRequest:(CommandType)method
                       subMethod:(SubCommandType)subMethod
                            auth:(NSString *)auth
                          origin:(NSString *)origin
                     forResource:(id)resource
            withAdditonalQueries:(NSArray *)arrayQuery {

    NSURLRequest *request = [OTUrlRequestMap prepareRequest:method subMethod:subMethod auth:auth origin:origin forResource:resource];
    NSMutableURLRequest *mutableRequest = [request copy];
    
    if (arrayQuery.count > 0 && request.URL != nil) {
        NSURLComponents *components = [[NSURLComponents alloc] initWithURL:request.URL resolvingAgainstBaseURL:false];
        [components setQueryItems:arrayQuery];
        [mutableRequest setURL:components.URL];
    }
    
    return mutableRequest;
}

+ (NSURLRequest *)prepareRequest:(CommandType)method
                       subMethod:(SubCommandType)subMethod
                            auth:(NSString *)auth
                          origin:(NSString *)origin
                     forResource:(id)resource {

    NSMutableURLRequest *request = [NSMutableURLRequest new];
    [request setHTTPMethod:[OTUrlRequestMap generateHttpMethod:method]];
    [request setURL:[OTUrlRequestMap generateUrl:method subMethod:subMethod forResource:resource]];
    [request setAllHTTPHeaderFields:[OTUrlRequestMap generateHeaders:method auth:auth origin:origin forResource:resource]];

    NSData *payload = [OTUrlRequestMap generatePayload:method forResource:resource];
    if (payload) {
        [request setHTTPBody:payload];
    }
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:kKeyUserDefaults_Trace]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kKeyNotification_Trace object:request.HTTPMethod];
        [[NSNotificationCenter defaultCenter] postNotificationName:kKeyNotification_Trace object:request.URL.absoluteString];
        [[NSNotificationCenter defaultCenter] postNotificationName:kKeyNotification_Trace object:request.allHTTPHeaderFields];

        DLog(@"%@", request.HTTPMethod);
        DLog(@"\"%@\"", request.URL);
        DLog(@"%@", request.allHTTPHeaderFields);
    }

    return request;
}

#pragma mark -

+ (NSString *)generateHttpMethod:(CommandType)method {
    
    NSString *httpMethod;
    switch (method) {
        case CommandTypeCreate:
            httpMethod = @"POST";
            break;
        case CommandTypeDiscover:
        case CommandTypeDiscoverViaRcn:
            httpMethod = @"GET";
            break;
        case CommandTypeGet:
            httpMethod = @"GET";
            break;
        case CommandTypeUpdate:
            httpMethod = @"PUT";
            break;
            
        case CommandTypeDelete:
            httpMethod = @"DELETE";
            break;
        
        default:
            httpMethod = @"GET";
            break;
    }
    
    return httpMethod;
}

+ (NSURL *)generateUrl:(CommandType)method
             subMethod:(SubCommandType)subMethod
           forResource:(id)resource {
    
    OTObjectBase *resourcePointer = resource;

    OTApplicationEntity *ae = [resource getApplicationEntity];
    OTCommonServicesEntity *cse = ae.parent;
    OTContainer *container = nil;
    OTContentInstance *content = nil;
    OTGroup *group = nil;
    OTAccessControlPolicy *acp = nil;
    
    if ([resource isKindOfClass:[OTContentInstance class]]) {
        content = resource;
        container = content.parent;
    } else if ([resource isKindOfClass:[OTContainer class]]) {
        container = resource;
    } else if ([resource isKindOfClass:[OTGroup class]]) {
        group = resource;
    } else if ([resource isKindOfClass:[OTAccessControlPolicy class]]) {
        acp = resource;
    }
    
    NSString *urlString = [NSString stringWithFormat:@"%@/%@", cse.baseUrl, cse.resourceName];

    if ((container == nil && method != CommandTypeCreate) || container != nil || group != nil || acp != nil) {
        urlString = [NSString stringWithFormat:@"%@/%@", urlString, ae.resourceName];
    }
    
    NSString *urlAppend = @"";
    if (container != nil || group != nil || acp != nil) {
        if (method != CommandTypeCreate) {
            urlAppend = resourcePointer.resourceName;
        }
        while ([resourcePointer.parent isKindOfClass:[OTContainer class]]) {
            resourcePointer = resourcePointer.parent;
            if (urlAppend.length > 0) {
                urlAppend = [NSString stringWithFormat:@"%@/%@", resourcePointer.resourceName, urlAppend];
            } else {
                urlAppend = resourcePointer.resourceName;
            }
        }
        if (urlAppend.length > 0) {
            urlString = [NSString stringWithFormat:@"%@/%@", urlString, urlAppend];
        }
    }
    
    urlAppend = @"";
    switch (subMethod) {
        case SubCommandTypeFanOut:
            urlAppend = @"fopt";
            break;
        case SubCommandTypeLatest:
            urlAppend = @"la";
            break;
        case SubCommandTypeOldest:
            urlAppend = @"ol";
            break;
        case SubCommandTypeFanOutLatest:
            urlAppend = @"fopt/la";
            break;
        case SubCommandTypeFanOutOldest:
            urlAppend = @"fopt/ol";
            break;
        default:
            break;
    }
    if (urlAppend.length > 0) {
        urlString = [NSString stringWithFormat:@"%@/%@", urlString, urlAppend];
    }

    NSURLComponents *components = [[NSURLComponents alloc] initWithString:urlString];
    NSMutableArray *arrayQuery = [NSMutableArray new];

    switch (method) {
        case CommandTypeDiscover:
        case CommandTypeDiscoverViaRcn:
        {
            ResourceType resourceType = RESOURCE_TYPE_NONE;
            if (container) {
                resourceType = RESOURCE_TYPE_CONTENT_INSTANCE;
            } else if (ae) {
                resourceType = RESOURCE_TYPE_CONTAINER;
            }
            
            if (resourceType != RESOURCE_TYPE_NONE) {
                if (method == CommandTypeDiscoverViaRcn) {
                    [arrayQuery addObject:[NSURLQueryItem queryItemWithName:FILTER_RCN value:@"6"]];
                } else {
                    [arrayQuery addObject:[NSURLQueryItem queryItemWithName:FILTER_CRITERIA_FILTER_USAGE value:@"1"]];
                    [arrayQuery addObject:[NSURLQueryItem queryItemWithName:FILTER_CRITERIA_RESOURCE_TYPE value:[NSString stringWithFormat:@"%zd", resourceType]]];
                }
            }

            break;
        }
        default:
            break;
    }
    if (arrayQuery.count > 0) {
        [components setQueryItems:arrayQuery];
    }
    
    return components.URL;
}

+ (NSDictionary *)generateHeaders:(CommandType)method
                             auth:(NSString *)auth
                           origin:(NSString *)origin
                      forResource:(id)resource {

    BOOL requiresNM = false;
    
    ResourceType resourceType = RESOURCE_TYPE_NONE;
    if (method == CommandTypeCreate) {
        if ([resource isKindOfClass:[OTContentInstance class]]) {
            resourceType = RESOURCE_TYPE_CONTENT_INSTANCE;
            requiresNM = true;
        } else if ([resource isKindOfClass:[OTContainer class]]) {
            resourceType = RESOURCE_TYPE_CONTAINER;
            requiresNM = true;
        } else if ([resource isKindOfClass:[OTGroup class]]) {
            resourceType = RESOURCE_TYPE_GROUP;
            requiresNM = true;
        } else if ([resource isKindOfClass:[OTAccessControlPolicy class]]) {
            resourceType = RESOURCE_TYPE_ACCESS_CONTROL_POLICY;
            requiresNM = true;
        } else {
            resourceType = RESOURCE_TYPE_APPLICATION_ENTITY;
        }
    }
    NSString *contentType = [OTUrlRequestMap getContentType];
    if (resourceType != RESOURCE_TYPE_NONE) {
        contentType = [NSString stringWithFormat:@"%@; ty=%zd", contentType, resourceType];
    }
    
    NSString *name   = [resource getApplicationEntity].resourceName;
    
    NSMutableDictionary *headers = [NSMutableDictionary new];
    [headers setValue:name                              forKey:HEADER_REQUEST_ID];
    [headers setValue:contentType                       forKey:@"Content-Type"];
    [headers setValue:origin                            forKey:HEADER_REQUEST_ORIGIN];
    [headers setValue:[NSString stringWithFormat:@"Bearer %@", auth] forKey:@"Authorization"];
    [headers setValue:[OTUrlRequestMap getContentType]  forKey:@"Accept"];
    [headers setValue:[OTUrlRequestMap getUserAgent]    forKey:@"User-Agent"];
    if (requiresNM) {
        [headers setValue:((OTObjectBase *)resource).resourceName forKey:HEADER_REQUEST_RESOURCENAME];
    }

    
//    if (authName) {
//        NSString *authString = [NSString stringWithFormat:@"%@:%@", authName, authPassword];
//        NSData *authData = [authString dataUsingEncoding:NSUTF8StringEncoding];
//        authString = [authData base64EncodedStringWithOptions:0];
//        [headers setValue:[NSString stringWithFormat:@"Basic %@", authString] forKey:@"Authorization"];
//    }
    
    return [NSDictionary dictionaryWithDictionary:headers];
}

+ (NSData *)generatePayload:(CommandType)method
                  forResource:(id)resource {

    if (method == CommandTypeCreate || method == CommandTypeUpdate) {
        NSMutableDictionary *dict = [NSMutableDictionary new];
        NSMutableDictionary *dictSub = [NSMutableDictionary new];

        OTObjectBase *objectBase = (OTObjectBase *)resource;

        if (method == CommandTypeCreate) {
            [dictSub setValue:objectBase.resourceName forKey:kKey_ResourceName];
        } else {
        }

        if ([resource isKindOfClass:[OTObjectAnnounceableResource class]]) {
            OTObjectAnnounceableResource *object = (OTObjectAnnounceableResource *)resource;
            [dictSub setValue:object.announceTo forKey:kKey_AnnounceTo];
            [dictSub setValue:object.announcedAttribute forKey:kKey_AnnouncedAttribute];
        }
        
        OTObjectBase *object = resource;
        [object setPayload:dictSub method:method];
        [dict setObject:dictSub forKey:[object payloadKey]];
         
        if ([[NSUserDefaults standardUserDefaults] boolForKey:kKeyUserDefaults_Trace]) {
            [[NSNotificationCenter defaultCenter] postNotificationName:kKeyNotification_Trace object:@"Payload"];
            [[NSNotificationCenter defaultCenter] postNotificationName:kKeyNotification_Trace object:dict];
            DLog(@"%@", dict);
        }
        return [NSJSONSerialization dataWithJSONObject:dict options:0 error:nil];
    }
    return nil;
}

@end

//
//  IDSessionTask.m
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

#import "OTSessionTask+Private.h"

@interface OTSessionTask()

@end

@implementation OTSessionTask

@synthesize urlSession = _urlSession;

- (NSURLSession *)urlSession {

    if (_urlSession == nil) {
        NSInteger timeout = [[NSUserDefaults standardUserDefaults] integerForKey:kKeyUserDefaults_TimeOut];
        if (timeout == 0) {
            timeout = kDefaultTimeout;
        }
        NSInteger connections = [[NSUserDefaults standardUserDefaults] integerForKey:kKeyUserDefaults_Connections];
        if (connections == 0) {
            connections = kDefaultConnections;
        }
        
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
        [config setTimeoutIntervalForRequest:timeout];
        [config setHTTPMaximumConnectionsPerHost:connections];
        [config setRequestCachePolicy:NSURLRequestReloadIgnoringCacheData];
        _urlSession = [NSURLSession sessionWithConfiguration:config];
    }
    return _urlSession;
}

- (void)setAuth:(NSString *)auth origin:(NSString *)origin {
    
    _auth = auth;
    _origin = origin;
}

- (void)setTimeOut:(NSInteger)timeout connections:(NSInteger)connections {

    if (timeout > 0) {
        [[NSUserDefaults standardUserDefaults] setInteger:timeout forKey:kKeyUserDefaults_TimeOut];
    }
    
    if (connections > kMaxConnections) {
        connections = kMaxConnections;
    }
    if (connections > 0) {
        [[NSUserDefaults standardUserDefaults] setInteger:connections forKey:kKeyUserDefaults_Connections];
    }
    
    _urlSession = nil;
}

- (void)cancelRequestQueue {
    
    [_urlSession getTasksWithCompletionHandler:^(NSArray *dataTasks, NSArray *uploadTasks, NSArray *downloadTasks) {
        for (NSURLSessionTask *task in dataTasks) {
            [task cancel];
        }
    }];
}

- (void)executeRequest:(NSURLRequest *)request
            completion:(CompletionType)completionBlock {
    
    __block NSThread *thread = [NSThread currentThread];

    CompletionType block = ^(NSDictionary *response, NSError *error) {
        dispatch_queue_t queue;
        if ([thread isMainThread]) {
            queue = dispatch_get_main_queue();
        } else {
            queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        }
        
        dispatch_async(queue, ^{
            completionBlock(response, error);
        });
    };
    
    NSURLSessionTask *task = [self.urlSession dataTaskWithRequest:request
                                                completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                                                    
                                                    [self processData:data response:response error:error completion:block];
                                                }];
    [task resume];
}

- (void)processData:(NSData *)data response:(NSURLResponse *)response error:(NSError *)error completion:(CompletionType)completionBlock {
    
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;

    NSDictionary *responseError = nil;
    NSDictionary *jsonDict = nil;
    if (error == nil) {
        if (httpResponse.statusCode == 404 ||  //not found
            httpResponse.statusCode == 406) { //not recognised
            NSInteger errorCode = httpResponse.statusCode;
            NSString *errorDesc =[NSString stringWithFormat:@"Failed HTTP response. Response header = %@", httpResponse.allHeaderFields];
            NSString *errorDomain = httpResponse.URL.absoluteString;
            
            NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:errorDesc, @"NSLocalizedDescription",
                                      response.URL.absoluteString, @"NSErrorFailingURLStringKey",
                                      nil];
            error = [NSError errorWithDomain:errorDomain code:errorCode userInfo:userInfo];
        } else {
            NSError *jsonError = nil;
            
            jsonDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
            if (jsonError) {
                NSString *responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                if (responseString) {
                    if ([response.URL.absoluteString containsString:@"rt=1"]) {   //response may not be JSON
                        jsonDict = [NSDictionary dictionaryWithObject:responseString forKey:kKeyRqiResponse];
                        jsonError = nil;
                    } else if ([responseString containsString:@"401 Authorization Required"]) {   //Auth token is invalid
                        jsonError = [NSError errorWithDomain:@"Authorisation Token Required" code:StatusCodeAuthError userInfo:nil];
                    } else {
                        responseError = [NSDictionary dictionaryWithObject:responseString forKey:kKeyErrorResponse];
                    }
                }
                error = jsonError;  //[NSError errorWithDomain:@"" code:ErrorCodesJson userInfo:nil];
            } else {
                NSDictionary *jsonDictError = jsonDict[@"m2m:rsp"];
                if (jsonDictError) {
                    NSInteger errorCode = [jsonDictError[@"rsc"] integerValue];
                    NSString *errorDesc = jsonDictError[@"pc"];
                    NSString *errorDomain = jsonDictError[@"rqi"];
                    
                    NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:errorDesc, @"NSLocalizedDescription",
                                              response.URL.absoluteString, @"NSErrorFailingURLStringKey",
                                              nil];
                    error = [NSError errorWithDomain:errorDomain code:errorCode userInfo:userInfo];
                }
            }
        }
    }
    
    //Notifications for debug modes
    NSNotificationCenter *notifCentre = nil;
    if ([[NSUserDefaults standardUserDefaults] boolForKey:kKeyUserDefaults_Trace]) {
        notifCentre = [NSNotificationCenter defaultCenter];
    }
    
    if (notifCentre) {
        [notifCentre postNotificationName:kKeyNotification_Trace object:@"Response"];
        
        NSString *responseCodeString = [NSString stringWithFormat:@"Response Code %zd", httpResponse.statusCode];
        [notifCentre postNotificationName:kKeyNotification_Trace object:responseCodeString];
        [notifCentre postNotificationName:kKeyNotification_Trace object:httpResponse.allHeaderFields];
        
        DLog(@"%@", responseCodeString);
        DLog(@"allHeaderFields\n%@", httpResponse.allHeaderFields);
    }
    
    if (jsonDict) {
        if (notifCentre) {
            [notifCentre postNotificationName:kKeyNotification_Trace object:jsonDict];
            DLog(@"Response - %@", jsonDict);
        }
    }
    if (responseError) {
        if (notifCentre) {
            [notifCentre postNotificationName:kKeyNotification_Trace object:responseError];
        }
        DLog(@"Response Error - %@", responseError);
    }
    
    //Now handle the data
    if (error == nil) {
        completionBlock(jsonDict, nil);
    } else {
        completionBlock(responseError, error);
        if (notifCentre) {
            [notifCentre postNotificationName:kKeyNotification_Trace object:@"Error"];
            [notifCentre postNotificationName:kKeyNotification_Trace object:error];
            DLog(@"Error - %@", error.description);
        }
    }
}

@end

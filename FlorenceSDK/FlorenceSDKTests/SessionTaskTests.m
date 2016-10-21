//
//  SessionTaskTests.m
//  FlorenceSDK
//
//  Created by Dominic Frazer Imregh on 08/07/2016.
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

#import "BaseTest.h"
#import "OTCommonServicesEntity.h"
#import "OTApplicationEntity.h"
#import "OTContainer.h"
#import "OTContentInstance.h"

#import "OTSessionTask+Private.h"
#import "OTUrlRequestMap.h"

@interface SessionTaskTests : BaseTest

@property (nonatomic, strong) OTSessionTask *sessionTask;
@property (nonatomic, strong) OTCommonServicesEntity *cse;
@property (nonatomic, strong) OTApplicationEntity *ae;

@property (nonatomic) NSInteger timeout;

@end

@implementation SessionTaskTests

- (void)setUp {
    _sessionTask = [OTSessionTask new];
    
    _cse = [[OTCommonServicesEntity alloc] initWithBaseUrl:k_CSE_BASEURL_DEV appId:k_APP_ID resourceId:k_CSE_ID resourceName:k_CSE_NAME];
    [_cse createAeWithId:k_AE_ID name:k_AE_NAME];
    
    _ae = [_cse aeWithId:k_AE_ID];
    
    _timeout = 3;
    [[NSUserDefaults standardUserDefaults] setInteger:_timeout forKey:kKeyUserDefaults_TimeOut];
}

- (void)tearDown {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kKeyUserDefaults_TimeOut];
}

- (void)testMainThread {

    XCTestExpectation *exp = [self expectationWithDescription:@"MainThread"];
    __block CommsStatus result = CommsStatusNotDefined;
    CompletionType block = ^(NSDictionary *response, NSError *error) {
    
        if (![NSThread isMainThread]) {
            result = CommsStatusWrongThread;
        } else {
            result = CommsStatusSuccess;
        }
        
        [exp fulfill];
    };
    
    dispatch_async(dispatch_get_main_queue(), ^{
        NSURLRequest *request = [OTUrlRequestMap prepareRequest:CommandTypeGet subMethod:SubCommandTypeNone auth:@"" origin:@"" forResource:self.ae];
        [self.sessionTask executeRequest:request completion:block];
    });
    
    [self waitForExpectationsWithTimeout:_timeout+1 handler:^(NSError * _Nullable error) {
        XCTAssertFalse(result == CommsStatusWrongThread, @"Wrong thread");
    }];
}

- (void)testBackgroundThread {
    
    XCTestExpectation *exp = [self expectationWithDescription:@"BackgroundThread"];
    __block CommsStatus result = CommsStatusNotDefined;
    CompletionType block = ^(NSDictionary *response, NSError *error) {
        
        if ([NSThread isMainThread]) {
            result = CommsStatusWrongThread;
        } else {
            result = CommsStatusSuccess;
        }
        
        [exp fulfill];
    };
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSURLRequest *request = [OTUrlRequestMap prepareRequest:CommandTypeGet subMethod:SubCommandTypeNone auth:@"" origin:@"" forResource:self.ae];
        [self.sessionTask executeRequest:request completion:block];
    });
    
    [self waitForExpectationsWithTimeout:_timeout+1 handler:^(NSError * _Nullable error) {
        XCTAssertFalse(result == CommsStatusWrongThread, @"Wrong thread");
    }];
}

- (void)testBothThreads {
    
    XCTestExpectation *exp = [self expectationWithDescription:@"BackgroundThread"];
    __block CommsStatus result1 = CommsStatusNotDefined;
    __block CommsStatus result2 = CommsStatusNotDefined;

    CompletionType block1 = ^(NSDictionary *response, NSError *error) {
        
        if ([NSThread isMainThread]) {
            result1 = CommsStatusWrongThread;
        } else {
            result1 = CommsStatusSuccess;
        }
        
        if (result2 != CommsStatusNotDefined) {
            [exp fulfill];
        }
    };
    
    CompletionType block2 = ^(NSDictionary *response, NSError *error) {
        
        if (![NSThread isMainThread]) {
            result2 = CommsStatusWrongThread;
        } else {
            result2 = CommsStatusSuccess;
        }
        
        if (result1 != CommsStatusNotDefined) {
            [exp fulfill];
        }
    };

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSURLRequest *request = [OTUrlRequestMap prepareRequest:CommandTypeGet subMethod:SubCommandTypeNone auth:@"" origin:@"" forResource:self.ae];
        [self.sessionTask executeRequest:request completion:block1];
    });
    dispatch_async(dispatch_get_main_queue(), ^{
        NSURLRequest *request = [OTUrlRequestMap prepareRequest:CommandTypeGet subMethod:SubCommandTypeNone auth:@"" origin:@"" forResource:self.ae];
        [self.sessionTask executeRequest:request completion:block2];
    });

    [self waitForExpectationsWithTimeout:_timeout+1 handler:^(NSError * _Nullable error) {
        XCTAssertFalse(result1 == CommsStatusWrongThread, @"Wrong thread");
        XCTAssertFalse(result1 == CommsStatusNotDefined, @"Failed to finish");
        XCTAssertFalse(result2 == CommsStatusWrongThread, @"Wrong thread");
        XCTAssertFalse(result2 == CommsStatusNotDefined, @"Failed to finish");
    }];
}

- (void)testCancel {
    
    CompletionType block = ^(NSDictionary *response, NSError *error) { };
    
    NSURLRequest *request = [OTUrlRequestMap prepareRequest:CommandTypeGet subMethod:SubCommandTypeNone auth:@"" origin:@"" forResource:self.ae];
    [self.sessionTask executeRequest:request completion:block];
    [self.sessionTask executeRequest:request completion:block];
    [self.sessionTask cancelRequestQueue];
    
    [self.sessionTask.urlSession getTasksWithCompletionHandler:^(NSArray *dataTasks, NSArray *uploadTasks, NSArray *downloadTasks) {
        NSInteger count = 0;
        for (NSURLSessionTask *task in dataTasks) {
            if (task.state == NSURLSessionTaskStateCanceling) {
                count++;
            }
        }
        XCTAssertTrue(dataTasks.count == count, @"Should be no active tasks");
    }];
}

- (void)testContentInstanceRefresh {

    OTContainer *container = [self.ae createContainerWithName:k_CNT_NAME];
    __block OTContentInstance *content = [container createContentInstanceWithName:k_CIN_NAME];
    __block NSInteger pingCount = 0;

    XCTestExpectation *exp = [self expectationWithDescription:@"Ping"];

    CompletionType completionBlock = ^(NSDictionary *response, NSError *error) {
        pingCount++;
        if (pingCount == 3) {
            [content cancelRefresh];
            [exp fulfill];
        }
    };
    
    [content refreshContents:self.sessionTask interval:1 completionBlock:completionBlock];

    [self waitForExpectationsWithTimeout:_timeout*4+1 handler:^(NSError * _Nullable error) {
        XCTAssertTrue(pingCount == 3, @"Not refreshing with time interval");
    }];
}

- (void)testResponseNotJSON {
 
    NSString *contents = @"This is not JSON";
    NSData *data = [contents dataUsingEncoding:NSUTF8StringEncoding];

    NSHTTPURLResponse *response = [[NSHTTPURLResponse alloc] initWithURL:[NSURL URLWithString:@"www.mydomain.com"] statusCode:200 HTTPVersion:nil headerFields:nil];
    NSError *error = nil;

    CompletionType block = ^(NSDictionary *response, NSError *error) {
        XCTAssertNotNil(response[@"Response"]);
        XCTAssertEqual(error.code, 3840);
    };

    [self.sessionTask processData:data response:response error:error completion:block];
}

- (void)testResponse {
    
    NSString *contents = [self getCinResponse];
    NSData *data = [contents dataUsingEncoding:NSUTF8StringEncoding];
    
    NSHTTPURLResponse *response = [[NSHTTPURLResponse alloc] initWithURL:[NSURL URLWithString:@"www.mydomain.com"] statusCode:200 HTTPVersion:nil headerFields:nil];
    NSError *error = nil;
    
    CompletionType block = ^(NSDictionary *response, NSError *error) {
        XCTAssertNil(response[@"Response"]);
        XCTAssertNotNil(response[kKey_Response_Cin]);
        XCTAssertEqual(error.code, 0);
    };
    
    [self.sessionTask processData:data response:response error:error completion:block];
}

- (void)testResponseFail {
    
    NSString *contents = [self getFailResponse];
    NSData *data = [contents dataUsingEncoding:NSUTF8StringEncoding];
    
    NSHTTPURLResponse *response = [[NSHTTPURLResponse alloc] initWithURL:[NSURL URLWithString:@"www.mydomain.com"] statusCode:200 HTTPVersion:nil headerFields:nil];
    NSError *error = nil;
    
    CompletionType block = ^(NSDictionary *response, NSError *error) {
        XCTAssertNil(response[@"Response"]);
        XCTAssertTrue([error.localizedDescription isEqualToString:@"Validation of request parameters failed:invalid query string."]);
        XCTAssertTrue([error.domain isEqualToString:@"C-IOS/dominic123_15212"]);
        XCTAssertEqual(error.code, 4000);
    };
    
    [self.sessionTask processData:data response:response error:error completion:block];
}

- (NSString *)getCinResponse {
    return @"{\"m2m:cin\":{\"cnf\":\"text/plain:0\",\"con\":40,\"cs\":2,\"ct\":\"20160718T120925\",\"et\":\"99991231T235959\",\"lt\":\"20160718T120925\",\"pi\":\"cnt_20160718T071513_65468\",\"ri\":\"cin_20160718T120925_82893\",\"rn\":\"ContentName\",\"st\":1,\"ty\":4}}";
}

- (NSString *)getFailResponse {
    return @"{\"m2m:rsp\":{\"pc\":\"Validation of request parameters failed:invalid query string.\",\"rqi\":\"C-IOS/dominic123_15212\",\"rsc\":4000}}";
}

@end

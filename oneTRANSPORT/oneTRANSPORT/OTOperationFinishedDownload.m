//
//  OTOperationFinishedDownload.m
//  oneTRANSPORT
//
//  Created by Dominic Frazer Imregh on 07/10/2016.
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
#import "OTOperationFinishedDownload.h"
#import "OTSingleton+Private.h"
#import "OTCoreDataCommon.h"
#import "OTCoreDataClearViewTraffic.h"
#import "NSObject+Collection.h"

@interface OTOperationFinishedDownload()

@property (nonatomic, strong) OTContainer *container;
@property (nonatomic, strong) OTCoreDataBase *object;
@property (nonatomic, copy) NSString *reference;
@property (nonatomic, copy) NSDictionary *response;
@property (nonatomic, strong) NSError *error;
@property (nonatomic, strong) CompletionType completion;

@end

@implementation OTOperationFinishedDownload

- (void)main {
    
    if (self.cancelled) {
        [[OTSingleton sharedInstance] decrementRequestCount:self.error completion:self.completion];
        return;
    }
    
    NSArray *array = [self processResponse:self.response error:self.error];
    if (array) {
        [self.container updateCommonResources:self.response[@"m2m:cin"]];
        
        NSArray *arrayCommon;
        if (self.reference) {
            arrayCommon = [(OTCoreDataClearViewTraffic *)self.object populateTableWithReference:self.reference data:array timestamp:self.container.resourceLastUpdated];
        } else {
            arrayCommon = [self.object populateTableWith:array timestamp:self.container.resourceLastUpdated];
        }
        [[OTSingleton sharedInstance].common populateTableWith:arrayCommon type:self.object.dataType];
        [[OTSingleton sharedInstance].arrayChanges addObjectsFromArray:[self.object checkForChanges:arrayCommon]];
    }
    if (!self.reference) {
        [self.object removeOld];
    }
    
    [[OTSingleton sharedInstance] decrementRequestCount:self.error completion:self.completion];
}

- (void)dealloc {
    
    self.container = nil;
    self.object = nil;
    self.reference = nil;
    self.response = nil;
    self.error = nil;
    self.completion = nil;
}

- (void)configure:(OTContainer *)container
           object:(OTCoreDataBase *)object
        reference:(NSString *)reference
         response:(NSDictionary *)response
            error:(NSError *)error
       completion:(CompletionType)completion {
    
    self.container = container;
    self.object = object;
    self.reference = reference;
    self.response = response;
    self.error = error;
    self.completion = completion;
}

- (NSArray *)processResponse:(NSDictionary *)response error:(NSError *)error {
    
    if (error == nil) {
        NSDictionary *dictCin = [NSObject validateDictionary:response[@"m2m:cin"]];
        NSString *contentsJson = [NSObject validateString:dictCin[@"con"]];
        if (contentsJson.length > 0) {
            NSArray *array = [NSJSONSerialization JSONObjectWithData:[contentsJson dataUsingEncoding:NSUTF8StringEncoding] options:0 error:NULL];
            if (array.count > 0) {
                return array;
            }
        }
    }
    return nil;
}

@end

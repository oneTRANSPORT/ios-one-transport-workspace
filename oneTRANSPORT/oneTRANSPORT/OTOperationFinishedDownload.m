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

@implementation OTOperationFinishedDownload

- (void)configure:(OTContainer *)container
           object:(OTCoreDataBase *)object
        reference:(NSString *)reference
         response:(NSDictionary *)response
            error:(NSError *)error
       completion:(CompletionType)completion {

    NSArray *array = [self processResponse:response error:error];
    if (array) {
        [container updateCommonResources:response[@"m2m:cin"]];
        
        NSArray *arrayCommon;
        if (reference) {
            arrayCommon = [(OTCoreDataClearViewTraffic *)object populateTableWithReference:reference data:array timestamp:container.resourceLastUpdated];
        } else {
            arrayCommon = [object populateTableWith:array timestamp:container.resourceLastUpdated];
        }
        [[OTSingleton sharedInstance].common populateTableWith:arrayCommon type:object.dataType];
        [[OTSingleton sharedInstance].arrayChanges addObjectsFromArray:[object checkForChanges:arrayCommon]];
    }
    
    [[OTSingleton sharedInstance] decrementRequestCount:error completion:completion];
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

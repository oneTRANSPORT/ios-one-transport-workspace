//
//  OneTransportBaseTests.m
//  oneTRANSPORT
//
//  Created by Dominic Frazer Imregh on 02/09/2016.
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
#import "OneTransportBaseTests.h"

@implementation OneTransportBaseTests

- (void)setUp {
    [super setUp];

    _singleton = [OTSingleton sharedInstance];
    [_singleton deleteCse];
    [_singleton configureOneTransport:@"APPID" auth:@"AUTHNAME" origin:@"AUTHPASS"];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.singleton.coreData managedObjectContext]; //initialise the MainThread MOC
    });
}

- (void)tearDown {

    [_singleton.common removeAll];
    [_singleton.variableMS removeAll];
    [_singleton.trafficFlow removeAll];
    [_singleton.trafficQueue removeAll];
    [_singleton.trafficScoot removeAll];
    [_singleton.trafficSpeed removeAll];
    [_singleton.trafficTime removeAll];
    [_singleton.carParks removeAll];
    [_singleton.roadworks removeAll];
    [_singleton.events removeAll];
    [_singleton.bitCarrierNode removeAll];
    [_singleton.bitCarrierSketch removeAll];
    [_singleton.bitCarrierVector removeAll];
    [_singleton.bitCarrierConfigVector removeAll];
    [_singleton.bitCarrierTravel removeAll];

    [super tearDown];
}

- (NSString *)prepareStringData:(NSString *)filename {
    
    NSString * path = [[NSBundle mainBundle] pathForResource:filename ofType: nil];
    NSString *stringData = [[NSString alloc] initWithContentsOfFile:path encoding:kCFStringEncodingUTF8 error:nil];
    return stringData;
}

@end

//
//  OneTransportSingletonTests.m
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
#import "OTSingleton.h"

@interface OTSingleton()

- (void)purgeOrphanedCommon;

@end

@interface OneTransportSingletonTests : OneTransportBaseTests

@end

@implementation OneTransportSingletonTests

- (void)testOrphanedCommon {

    [self.singleton.common removeAll];
    [self.singleton.variableMS removeAll];
    [self.singleton.trafficFlow removeAll];
    [self.singleton.carParks removeAll];
    [self.singleton.roadworks removeAll];
    
    NSManagedObjectContext *moc = [self.singleton.coreData managedObjectContext];
    
    Common *commonVms = [NSEntityDescription insertNewObjectForEntityForName:kCoreDataEntityCommon inManagedObjectContext:moc];
    commonVms.reference = @"1.1";
    commonVms.type = k_CommonType_VariableMS;
    
    VariableMessageSigns *vms = [NSEntityDescription insertNewObjectForEntityForName:kCoreDataEntityVariable inManagedObjectContext:moc];
    vms.reference = commonVms.reference;

    Common *commonVms2 = [NSEntityDescription insertNewObjectForEntityForName:kCoreDataEntityCommon inManagedObjectContext:moc];
    commonVms2.reference = @"1.2";
    commonVms2.type = k_CommonType_VariableMS;

    Common *commonTf = [NSEntityDescription insertNewObjectForEntityForName:kCoreDataEntityCommon inManagedObjectContext:moc];
    commonTf.reference = @"2.1";
    commonTf.type = k_CommonType_TrafficFlow;

    Common *commonTf2 = [NSEntityDescription insertNewObjectForEntityForName:kCoreDataEntityCommon inManagedObjectContext:moc];
    commonTf2.reference = @"2.2";
    commonTf2.type = k_CommonType_TrafficFlow;

    TrafficFlow *tf = [NSEntityDescription insertNewObjectForEntityForName:kCoreDataEntityTrafficFlow inManagedObjectContext:moc];
    tf.reference = commonTf.reference;
    
    Common *commonCp = [NSEntityDescription insertNewObjectForEntityForName:kCoreDataEntityCommon inManagedObjectContext:moc];
    commonCp.reference = @"3.1";
    commonCp.type = k_CommonType_CarParks;

    Common *commonCp2 = [NSEntityDescription insertNewObjectForEntityForName:kCoreDataEntityCommon inManagedObjectContext:moc];
    commonCp2.reference = @"3.2";
    commonCp2.type = k_CommonType_CarParks;

    CarParks *cp = [NSEntityDescription insertNewObjectForEntityForName:kCoreDataEntityCarParks inManagedObjectContext:moc];
    cp.reference = commonCp.reference;

    Common *commonRw = [NSEntityDescription insertNewObjectForEntityForName:kCoreDataEntityCommon inManagedObjectContext:moc];
    commonRw.reference = @"4.1";
    commonRw.type = k_CommonType_Roadworks;

    Common *commonRw2 = [NSEntityDescription insertNewObjectForEntityForName:kCoreDataEntityCommon inManagedObjectContext:moc];
    commonRw2.reference = @"4.2";
    commonRw2.type = k_CommonType_Roadworks;

    Roadworks *rw = [NSEntityDescription insertNewObjectForEntityForName:kCoreDataEntityRoadworks inManagedObjectContext:moc];
    rw.reference = commonRw.reference;

    [moc save:nil];

    NSArray *arrayCommon;
    arrayCommon = [self.singleton.common retrieveAll:nil];
    XCTAssertTrue(arrayCommon.count == 8);

    [OTSingleton.sharedInstance purgeOrphanedCommon];
    
    arrayCommon = [self.singleton.common retrieveAll:nil];
    XCTAssertTrue(arrayCommon.count == 4);
}

@end

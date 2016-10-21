//
//  OneTransportCseTests.m
//  oneTRANSPORT
//
//  Created by Dominic Frazer Imregh on 17/10/2016.
//  Copyright © 2016 InterDigital. All rights reserved.
//

#import "OneTransportBaseTests.h"

@interface OneTransportCseTests : OneTransportBaseTests

@end

@implementation OneTransportCseTests

- (void)setUp {
    [super setUp];

    NSString *APP_ID       = @"<Your App Name>";
    NSString *ACCCESS_KEY  = @"<Your Access Key>";
    NSString *ORIGIN       = @"<Your AEID>";
    
    [[NSUserDefaults standardUserDefaults] setBool:false forKey:kUserDefaultsDev];

    [self.singleton deleteCse];
    [self.singleton configureOneTransport:APP_ID auth:ACCCESS_KEY origin:ORIGIN];

    [self clearAllData];
}

- (void)tearDown {

    [self clearAllData];

    [super tearDown];
}

- (void)clearAllData {
    
    [self.singleton.variableMS removeAll];
    [self.singleton.trafficFlow removeAll];
    [self.singleton.trafficQueue removeAll];
    [self.singleton.trafficScoot removeAll];
    [self.singleton.trafficScoot removeAll];
    [self.singleton.trafficTime removeAll];
    [self.singleton.carParks removeAll];
    [self.singleton.roadworks removeAll];
    [self.singleton.events removeAll];
}

- (void)execute:(LocalAuthority)la cnt:(ContainerType)cnt count:(NSInteger)count {
    
    XCTestExpectation *exp = [self expectationWithDescription:@"Wait"];

    CompletionType completionBlock = ^(NSDictionary *response, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            XCTAssertNil(error);
            if (error == nil) {
                NSArray *array = [[self.singleton getCntObject:cnt] retrieveAll:false];
                XCTAssertTrue(array.count >= count);
            }
            
            [exp fulfill];
        });
    };
    
    [self.singleton requestData:la container:cnt completion:completionBlock];

    [self waitForExpectationsWithTimeout:60 handler:^(NSError * _Nullable error) {

    }];
}

- (void)testBirminghamVMS {
    [self execute:LocalAuthorityBirmingham cnt:ContainerTypeVariableMessageSigns count:1];
}

- (void)testBirminghamTFlow {
    [self execute:LocalAuthorityBirmingham cnt:ContainerTypeTrafficFlow count:1];
}

//- (void)testBirminghamTQueue {
//    [self execute:LocalAuthorityBirmingham cnt:ContainerTypeTrafficQueue count:0];
//}

- (void)testBirminghamTScoot {
    [self execute:LocalAuthorityBirmingham cnt:ContainerTypeTrafficScoot count:1];
}

- (void)testBirminghamTSpeed {
    [self execute:LocalAuthorityBirmingham cnt:ContainerTypeTrafficSpeed count:1];
}

- (void)testBirminghamTTime {
    [self execute:LocalAuthorityBirmingham cnt:ContainerTypeTrafficTime count:1];
}

- (void)testBirminghamCarParks {
    [self execute:LocalAuthorityBirmingham cnt:ContainerTypeCarParks count:1];
}

- (void)testBirminghamRoadworks {
    [self execute:LocalAuthorityBirmingham cnt:ContainerTypeRoadWorks count:1];
}

//- (void)testBirminghanEvents {
//    [self execute:LocalAuthorityBirmingham cnt:ContainerTypeEvents count:0];
//}

- (void)testBucksVMS {
    [self execute:LocalAuthorityBucks cnt:ContainerTypeVariableMessageSigns count:1];
}

- (void)testBucksTFlow {
    [self execute:LocalAuthorityBucks cnt:ContainerTypeTrafficFlow count:1];
}

- (void)testBucksTQueue {
    [self execute:LocalAuthorityBucks cnt:ContainerTypeTrafficQueue count:0];
}

- (void)testBucksTScoot {
    [self execute:LocalAuthorityBucks cnt:ContainerTypeTrafficScoot count:1];
}

- (void)testBucksTSpeed {
    [self execute:LocalAuthorityBucks cnt:ContainerTypeTrafficSpeed count:1];
}

- (void)testBucksTTime {
    [self execute:LocalAuthorityBucks cnt:ContainerTypeTrafficTime count:1];
}

- (void)testBucksCarParks {
    [self execute:LocalAuthorityBucks cnt:ContainerTypeCarParks count:1];
}

- (void)testBucksRoadworks {
    [self execute:LocalAuthorityBucks cnt:ContainerTypeRoadWorks count:1];
}

- (void)testBucksEvents {
    [self execute:LocalAuthorityBucks cnt:ContainerTypeEvents count:0];
}

- (void)testOxonVMS {
    [self execute:LocalAuthorityOxon cnt:ContainerTypeVariableMessageSigns count:1];
}

- (void)testOxonTFlow {
    [self execute:LocalAuthorityOxon cnt:ContainerTypeTrafficFlow count:1];
}

- (void)testOxonTQueue {
    [self execute:LocalAuthorityOxon cnt:ContainerTypeTrafficQueue count:0];
}

- (void)testOxonTScoot {
    [self execute:LocalAuthorityOxon cnt:ContainerTypeTrafficScoot count:1];
}

- (void)testOxonTSpeed {
    [self execute:LocalAuthorityOxon cnt:ContainerTypeTrafficSpeed count:1];
}

- (void)testOxonTTime {
    [self execute:LocalAuthorityOxon cnt:ContainerTypeTrafficTime count:1];
}

- (void)testOxonCarParks {
    [self execute:LocalAuthorityOxon cnt:ContainerTypeCarParks count:1];
}

- (void)testOxonRoadworks {
    [self execute:LocalAuthorityOxon cnt:ContainerTypeRoadWorks count:1];
}

- (void)testOxonEvents {
    [self execute:LocalAuthorityOxon cnt:ContainerTypeEvents count:0];
}

- (void)testNorthantsVMS {
    [self execute:LocalAuthorityHerts cnt:ContainerTypeVariableMessageSigns count:1];
}

- (void)testNorthantsTFlow {
    [self execute:LocalAuthorityNorthants cnt:ContainerTypeTrafficFlow count:1];
}

- (void)testNorthantsTQueue {
    [self execute:LocalAuthorityNorthants cnt:ContainerTypeTrafficQueue count:0];
}

- (void)testNorthantsTScoot {
    [self execute:LocalAuthorityNorthants cnt:ContainerTypeTrafficScoot count:1];
}

- (void)testNorthantsTSpeed {
    [self execute:LocalAuthorityNorthants cnt:ContainerTypeTrafficSpeed count:1];
}

- (void)testNorthantsTTime {
    [self execute:LocalAuthorityNorthants cnt:ContainerTypeTrafficTime count:1];
}

- (void)testNorthantsCarParks {
    [self execute:LocalAuthorityNorthants cnt:ContainerTypeCarParks count:1];
}

- (void)testNorthantsRoadworks {
    [self execute:LocalAuthorityNorthants cnt:ContainerTypeRoadWorks count:1];
}

- (void)testNorthantsEvents {
    [self execute:LocalAuthorityNorthants cnt:ContainerTypeEvents count:0];
}

- (void)testHertsVMS {
    [self execute:LocalAuthorityHerts cnt:ContainerTypeVariableMessageSigns count:1];
}

- (void)testHertsTFlow {
    [self execute:LocalAuthorityHerts cnt:ContainerTypeTrafficFlow count:1];
}

- (void)testHertsTQueue {
    [self execute:LocalAuthorityHerts cnt:ContainerTypeTrafficQueue count:0];
}

- (void)testHertsTScoot {
    [self execute:LocalAuthorityHerts cnt:ContainerTypeTrafficScoot count:1];
}

- (void)testHertsTSpeed {
    [self execute:LocalAuthorityHerts cnt:ContainerTypeTrafficSpeed count:1];
}

- (void)testHertsTTime {
    [self execute:LocalAuthorityHerts cnt:ContainerTypeTrafficTime count:1];
}

- (void)testHertsCarParks {
    [self execute:LocalAuthorityHerts cnt:ContainerTypeCarParks count:1];
}

- (void)testHertsRoadworks {
    [self execute:LocalAuthorityHerts cnt:ContainerTypeRoadWorks count:1];
}

- (void)testHertsEvents {
    [self execute:LocalAuthorityHerts cnt:ContainerTypeEvents count:0];
}

@end

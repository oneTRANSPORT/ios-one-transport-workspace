//
//  AcpTests.m
//  FlorenceSDK
//
//  Created by Dominic Frazer Imregh on 28/07/2016.
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
#import "OTAccessControlIpAddress.h"
#import "OTAccessControlContext.h"
#import "OTLocationRegion.h"
#import "OTAccessControlRule.h"
#import "OTSetOfAccessControlRules.h"
#import "OTAccessControlPolicy.h"
#import "OTObjectBase+Private.h"

@interface AcpTests : BaseTest

@end

@implementation AcpTests

- (void)testAcpCreate {
    
    OTAccessControlIpAddress *acpIp = [OTAccessControlIpAddress new];
    XCTAssertNotNil(acpIp.ipv4Address);
    XCTAssertNotNil(acpIp.ipv6Address);

    OTAccessControlContext *acCnt = [OTAccessControlContext new];
    XCTAssertNotNil(acCnt.accessControlWindows);
    XCTAssertNotNil(acCnt.accessControlIpAddresses);

    OTLocationRegion *lc = [OTLocationRegion new];
    XCTAssertNotNil(lc.countryCode);
    XCTAssertNotNil(lc.circularRegion);

    OTAccessControlRule *acr = [OTAccessControlRule new];
    XCTAssertNotNil(acr.accessControlOriginators);
    XCTAssertNotNil(acr.accessControlContexts);
    XCTAssertNotNil(acr.accessControlLocationRegions);
    
    OTSetOfAccessControlRules *set = [OTSetOfAccessControlRules new];
    XCTAssertNotNil(set.accessControlRules);

    OTAccessControlPolicy *acp = [[OTAccessControlPolicy alloc] initWithId:@"123" name:@"Name" parent:self];
    XCTAssertTrue(acp);
}

- (void)testAcpContextAddRemove {
    
    OTAccessControlIpAddress *acpIp = [OTAccessControlIpAddress new];
    acpIp.ipv4Address = @"10.10.10.10";
    
    OTAccessControlContext *acCnt = [OTAccessControlContext new];
    [acCnt addControlWindow:@"20160718T120925"];
    [acCnt addControlWindow:@"20160719T120925"];
    [acCnt addControlIpAddress:acpIp];

    XCTAssertTrue([acCnt.accessControlWindows[0] isEqualToString:@"20160718T120925"]);
    XCTAssertTrue([acCnt.accessControlWindows[1] isEqualToString:@"20160719T120925"]);
    
    OTAccessControlIpAddress *acpIpRead = acCnt.accessControlIpAddresses[0];
    XCTAssertTrue([acpIpRead.ipv4Address isEqualToString:@"10.10.10.10"]);
    
    [acCnt removeControlWindow:@"20160718T120925"];
    XCTAssertTrue([acCnt.accessControlWindows[0] isEqualToString:@"20160719T120925"]);
    
    [acCnt removeControlIpAddress:acCnt.accessControlIpAddresses[0]];
    XCTAssertTrue(acCnt.accessControlIpAddresses.count == 0);
}

- (void)testAcpRegionAddRemove {
    
    OTLocationRegion *lc = [OTLocationRegion new];
    [lc addCountryCode:@"UK"];
    [lc addCountryCode:@"US"];

    XCTAssertTrue([lc.countryCode[0] isEqualToString:@"UK"]);
    XCTAssertTrue([lc.countryCode[1] isEqualToString:@"US"]);

    [lc removeCountryCode:@"UK"];
    XCTAssertTrue([lc.countryCode[0] isEqualToString:@"US"]);
}

- (void)testOriginatorAddRemove {
    
    OTAccessControlRule *acr = [OTAccessControlRule new];
    [acr addControlOriginator:@"Originator1"];
    [acr addControlOriginator:@"Originator2"];

    OTAccessControlContext *acCnt1 = [OTAccessControlContext new];
    [acr addControlContext:acCnt1];
    OTAccessControlContext *acCnt2 = [OTAccessControlContext new];
    [acr addControlContext:acCnt2];
    
    OTLocationRegion *lc1 = [OTLocationRegion new];
    [acr addLocationRegion:lc1];
    OTLocationRegion *lc2 = [OTLocationRegion new];
    [acr addLocationRegion:lc2];

    XCTAssertTrue([acr.accessControlOriginators[0] isEqualToString:@"Originator1"]);
    XCTAssertTrue([acr.accessControlOriginators[1] isEqualToString:@"Originator2"]);

    XCTAssertTrue([acr.accessControlContexts[0] isEqual:acCnt1]);
    XCTAssertTrue([acr.accessControlContexts[1] isEqual:acCnt2]);

    XCTAssertTrue([acr.accessControlLocationRegions[0] isEqual:lc1]);
    XCTAssertTrue([acr.accessControlLocationRegions[1] isEqual:lc2]);

    [acr removeControlOriginator:@"Originator1"];
    [acr removeControlContext:acCnt1];
    [acr removeLocationRegion:lc1];
    
    XCTAssertTrue([acr.accessControlOriginators[0] isEqualToString:@"Originator2"]);
    XCTAssertTrue([acr.accessControlContexts[0] isEqual:acCnt2]);
    XCTAssertTrue([acr.accessControlLocationRegions[0] isEqual:lc2]);
}

- (void)testAcpPayload {
    
    OTAccessControlIpAddress *acpIp = [OTAccessControlIpAddress new];
    acpIp.ipv4Address = @"10.10.10.10";
    
    OTAccessControlContext *acCnt = [OTAccessControlContext new];
    [acCnt addControlWindow:@"20160718T120925"];
    [acCnt addControlWindow:@"20160719T120925"];
    [acCnt addControlIpAddress:acpIp];
    
    OTLocationRegion *lc = [OTLocationRegion new];
    [lc addCountryCode:@"UK"];
    lc.circularRegion.coordinate = CGPointMake(123.45f, 123.56f);
    lc.circularRegion.radius = 50.0f;
    
    OTAccessControlRule *acr = [OTAccessControlRule new];
    [acr addControlOriginator:@"Originator"];
    acr.accessControlOperations = AccessControlOperationALL;
    [acr addControlContext:acCnt];
    [acr addLocationRegion:lc];
    
    OTSetOfAccessControlRules *set = [OTSetOfAccessControlRules new];
    set.accessControlRules = [NSMutableArray arrayWithArray:@[acr]];
    
    OTAccessControlPolicy *acp = [[OTAccessControlPolicy alloc] initWithId:@"123" name:@"Name" parent:self];
    acp.privileges = set;

    NSMutableDictionary *dict = [NSMutableDictionary new];
    NSMutableDictionary *dictSub = [NSMutableDictionary new];
    [acp setPayload:dictSub method:CommandTypeCreate];
    [dict setObject:dictSub forKey:[acp payloadKey]];

    XCTAssertNotNil(dict[@"acp"]);
    XCTAssertNotNil(dict[@"acp"][@"pv"]);
    
    NSDictionary *dictPv = dict[@"acp"][@"pv"];
    XCTAssertNotNil(dictPv);

    NSArray *arrayPvAcr = dictPv[@"acr"];
    NSDictionary *dictAcr = arrayPvAcr[0];

    NSArray *arrayAcco = dictAcr[@"acco"];
    NSArray *arrayAclr = dictAcr[@"aclr"];
    NSArray *arrayActw = dictAcr[@"acor"];
    AccessControlOperation valAcop = (AccessControlOperation)[dictAcr[@"acop"] integerValue];
    
    XCTAssertNotNil(arrayAcco);
    XCTAssertNotNil(arrayAclr);
    XCTAssertNotNil(arrayActw);
    XCTAssertTrue(valAcop == AccessControlOperationALL);
    
    NSDictionary *dictContext = arrayAcco[0];
    XCTAssertNotNil(dictContext);

    NSArray *arrayIp = dictContext[@"acip"];
    XCTAssertNotNil(arrayIp);
    NSDictionary *dictIp = arrayIp[0];
    NSString *stringIp = dictIp[@"ipv4"];
    XCTAssertTrue([stringIp isEqualToString:@"10.10.10.10"]);

    NSArray *arrayWin = dictContext[@"actw"];
    XCTAssertNotNil(arrayWin);
    NSString *stringWin = arrayWin[0];
    XCTAssertTrue([stringWin isEqualToString:@"20160718T120925"]);
    
    NSDictionary *dictRegion = arrayAclr[0];
    XCTAssertNotNil(dictRegion);
}

- (NSString *)getJson {
    return @"{\"acp\":{\"pv\":   {\"acr\":[{\"acop\":63,\"acor\":[\"//cse-04.onetransport.uk.net/ONETCSE04/C-RETROFIT-TEST-APP\"]}  ]}   ,\"pvs\": {\"acr\": [{\"acop\":63,\"aclr\":[{\"accc\":[\"UK\"],\"accr\":[123.45, 123.48, 40]}],\"acco\":[{\"actw\":[\"Window1\",\"Window2\"],\"acip\":[{\"ipv4\":\"10.10.10.10\"}]}],\"acor\":[\"//cse-04.onetransport.uk.net/ONETCSE04/C-RETROFIT-TEST-APP\"]} ]},\"rn\":\"accesscontrolpolicyzero\"}}";
}

- (NSDictionary *)getJsonDict {
    NSString *json = [self getJson];
    
    NSData *data = [json dataUsingEncoding:NSUTF8StringEncoding];
    return [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
}

- (void)testJsonPayload_1 {

    NSDictionary *dict = [self getJsonDict];

    OTAccessControlPolicy *acp = [[OTAccessControlPolicy alloc] initWithId:@"123" name:@"Name" parent:self];
    [acp updateCommonResources:dict[[acp payloadKey]]];
    
    XCTAssertTrue([acp.resourceName isEqualToString:@"accesscontrolpolicyzero"]);
    XCTAssertNotNil(acp.privileges);
    XCTAssertNotNil(acp.selfPrivileges);

    XCTAssertNotNil(acp.privileges.accessControlRules);
    XCTAssertNotNil(acp.selfPrivileges.accessControlRules);

    OTAccessControlRule *acrPv = acp.privileges.accessControlRules[0];
    XCTAssertNotNil(acrPv.accessControlOriginators);
    XCTAssertNotNil(acrPv.accessControlContexts);
    XCTAssertNotNil(acrPv.accessControlLocationRegions);
    
    OTAccessControlRule *acrPvs = acp.privileges.accessControlRules[0];
    XCTAssertNotNil(acrPvs.accessControlOriginators);
    XCTAssertNotNil(acrPvs.accessControlContexts);
    XCTAssertNotNil(acrPvs.accessControlLocationRegions);
}

- (void)testJsonPayload_2 {
    
    NSDictionary *dict = [self getJsonDict];
    
    OTAccessControlPolicy *acp = [[OTAccessControlPolicy alloc] initWithId:@"123" name:@"Name" parent:self];
    [acp updateCommonResources:dict[[acp payloadKey]]];
    
    XCTAssertNotNil(acp.privileges);
    XCTAssertNotNil(acp.selfPrivileges);
    
    XCTAssertNotNil(acp.privileges.accessControlRules);
    XCTAssertNotNil(acp.selfPrivileges.accessControlRules);
    
    OTAccessControlRule *acrPv = acp.privileges.accessControlRules[0];
    XCTAssertNotNil(acrPv.accessControlOriginators);
    XCTAssertNotNil(acrPv.accessControlContexts);
    XCTAssertNotNil(acrPv.accessControlLocationRegions);
    
    OTAccessControlRule *acrPvs = acp.selfPrivileges.accessControlRules[0];
    XCTAssertNotNil(acrPvs.accessControlOriginators);
    XCTAssertNotNil(acrPvs.accessControlContexts);
    XCTAssertNotNil(acrPvs.accessControlLocationRegions);
    
    OTLocationRegion *acrPvsReg = acrPvs.accessControlLocationRegions[0];
    XCTAssertTrue([acrPvsReg.countryCode[0] isEqualToString:@"UK"]);
    XCTAssertTrue(floorf(acrPvsReg.circularRegion.coordinate.x) == 123);
    XCTAssertTrue(floorf(acrPvsReg.circularRegion.coordinate.y) == 123);
    XCTAssertTrue(acrPvsReg.circularRegion.radius == 40);

    OTAccessControlContext *acrPvsContext = acrPvs.accessControlContexts[0];
    XCTAssertNotNil(acrPvsContext.accessControlWindows);
    XCTAssertNotNil(acrPvsContext.accessControlIpAddresses);
    
    OTAccessControlIpAddress *acrPvsIp = acrPvsContext.accessControlIpAddresses[0];
    XCTAssertTrue([acrPvsIp.ipv4Address isEqualToString:@"10.10.10.10"]);
}

- (void)testJsonInAndOut {
    
    NSDictionary *dictIn = [self getJsonDict];
    OTAccessControlPolicy *acp = [[OTAccessControlPolicy alloc] initWithId:@"123" name:@"Name" parent:self];
    [acp updateCommonResources:dictIn[[acp payloadKey]]];
    
    NSMutableDictionary *dictOut = [NSMutableDictionary new];
    NSMutableDictionary *dictSub = [NSMutableDictionary new];
    [acp setPayload:dictSub method:CommandTypeCreate];
    [dictOut setObject:dictSub forKey:[acp payloadKey]];

    NSData *dataOut = [NSJSONSerialization dataWithJSONObject:dictOut options:0 error:nil];
    NSString *stringOut = [[NSString alloc] initWithData:dataOut encoding:NSUTF8StringEncoding];

    XCTAssertNotNil(stringOut);
    XCTAssertTrue([stringOut containsString:@"\"rn\":\"accesscontrolpolicyzero\""]);
}

@end

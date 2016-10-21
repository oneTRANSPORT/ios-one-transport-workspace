//
//  OTTransportTypes.h
//  oneTRANSPORT
//
//  Created by Dominic Frazer Imregh on 17/08/2016.
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

#ifndef OTTransportTypes_h
#define OTTransportTypes_h

#define k_CSE_BASEURL_DEV    @"https://staging.onetransport.uk.net"
#define k_CSE_BASEURL_LIVE   @"https://cse-01.onetransport.uk.net"
#define k_CSE_ID             @"ONE-CSE-01"
#define k_CSE_NAME           @"ONETCSE01"

// API Requests

typedef NS_ENUM(NSInteger, ObjectType) {
    ObjectTypeVariableMessageSigns = 1,
    ObjectTypeTrafficFlow,
    ObjectTypeTrafficQueue,
    ObjectTypeTrafficSpeed,
    ObjectTypeTrafficScoot,
    ObjectTypeTrafficTime,
    ObjectTypeCarParks,
    ObjectTypeRoadworks,
    ObjectTypeEvents,
    ObjectTypeBitCarrier,
    ObjectTypeClearView,
};

typedef NS_ENUM(NSInteger, LocalAuthority) {
    LocalAuthorityBucks = 1,
    LocalAuthorityNorthants,
    LocalAuthorityOxon,
    LocalAuthorityHerts,
    LocalAuthorityBirmingham,
};

typedef NS_ENUM(NSInteger, ContainerType) {
    ContainerTypeVariableMessageSigns = 1,
    ContainerTypeTrafficFlow,
    ContainerTypeTrafficQueue,
    ContainerTypeTrafficSpeed,
    ContainerTypeTrafficScoot,
    ContainerTypeTrafficTime,
    ContainerTypeEvents,
    ContainerTypeCarParks,
    ContainerTypeRoadWorks,
    ContainerTypeBitCarrier,
    ContainerTypeClearView,
};

// Response Dictionary Objects

#define kResponseChangesAll        @"changes"
#define kResponseChangesFavourites @"changesFavourites"

// User Defaults - Latitude / Longitude filter

#define kUserDefaultsMinLat         @"oneT_UserDefaultsMinLat"
#define kUserDefaultsMinLon         @"oneT_UserDefaultsMinLon"
#define kUserDefaultsMaxLat         @"oneT_UserDefaultsMaxLat"
#define kUserDefaultsMaxLon         @"oneT_UserDefaultsMaxLon"

typedef NS_ENUM(NSInteger, EmptyLatLon) {
    EmptyLatLonMinLat       = 999,
    EmptyLatLonMinLon       = -999,
    EmptyLatLonMaxLat       = -999,
    EmptyLatLonMaxLon       = 999,
};

// User Defaults - Show developer log in the console

#define kUserDefaultsDev            @"oneT_UserDefaultsDev"

// User Defaults - Show kph/mph

#define kUserDefaultsKph            @"oneT_UserDefaultsKph"

// User Defaults - Age of data (in hours) before it should be discarded

#define kUserDefaultsDataAge        @"oneT_UserDefaultsDataAge"

// User Defaults - Filter options

#define kUserDefaultsLA_Bucks       @"oneT_UserDefaultsLA_Bucks"
#define kUserDefaultsLA_Northants   @"oneT_UserDefaultsLA_Northants"
#define kUserDefaultsLA_Oxon        @"oneT_UserDefaultsLA_Oxon"
#define kUserDefaultsLA_Herts       @"oneT_UserDefaultsLA_Herts"
#define kUserDefaultsLA_Birmingham  @"oneT_UserDefaultsLA_Birmingham"

// Common types stored in CoreData Common.type

#define k_CommonType_VariableMS                @"VMS"
#define k_CommonType_TrafficFlow               @"TFFl"
#define k_CommonType_TrafficQueue              @"TFTr"
#define k_CommonType_TrafficSpeed              @"TFSp"
#define k_CommonType_TrafficScoot              @"TFSc"
#define k_CommonType_TrafficTime               @"TFTi"
#define k_CommonType_CarParks                  @"CP"
#define k_CommonType_Roadworks                 @"RW"
#define k_CommonType_Events                    @"EV"
#define k_CommonType_BitCarrierNode            @"BCN"
#define k_CommonType_BitCarrierSketch          @"BCS"
#define k_CommonType_BitCarrierVector          @"BCV"
#define k_CommonType_BitCarrierConfigVector    @"BCCV"
#define k_CommonType_BitCarrierTravel          @"BCT"
#define k_CommonType_ClearViewDevice           @"CVD"
#define k_CommonType_ClearViewTraffic          @"CVT"

// Application Entities and Containers

#define k_AE_ID_Bucks        @"Buckinghamshire"
#define k_AE_ID_Northants    @"Northamptonshire"
#define k_AE_ID_Oxon         @"Oxfordshire"
#define k_AE_ID_Herts        @"Hertfordshire"
#define k_AE_ID_Birmingham   @"Birmingham"

#define k_CNT_VariableMS      @"v2.0/VariableMessageSign/All"
#define k_CNT_Traffic         @"v2.0/Traffic/All"
#define k_CNT_TrafficFlow     @"v2.0/Traffic/Flow/All"
#define k_CNT_TrafficQueue    @"v2.0/Traffic/Queue/All"
#define k_CNT_TrafficScoot    @"v2.0/Traffic/Scoot/All"
#define k_CNT_TrafficSpeed    @"v2.0/Traffic/Speed/All"
#define k_CNT_TrafficTime     @"v2.0/Traffic/TravelTime/All"
#define k_CNT_Event           @"v2.0/Event/All"
#define k_CNT_CarPark         @"v2.0/Carpark/All"
#define k_CNT_Roadworks       @"v2.0/RoadWorks/All"

#define k_AE_ID_BitCarrier   @"Worldsensing"
#define k_AE_ID_ClearView    @"ClearviewIntelligence_VBV"

// Common Dictionary keys

#define kCommonReference  @"reference"
#define kCommonTitle      @"title"
#define kCommonLat        @"lat"
#define kCommonLon        @"lon"
#define kCommonType       @"type"
#define kCommonTitleTo    @"to_title"
#define kCommonLatTo      @"to_lat"
#define kCommonLonTo      @"to_lon"
#define kCommonTypeTo     @"to_type"
#define kCommonTypeFrom   @"from_type"
#define kCommonTpegDir    @"tpegDirection"
#define kCommonTimestamp  @"timestamp"
#define kCommonCounter1   @"counter1"
#define kCommonCounter2   @"counter2"

// Used by ImportTSV methods

typedef void (^PopulateBlock)(BOOL success);

#endif /* OTTransportTypes_h */

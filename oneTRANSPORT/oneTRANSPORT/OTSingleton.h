//
//  OTSingleton.h
//  oneTRANSPORT
//
//  Created by Dominic Frazer Imregh on 15/08/2016.
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

#import <Foundation/Foundation.h>
#import <FlorenceSDK/FlorenceSDK.h>
#import <CoreLocation/CLLocation.h>

#import "OTTransportTypes.h"

#import "VariableMessageSigns.h"
#import "TrafficFlow.h"
#import "TrafficQueue.h"
#import "TrafficSpeed.h"
#import "TrafficScoot.h"
#import "TrafficTime.h"
#import "CarParks.h"
#import "Roadworks.h"

@class OTCoreData;
@class OTCoreDataBase;
@class OTCoreDataVariableMessageSigns;
@class OTCoreDataTrafficFlow;
@class OTCoreDataTrafficQueue;
@class OTCoreDataTrafficSpeed;
@class OTCoreDataTrafficScoot;
@class OTCoreDataTrafficTime;
@class OTCoreDataCarPark;
@class OTCoreDataRoadworks;
@class OTCoreDataEvent;
@class OTCoreDataCommon;
@class OTCoreDataBitCarrierNode;
@class OTCoreDataBitCarrierSketch;
@class OTCoreDataBitCarrierVector;
@class OTCoreDataBitCarrierTravel;
@class OTCoreDataBitCarrierConfigVector;
@class OTCoreDataClearViewDevice;
@class OTCoreDataClearViewTraffic;

@interface OTSingleton : NSObject

@property (nonatomic, readonly) OTCommonServicesEntity           * _Nullable cse;

@property (nonatomic, readonly) OTSessionTask                    * _Nonnull sessionTask;
@property (nonatomic, readonly) OTCoreData                       * _Nonnull coreData;

@property (nonatomic, readonly) OTCoreDataVariableMessageSigns   * _Nonnull variableMS;
@property (nonatomic, readonly) OTCoreDataTrafficFlow            * _Nonnull trafficFlow;
@property (nonatomic, readonly) OTCoreDataTrafficQueue           * _Nonnull trafficQueue;
@property (nonatomic, readonly) OTCoreDataTrafficSpeed           * _Nonnull trafficSpeed;
@property (nonatomic, readonly) OTCoreDataTrafficScoot           * _Nonnull trafficScoot;
@property (nonatomic, readonly) OTCoreDataTrafficTime            * _Nonnull trafficTime;
@property (nonatomic, readonly) OTCoreDataCarPark                * _Nonnull carParks;
@property (nonatomic, readonly) OTCoreDataRoadworks              * _Nonnull roadworks;
@property (nonatomic, readonly) OTCoreDataEvent                  * _Nonnull events;
@property (nonatomic, readonly) OTCoreDataCommon                 * _Nonnull common;
@property (nonatomic, readonly) OTCoreDataBitCarrierNode         * _Nonnull bitCarrierNode;
@property (nonatomic, readonly) OTCoreDataBitCarrierSketch       * _Nonnull bitCarrierSketch;
@property (nonatomic, readonly) OTCoreDataBitCarrierVector       * _Nonnull bitCarrierVector;
@property (nonatomic, readonly) OTCoreDataBitCarrierTravel       * _Nonnull bitCarrierTravel;
@property (nonatomic, readonly) OTCoreDataBitCarrierConfigVector * _Nonnull bitCarrierConfigVector;
@property (nonatomic, readonly) OTCoreDataClearViewDevice        * _Nonnull clearViewDevice;
@property (nonatomic, readonly) OTCoreDataClearViewTraffic       * _Nonnull clearViewTraffic;

+ (OTSingleton * _Nonnull)sharedInstance;

/**
 * Configure the singleton with your appId, name and password
 * @param appId Your app Id given to you by oneTRANSPORT
 * @param auth The authorisation token given to you by oneTRANSPORT
 */
- (void)configureOneTransport:(NSString * _Nonnull)appId
                         auth:(NSString * _Nonnull)auth
                       origin:(NSString * _Nonnull)origin;

/*
 *
 */
- (OTCoreDataBase * _Nonnull)getObjectClass:(ObjectType)type;

/**
 * Set maximum number of hours to keep local authority data for
 * param hours The number of hours
 */
- (void)setMaxHoursDataAge:(NSInteger)hours;

/**
 * Request data from the Common Services Entity
 * Generates the local object model, request the remote data and then populates the core data table.
 * Posts a NSNotification when all concurrent activities are complete.
 */
- (void)requestData:(LocalAuthority)la container:(ContainerType)cn completion:(_Nonnull CompletionType)completionBlock;

/**
 * Request all data from the Common Services Entity that matches UserDefault settings for retrieval
 * Generates the local object model, request the remote data and then populates the core data table.
 * Posts a NSNotification when all is complete.
 */
- (void)requestData:(_Nonnull CompletionType)completionBlock;

/**
 * Request latest Bit Carrier vector data from the Common Services Entity
 * @param completionBlock The block of type CompletionType to execute on completion of each request or an error
 * Generates the local object model, request the remote data and then populates the core data table.
 */
- (void)requestBitCarrierVectors:(_Nonnull CompletionType)completionBlock;

/**
 * Request latest Bit Carrier travel data from the Common Services Entity
 * @param completionBlock The block of type CompletionType to execute on completion of each request or an error
 * Generates the local object model, request the remote data and then populates the core data table.
 */
- (void)requestBitCarrierTravel:(_Nonnull CompletionType)completionBlock;

/**
 * Set to kph or mph (kilometres per hour or miles per hour)
 * @param kph Set to true for kph, false for mph
 */
- (void)setKph:(BOOL)kph;

/**
 * Returns true if set for kph, false for mph
 */
- (BOOL)isKph;

/**
 * Turn off/on the trace output log displayed in the XCode log output
 * @param trace Set to true for output, false for no output
 */
- (void)setTrace:(BOOL)trace;

/**
 * Returns true if set for trace output, false for no trace output
 */
- (BOOL)isTrace;

/**
 * Set the bounding box for filtering of all data requests. Any data outside the min/max lat/lon will not be stored in the database
 * @param min The top left latitude/longitude
 * @param max The bottom right latitude/longitude
 */
- (void)setDataImportFilterMin:(CLLocationCoordinate2D)min max:(CLLocationCoordinate2D)max;

/**
 * Clears the bounding box filter for future data requests
 */
- (void)clearDataImportFilter;

/**
 * Returns the top left latitude/longitude of the bounding box filter for data requests
 */
- (CLLocationCoordinate2D)getMinImportFilter;
    
/**
 * Returns the bottom right latitude/longitude of the bounding box filter for data requests
 */
- (CLLocationCoordinate2D)getMaxImportFilter;

/**
 * Remove all data from database tables
 * @param completion Completion block to execute as remove all finishes
 */
- (void)removeAll:(_Nonnull PopulateBlock)completion;

/**
 * Get AE (Application Entity) id for the specified LocalAuthority
 * @param la The LocalAuthority enum type
 * Returns the AE Id string
 */
- (NSString * _Nonnull)getAuthorityAeId:(LocalAuthority)la;

/**
 * Get the NSUserDefaults key for the specified LocalAuthority. The user defaults value must be true for the automated data request.
 * @param la The LocalAuthority enum type
 * Returns the NSUserDefaults key string
 */
- (NSString * _Nonnull)getUserDefault:(LocalAuthority)la;

/**
 * Get CNT (Container) id for the specified Container Type enum
 * @param cnt The Container type
 * Returns the Container Id string
 */
- (NSString * _Nonnull)getContainerId:(ContainerType)cnt;

/**
 * Get CNT (Container) objecter for the specified Container Type enum
 * @param cnt The Container type
 * Returns the Container object
 */
- (OTCoreDataBase * _Nonnull)getCntObject:(ContainerType)cnt;

@end

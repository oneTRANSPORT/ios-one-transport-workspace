//
//  oneTRANSPORT.h
//  oneTRANSPORT
//
//  Created by Dominic Frazer Imregh on 19/10/2016.
//  Copyright © 2016 InterDigital. All rights reserved.
//

#import <UIKit/UIKit.h>

//! Project version number for oneTRANSPORT.
FOUNDATION_EXPORT double oneTRANSPORTVersionNumber;

//! Project version string for oneTRANSPORT.
FOUNDATION_EXPORT const unsigned char oneTRANSPORTVersionString[];

// In this header, you should import all the public headers of your framework using statements like #import <oneTRANSPORT/PublicHeader.h>

/**
 * Main handler for all requests to the OneTransport Framework
 */
#import "OTSingleton.h"

#import "OTCoreData.h"
#import "OTCoreDataBase.h"
#import "OTCoreDateBaseTsv.h"

/**
 * Definitions
 */
#import "OTTransportTypes.h"

/**
 * Access to the CoreData model for Common
 */
#import "OTCoreDataCommon.h"
#import "Common.h"
#import "Common+CoreDataProperties.h"

/**
 * Access to the CoreData model for cached CSE responses
 */
#import "OTCoreDataVariableMessageSigns.h"
#import "VariableMessageSigns.h"
#import "VariableMessageSigns+CoreDataProperties.h"

/**
 * Access to the CoreData model for cached CSE responses
 */
#import "OTCoreDataTraffic.h"

#import "OTCoreDataTrafficFlow.h"
#import "TrafficFlow.h"
#import "TrafficFlow+CoreDataProperties.h"

#import "OTCoreDataTrafficQueue.h"
#import "TrafficQueue.h"
#import "TrafficQueue+CoreDataProperties.h"

#import "OTCoreDataTrafficSpeed.h"
#import "TrafficSpeed.h"
#import "TrafficSpeed+CoreDataProperties.h"

#import "OTCoreDataTrafficScoot.h"
#import "TrafficScoot.h"
#import "TrafficScoot+CoreDataProperties.h"

#import "OTCoreDataTrafficTime.h"
#import "TrafficTime.h"
#import "TrafficTime+CoreDataProperties.h"

/**
 * Access to the CoreData model for cached CSE responses
 */
#import "OTCoreDataCarPark.h"
#import "CarParks.h"
#import "CarParks+CoreDataProperties.h"

/**
 * Access to the CoreData model for cached CSE responses
 */
#import "OTCoreDataRoadworks.h"
#import "Roadworks.h"
#import "Roadworks+CoreDataProperties.h"

/**
 * Access to the CoreData model for cached CSE responses
 */
#import "OTCoreDataEvent.h"
#import "Event.h"
#import "Event+CoreDataProperties.h"

/**
 */
#import "OTCoreDataBitCarrierNode.h"
#import "BC_Node.h"
#import "BC_Node+CoreDataProperties.h"

#import "OTCoreDataBitCarrierSketch.h"
#import "BC_Sketch.h"
#import "BC_Sketch+CoreDataProperties.h"

#import "OTCoreDataBitCarrierVector.h"
#import "BC_Vector.h"
#import "BC_Vector+CoreDataProperties.h"

#import "OTCoreDataBitCarrierTravel.h"
#import "BC_Travel.h"
#import "BC_Travel+CoreDataProperties.h"

#import "OTCoreDataBitCarrierConfigVector.h"
#import "BC_ConfigVector.h"
#import "BC_ConfigVector+CoreDataProperties.h"

/**
 */
#import "OTCoreDataClearViewDevice.h"
#import "CV_Device.h"
#import "CV_Device+CoreDataProperties.h"

#import "OTCoreDataClearViewTraffic.h"
#import "CV_Traffic.h"
#import "CV_Traffic+CoreDataProperties.h"

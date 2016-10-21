//
//  FlorenceSDK.h
//  FlorenceSDK
//
//  Created by Dominic Frazer Imregh on 04/07/2016.
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

#import <UIKit/UIKit.h>

//! Project version number for FlorenceSDK.
FOUNDATION_EXPORT double FlorenceSDKVersionNumber;

//! Project version string for FlorenceSDK.
FOUNDATION_EXPORT const unsigned char FlorenceSDKVersionString[];

/**
 * Definitions
 */
#import "OTTypes.h"

/**
 * A SessionTask is required to manage communication queues
 * Only one SessionTask is required
 */
#import "OTSessionTask.h"



/*
 * Example object structure
 * CSE
 *     - AE 1
 *          - CNT 1
 *               - CIN 1
 *          - CNT 2
 *               - CIN 1
 *               - CIN 2
 *     - AE 2
 *          - CNT 1
 *               - CIN 1
 * GRP
 * ACP
 */

/**
 * OTObjectBase is inherited by the CSE (CommonServicesEntity), AE (Application Entity), CNT (Container), CIN (ContentInstance) objects
 */
#import "OTObjectBase.h"

/**
 * CSE (CommonServicesEntity) object
 */
#import "OTCommonServicesEntity.h"

/**
 * OTObjectAnnounceableResource base is inherited by the AE (Application Entity), CNT (Container), CIN (ContentInstance) objects
 */
#import "OTObjectAnnounceableResource.h"

/**
 * AE (Application Entity) objects
 * There can be more than one AE per CSE
 */
#import "OTApplicationEntity.h"

/**
 * CNT (Container) objects
 * There can be more than one CNT per AE and a CNT can contain child CNT objects
 */
#import "OTContainer.h"

/**
 * CIN (ContentInstance) objects
 * There can be more than one CIN per CNT
 */
#import "OTContentInstance.h"

/**
 * ACP (Access Control Policy) objects
 * A collection of Access Control Rules
 */
#import "OTAccessControlPolicy.h"

    /**
     * ACP Set Of Rules
     * The Access Control Set, either pv (privileges) or pvs (self privileges)
     */
    #import "OTSetOfAccessControlRules.h"

        /**
         * Access Control Rule within a set
         * The Access Control Rule
         */
        #import "OTAccessControlRule.h"

            /**
             * Access Control Context within a Rule
             * A collection of Access Control Contexts
             */
            #import "OTAccessControlContext.h"

                /**
                 * Access Control Ip Addresses within a Context
                 * A collection of Access Control IP Addresses
                 */
                #import "OTAccessControlIpAddress.h"

                /**
                 * Access Control Regions within a Context
                 * A collection of Access Control Regions
                 */
                #import "OTLocationRegion.h"

                    /**
                     * Access Control Regions latitude, longitude and radius within a Region
                     * The latitude, longitude and radius (in metres)
                     */
                    #import "OTLocationRegionCircular.h"

/**
 * GRP (Group) objects
 * A group of resources, used to do bulk manipulations
 */
#import "OTGroup.h"

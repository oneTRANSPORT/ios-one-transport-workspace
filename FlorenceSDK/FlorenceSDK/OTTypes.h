//
//  OTTypes.h
//  FlorenceSDK
//
//  Created by Dominic Frazer Imregh on 05/07/2016.
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

#ifndef OTTypes_h
#define OTTypes_h

/*
 To turn on the oneTRANSPORT trace logs within your own applications:
 Objective-C
 [[NSUserDefaults standardUserDefaults] setBool:true forKey:kKeyUserDefaults_Trace];
 Swift
 NSUserDefaults.standardUserDefaults().setBool(true, forKey: kKeyUserDefaults_Trace)
 
 This activates the NSLog and the postNotifications through kKeyNotification_Trace. 
 For an example, see ViewControllerBase.m
    viewWillAppear
    viewWillDisappear
 */
#define kKeyUserDefaults_Trace  @"InterDigital_UserDefaultsTrace"
#define kKeyNotification_Trace  @"InterDigital_NotificationTrace"

#define kBackgroundSession      @"BackgroundSession"
//
#define kKeyErrorResponse   @"Response"
#define kKeyRqiResponse     @"RqiResponse"

typedef void (^CompletionType)(NSDictionary * __nullable response, NSError * __nullable error);

/**
 Communication methods used by objects that inherit from OTObjectBase, using remoteRequest methods
 */
typedef NS_ENUM(NSInteger, CommandType) {
    CommandTypeCreate,
    CommandTypeDiscover,
    CommandTypeDiscoverViaRcn,
    CommandTypeGet,
    CommandTypeUpdate,
    CommandTypeDelete,
};

/**
 * Communication sub methods used by objects that inherit from OTObjectBase, using remoteRequest methods
 */
typedef NS_ENUM(NSInteger, SubCommandType) {
    SubCommandTypeNone,
    SubCommandTypeFanOut,           //valid for groups
    SubCommandTypeLatest,           //valid for containers
    SubCommandTypeOldest,           //valid for containers
    SubCommandTypeFanOutLatest,     //valid for groups
    SubCommandTypeFanOutOldest,     //valid for groups
};

/**
 * Used to record the current status of an object (object.commsStatus).
 * Newly created objects are set to CommunicationsProgressNeverCalled
 * Use object.lastResponseStatusCode to reference previous communications
 */
typedef NS_ENUM(NSInteger, CommunicationsProgress) {
    CommunicationsProgressNeverCalled,
    CommunicationsProgressWorking,
    CommunicationsProgressDone,
    CommunicationsProgressFail,
};

/**
 * OneM2M resource types
 */
typedef NS_ENUM(NSInteger, ResourceType) {
    RESOURCE_TYPE_NONE = -1,
    RESOURCE_TYPE_ACCESS_CONTROL_POLICY = 1,                //implemented in v1.0
    RESOURCE_TYPE_APPLICATION_ENTITY = 2,                   //implemented in v1.0
    RESOURCE_TYPE_CONTAINER = 3,                            //implemented in v1.0
    RESOURCE_TYPE_CONTENT_INSTANCE = 4,                     //implemented in v1.0
    RESOURCE_TYPE_CSE_BASE = 5,                             //implemented in v1.0
    RESOURCE_TYPE_DELIVERY = 6,
    RESOURCE_TYPE_EVENT_CONFIG = 7,
    RESOURCE_TYPE_EXEC_INSTANCE = 8,
    RESOURCE_TYPE_GROUP = 9,                                //implemented in v1.0
    RESOURCE_TYPE_LOCATION_POLICY = 10,
    RESOURCE_TYPE_M2M_SERVICE_SUBSCRIPTION_PROFILE = 11,
    RESOURCE_TYPE_MGMT_CMD = 12,
    RESOURCE_TYPE_MGMT_OBJ = 13,
    RESOURCE_TYPE_NODE = 14,
    RESOURCE_TYPE_POLLING_CHANNEL = 15,
    RESOURCE_TYPE_REMOTE_CSE = 16,
    RESOURCE_TYPE_REQUEST = 17,
    RESOURCE_TYPE_SCHEDULE = 18,
    RESOURCE_TYPE_SERVICE_SUBSCRIBED_NODE = 19,
    RESOURCE_TYPE_SERVICE_SUBSCRIBED_APP_RULE = 20,
    RESOURCE_TYPE_STATS_COLLECT = 21,
    RESOURCE_TYPE_STATS_CONFIG = 22,
    RESOURCE_TYPE_SUBSCRIPTION = 23,
    RESOURCE_TYPE_ACCESS_CONTROL_POLICY_ANNC = 10001,
    RESOURCE_TYPE_AE_ANNC = 10002,
    RESOURCE_TYPE_CONTAINER_ANNC = 10003,
    RESOURCE_TYPE_CONTENT_INSTANCE_ANNC = 10004,
    RESOURCE_TYPE_GROUP_ANNC = 1009,
    RESOURCE_TYPE_LOCATION_POLICY_ANNC = 10010,
    RESOURCE_TYPE_MGMT_OBJ_ANNC = 10013,
    RESOURCE_TYPE_NODE_ANNC = 10014,
    RESOURCE_TYPE_REMOTE_CSE_ANNC = 10016,
    RESOURCE_TYPE_SCHEDULE_ANNC = 10018,
};

/**
 * These codes are returned by the Common Services Entity and typically returned within the NSError object in a completion block.
 * The last known value of communication error are also stored in object.lastResponseStatusCode
 */
typedef NS_ENUM(NSInteger, StatusCode) {
    StatusCodeNotSet = 0,
    StatusCodeAuthError = 401,
    StatusCodeAccepted = 1000,
    StatusCodeOK = 2000,
    StatusCodeCreated = 2001,
    StatusCodeDeleted = 2002,
    StatusCodeUpdated = 2004,
    StatusCodeBadRequest = 4000,
    StatusCodeNotFound = 4004,
    StatusCodeOperationNotAllowed = 4005,
    StatusCodeRequestTimedOut = 4008,
    StatusCodeSubscriptionCreatorHasNoPrivilege = 4101,
    StatusCodeContentsUnacceptable = 4102,
    StatusCodeAccessDenied = 4103,
    StatusCodeGroupRequestIdentifierExists = 4104,
    StatusCodeConflict = 4105,
    StatusCodePrivateServerError = 5000,
    StatusCodeNotImpemented = 5001,
    StatusCodeTargetNotReachable = 5103,
    StatusCodeNoPrivilege = 5105,
    StatusCodeAlreadyExists = 5106,
    StatusCodeTargetNotSubscribable = 5203,
    StatusCodeSubscriptionVerificationInitiationFailed = 5204,
    StatusCodeSubscriptionHostHasNoPrivilege = 5205,
    StatusCodeNonBlockingRequestNotSupported = 5206,
    StatusCodeExternalObjectNotReachable = 6003,
    StatusCodeExternalObjectNotFound = 6005,
    StatusCodeMaxNumberOfMemberExceeded = 6010,
    StatusCodeMemberTypeInconsistent = 6011,
    StatusCodeManagementSessionCannotBeEstablished = 6020,
    StatusCodeManagementSessionEstablishementTimeout = 6021,
    StatusCodeInvalidCMDType = 6022,
    StatusCodeInvalidArguments = 6023,
    StatusCodeInsufficientArgument = 6024,
    StatusCodeMGMTConversionError = 6025,
    StatusCodeMGMTCancellationFailed = 6026,
    StatusCodeAlreadyComplete = 6028,
    StatusCodeCommandNotCancellable = 6029,
};

/*
 * ACP (Access Control Policy) access types. These can be combined, e.g.
 *      acop = AccessControlOperationCREATE | AccessControlOperationRETRIEVE
 * and there is a helper type (AccessControlOperationALL) for combining all types
 */
typedef NS_ENUM(NSInteger, AccessControlOperation) {
    AccessControlOperationCREATE = 1,
    AccessControlOperationRETRIEVE = 2,
    AccessControlOperationUPDATE = 4,
    AccessControlOperationDELETE = 8,
    AccessControlOperationNOTIFY = 16,
    AccessControlOperationDISCOVERY = 32,
    
    AccessControlOperationALL = 63,         //helper type for combining all ACOP types
};

/*
 * OneM2M
 */
typedef NS_ENUM(NSInteger, ConsistencyStrategy) {
    CONSISTENCY_STRATEGY_ABANDON_MEMBER = 1,
    CONSISTENCY_STRATEGY_ABANDON_GROUP = 2,
    CONSISTENCY_STRATEGY_SET_MIXED = 3,
};

/*
 * OneM2M
 */
typedef NS_ENUM(NSInteger, PendingNotification) {
    PENDING_NOTIFICATION_SEND_LATEST = 1,
    PENDING_NOTIFICATION_SEND_ALL_PENDING = 2,
};

/*
 * OneM2M
 */
typedef NS_ENUM(NSInteger, NotificationContentType) {
    NOTIFICATION_CONTENT_TYPE_ALL_ATTRIBUTES = 1,
    NOTIFICATION_CONTENT_TYPE_MODIFIED_ATTRIBUTES = 2,
    NOTIFICATION_CONTENT_TYPE_RESOURCE_ID = 3,
};

/*
 * OneM2M
 */
typedef NS_ENUM(NSInteger, NotificationEventType) {
    NOTIFICATION_EVENT_TYPE_UPDATE = 1,
    NOTIFICATION_EVENT_TYPE_DELETE = 2,
    NOTIFICATION_EVENT_TYPE_CREATE_CHILD = 3,
    NOTIFICATION_EVENT_TYPE_DELETE_CHILD = 4,
};

/*
 * OneM2M
 */
typedef NS_ENUM(NSInteger, LocationSource) {
    LOCATION_SOURCE_NETWORK = 1,
    LOCATION_SOURCE_DEVICE = 2,
    LOCATION_SOURCE_SHARING = 3,
};

/*
 * OneM2M Filter type
 */
#define FILTER_CRITERIA_CREATED_BEFORE      @"crb"
#define FILTER_CRITERIA_CREATED_AFTER       @"cra"
#define FILTER_CRITERIA_MODIFIED_SINCE      @"ms"
#define FILTER_CRITERIA_UNMODIFIED_SINCE    @"us"
#define FILTER_CRITERIA_STATE_TAG_SMALLER   @"sts"
#define FILTER_CRITERIA_STATE_TAG_BIGGER    @"stb"
#define FILTER_CRITERIA_EXPIRE_BEFORE       @"exb"
#define FILTER_CRITERIA_EXPIRE_AFTER        @"exa"
#define FILTER_CRITERIA_LABELS              @"lbl"
#define FILTER_CRITERIA_RESOURCE_TYPE       @"rty"
#define FILTER_CRITERIA_SIZE_ABOVE          @"sza"
#define FILTER_CRITERIA_SIZE_BELOW          @"szb"
#define FILTER_CRITERIA_CONTENT_TYPE        @"cty"
#define FILTER_CRITERIA_LIMIT               @"lim"
#define FILTER_CRITERIA_ATTRIBUTE           @"atr"
#define FILTER_CRITERIA_FILTER_USAGE        @"fu"
#define FILTER_RCN                          @"rcn"

/*
 * Header types
 */
#define HEADER_RESPONSE_STATUS_CODE     @"X-M2M-RSC"
#define HEADER_REQUEST_ID               @"X-M2M-RI"
#define HEADER_REQUEST_ORIGIN           @"X-M2M-Origin"
#define HEADER_REQUEST_RESOURCENAME     @"X-M2M-NM"
/**
 * Used by unit tests
 */
typedef NS_ENUM(NSInteger, CommsStatus) {
    CommsStatusNotDefined,
    CommsStatusSuccess,
    CommsStatusFail,
    CommsStatusWrongThread,
};

#endif /* OTTypes_h */

Using the OneTransportMaps workspace
====================================

The oneTRANSPORTMaps workspace can be downloaded from [GitHub]
(https://github.com/oneTRANSPORT/ios-one-transport-workspace)


Credentials
===========

Before you can run the applications you will need to create an App in the oneTRANSPORT [Developer Portal] (https://cse-01.onetransport.uk.net/portal/login) and replace the existing source code credentials with the following.

For Swift:

In AppDelegate.swift ensure that didFinishLaunchingWithOptions includes the following: 

		let APP_ID       = "<Your App Name>"
		let ACCCESS_KEY  = "<Your Access Key>"
		let ORIGIN       = "<Your AEID>"
	

For Objective-C:

In AppDelegate.m ensure that didFinishLaunchingWithOptions includes the following: 

	    NSString *APP_ID     = @"<Your App Name>";
	    NSString *APP_TOKEN  = @"<Your Access Key>";
	    NSString *APP_ORIGIN = @"<Your AEID>";

Project Settings
================
 
In the Project Settings for OTMap, OTPotHoles and OTObjCExample you will need to put in your own **Bundle Identifier** and **Developer Team**.
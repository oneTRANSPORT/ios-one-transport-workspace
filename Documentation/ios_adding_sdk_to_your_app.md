Adding the SDK to your XCode app
================================

The oneTRANSPORT SDK for iOS is currently distributed as a set of two Frameworks.

Add both of the following to your XCode project:

1. FlorenceSDK.Framework

2. oneTRANSPORT.framework

## New Projects

For new projects you need to include both frameworks.

For Swift:

Add the following to AppDelegate.swift

	import oneTRANSPORT

And ensure that didFinishLaunchingWithOptions includes the following: 

	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {   
	
		let APP_ID       = "<Your App Name>"
		let ACCCESS_KEY  = "<Your Access Key>"
		let ORIGIN       = "<Your AEID>"
	
		OTSingleton.sharedInstance().configureOneTransport(APP_ID, auth: ACCCESS_KEY, origin: ORIGIN)
	
	    return true
    }



For Objective-C:

Add the following to AppDelegate.m

	#import <oneTRANSPORT/oneTRANSPORT.h>

And ensure that didFinishLaunchingWithOptions includes the following: 

	- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

	    NSString *APP_ID     = @"<Your App Name>";
	    NSString *APP_TOKEN  = @"<Your Access Key>";
	    NSString *APP_ORIGIN = @"<Your AEID>";
	    
	    [[OTSingleton sharedInstance] configureOneTransport:APP_ID auth:APP_TOKEN origin:APP_ORIGIN];
	    
	    return YES;
	}


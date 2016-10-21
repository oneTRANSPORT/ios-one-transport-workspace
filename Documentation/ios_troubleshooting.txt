Troubleshooting
===============

1. Turn on the trace logging for the SDKs. This will highlight specific errors around HTTPS calls and responses.


	Objective-C
	
		[[OTSingleton sharedInstance] setTrace:YES];
		
	Swift
	
		OTSingleton.sharedInstance().setTrace(true)
	
2. Check that the AppDelegate configuration of oneTRANSPORT matches the Developer Portal

	Objective-C
	
		[[OTSingleton sharedInstance] configureOneTransport:APP_ID auth:ACCCESS_KEY origin:ORIGIN];
		
	Swift
	
		OTSingleton.sharedInstance().configureOneTransport(APP_ID, auth: ACCCESS_KEY, origin: ORIGIN)

	APP_ID is the Portal name for your Application, e.g. "MyApp"
	
	ACCESS_KEY is the Portal App Key, e.g. "000aaa0aAAaAaAA0"
	
	ORIGIN is the Portal Application ID, e.g. "C-A000aAaa00A0aA00A0a0000AAAaa0"

3. Run our oneTransport Map App and make sure that it works on your Mac


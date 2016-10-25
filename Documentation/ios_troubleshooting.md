# No data received
1. Check the [available data](ios_available_data.html) to make sure that what you are requesting is available, i.e. only Buckinghamshire and Oxfordshire have complete data sets.

2. Turn on the trace logging for the SDKs. This will highlight specific errors around HTTPS calls and responses.

	OTMap app
	
		"Settings" - "XCode Trace Log"
		
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

3. Run our oneTransport Map app and make sure that it works on your Mac

# Expected map pins are missing in the OTMap app
Check that there is no Map Rectangle Filter in force by running the app and going to Settings. If you see:

	"Data request/import filter set ..."

then all data imported (including BitCarrier TSV imports) will be filtered. Select "Clear Filter" and try again. 

# Data import is very slow
You are probably trying to request a lot of data. Currently the SDK uses Apple Core Data which has some performance issues with database updates on large sets. For example, roadworks for all authorities totals more than 6,500 records.

For increased speed, either reduce the number of local authorities to request or setup a Map Rectangle Filter to filter out unwanted data before it is written to Core Data.

# Map loading is very slow
The demo app has two different modes and by default the clustering is turned off.
To turn on clustering, look for:

	MapView.swift
	
	var shouldClusterPins = false
	
and set to **true**.

This will improve general performance but to increase performance further, either reduce the number of local authorities that you are requesting or setup a Map Rectangle Filter to filter out unwanted data before it is written to Core Data.

# BitCarrier TSV Import not working
If the BitCarrier nodes are not appearing on the map:

1. Ensure that you do not have an active Map Rectangle Filter that would filter them out. An active Map Rectangle Filter in the wrong area will not save the nodes to Core Data.

2. Check the Map Filter options and ensure that BitCarrier is switched on. This will not affect the import into Core Data but will affect the display of the data on the map.

# BitCarrier favourites don't show graph data
The TSV import data doesn't contain graph data for all points. Favourite a node on a green or yellow route for results. Grey routes are those where information is not available.

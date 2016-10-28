# Request API
For the latest road traffic data we provide a simple API that returns oneTRANSPORT resources as arrays of objects.

Current feed data from oneTRANSPORT is made available through requests that wrap HTTPS requests to the CSE.  These are asynchronous, working on background threads and returning results in completion blocks.

A typical request is made to a local authority AE, requesting a particular container type.

Objective-C
		
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


Swift (via a Bridging Header)
		
	enum LocalAuthority {
		case bucks
		case northants
		case oxon
		case herts
		case birmingham
	}

	enum ContainerType {
		case variableMessageSigns
		case trafficFlow
		case trafficQueue
		case trafficSpeed
		case trafficScoot
		case trafficTime
		case events
		case carParks
		case roadWorks
		case bitCarrier
		case clearView
	}


See **OTTransportTypes.h** for full details of enums and other definitions.


Below is an example that requests the latest car park data for Buckinghamshire. On completion, if there is no error a dictionary can be extracted to show changes and the **common** and **carParks** objects can be queried to return CoreData arrays:

Objective-C

    CompletionType completionBlock = ^(NSDictionary *response, NSError *error) {
      
		dispatch_async(dispatch_get_main_queue(), ^{
 			//UI components must be updated on the main thread
 			self.activityIndicator.hidden = true;
		});

		if (error != nil) {
		    NSLog(@"%@", [error localizedDescription]);
		} else {
		    NSArray *arrayChanges = response[kResponseChangesAll];
		    NSLog(@"%@", arrayChanges);
		     
		    NSArray *arrayCommon = [[OTSingleton sharedInstance].common retrieveType:ObjectTypeCarParks];
		    NSLog(@"CoreData Common contains %zd car park records", arrayCommon.count);                
		   
		    NSArray *array = [[OTSingleton sharedInstance].carParks retrieveAll:false];
		    NSLog(@"CoreData CarParks contains %zd records", array.count);                
		}
	};
    
	self.activityIndicator.hidden = false;
	[[OTSingleton sharedInstance] requestData:LocalAuthorityBucks container:ContainerTypeCarParks completion:completionBlock];

Swift

	self.activityIndicator.isHidden = false
	
	OTSingleton.sharedInstance().requestData(.bucks, container: .carParks) {response, error in
		
		DispatchQueue.main.async {
 			//UI components must be updated on the main thread
			self.activityIndicator.isHidden = true
		}
		
		if error != nil {
			print (error.localizedDescription)
		} else {
			print (response)
			
			let arrayCommon = OTSingleton.sharedInstance().common.retrieveType(.carParks)
			print (arrayCommon)
		
			let array = OTSingleton.sharedInstance().carParks.retrieveAll(false)
			print (array)
		}
	}

#Thread safe
All completion blocks return on a background thread hences the need to dispatch UI changes to the main thread.

The above examples demonstrate that Core Data entities can be interrogated within a completion block. 

Since oneTRANSPORT Core Data is thread safe it is acceptable to query objects on the main or background threads.

#Purge old data
New requests for data from the CSE forces an age check of the historical data in the entity. Any data older than the specified number of hours is purged. To override the default of 4 hours of data to retain can be overridden with:

Objective-C

	[[OTSingleton sharedInstance] setMaxHoursDataAge:99];

Swift

	OTSingleton.sharedInstance().setMaxHoursDataAge(99)


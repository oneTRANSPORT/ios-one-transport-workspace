Florence oneM2M iOS SDK
=======================

For details on the oneM2M standard, please refer to the [oneM2M documentation] (http://onem2m.org/technical/latest-drafts)

Requests to the CSE are made available through requests that wrap HTTPS requests.  These are asynchronous, working on background threads and returning results in completion blocks.

A typical request is made to an AE (Application Entity), CNT (Container) or CIN (Content Instance).

Objective-C
		
	typedef NS_ENUM(NSInteger, CommandType) {
		CommandTypeCreate,
		CommandTypeDiscover,
		CommandTypeDiscoverViaRcn,
		CommandTypeGet,
		CommandTypeUpdate,
		CommandTypeDelete,
	};
	
	typedef NS_ENUM(NSInteger, SubCommandType) {
		SubCommandTypeNone,
		SubCommandTypeFanOut,       
		SubCommandTypeLatest,       
		SubCommandTypeOldest,       
		SubCommandTypeFanOutLatest, 
		SubCommandTypeFanOutOldest, 
	};


Swift (via a Bridging Header)
		
	enum CommandType {
		case create
		case discover
		case discoverViaRcn
		case get
		case update
		case delete
	}

	enum SubCommandType {
		case none,
		case fanOut,       
		case latest,       
		case oldest,       
		case fanOutLatest, 
		case fanOutOldest, 
	}
	

See **OTTypes.h** for full details of enums and other definitions.

The basis for the FlorenceSDK is in the creation of local objects that mirror the objects found within the CSE. The example below demonstrates the connection between a CSE, AE, CNT and CIN.

	//First configure the CSE
	[self.singleton configureCseWithBaseUrl:url appId:appId resourceId:resId resourceName:resName auth:auth origin:origin];
	    
	//Build the local objects
	OTCommonServicesEntity *cse = self.singleton.cse;
	OTApplicationEntity *ae = [cse createAeWithId:resId name:resNameOfAe];
	OTContainer *cnt = [ae createContainerWithName:resNameOfCnt];
	OTContentInstance *cin = [cnt createContentInstanceWithName:resNameOfCin];
	
	//Retrieve data from a container
	[cnt remoteRequest:CommandTypeGet subMethod:SubCommandTypeNone session:self.singleton.sessionTask completionBlock:completionBlock];


See the **FlorenceIntegration App** for detailed examples of how to access CSEs using the oneM2M standards.


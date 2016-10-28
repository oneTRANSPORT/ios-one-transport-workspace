# What data is available?
This SDK gives your app access to:

1. real-time road transport data from four counties in England: Buckinghamshire, Hertfordshire, Northamptonshire and Oxfordshire.

2. real-time road transport data for Birmingham

3. Historical data sets from race weekends at Silverstone
circuit during the Formula One Grand Prix and Moto GP races in 2016.

# Near-real-time local authority feeds

Data sources are provided by county and by data type, but note that there
is a fair amount of overlap between the regions and councils may control
items outside their boundaries.  For example, Northamptonshire has variable
message signs near Luton and Leicester.  We suggest consuming all the feeds
for the items in which you are interested and then filtering with a Map Rectangle Filter if needed.

Also, not every local authority provides every type of data.  This is the status of the current feeds:

- Y = Available

- n = Not Available At Present

- . = Does Not Exist

|                        | Bucks   | Herts   |Northants| Oxon    |Birmingham|
|------------------------|:-------:|:-------:|:-------:|:-------:|:--------:|
| Variable Message Signs |    n    |    Y    |    Y    |    Y    |    Y     |
| Car Parks              |    n    |    n    |    n    |    n    |    Y     |
| Traffic Flow           |    Y    |    Y    |    Y    |    Y    |    Y     |
| Traffic Queue          |    n    |    .    |    .    |    n    |    .     |
| Traffic Speed          |    n    |    Y    |    .    |    Y    |    Y     |
| Traffic Scoot          |    Y    |    Y    |    .    |    n    |    Y     |
| Traffic Time           |    n    |    Y    |    Y    |    Y    |    Y     |
| Roadworks              |    Y    |    Y    |    Y    |    Y    |    Y     |
| Events                 |    Y    |    n    |    Y    |    Y    |    .     |

The data types in each feed are common across counties, so a car park object from Bucks will be the same format as one from Northants.  Objects retrieved from a feed are generally indicative of the current situation, so if an average speed reading across a link is 40kph, then that was true when the last reading was observed a few minutes ago.  If an event occurs in a feed, then that event is happening now.

Here are the structures for the Core Data classes:

> ## `Common` - Generic data
> > **`NSString *reference`** unique identifier
> > 
> > **`NSDate *timestamp`** timestamp from CSE of last update to the record
> > 
> > **`NSNumber *latitude`** **`double`** latitude of object
> > 
> > **`NSNumber *longitude`** **`double`** longitude of object
> > 
> > **`NSString *type`** iOS specific string type for the object
> > 
> > 	#define k_CommonType_VariableMS                @"VMS"
> > 
> > 	#define k_CommonType_TrafficFlow               @"TFFl"
> > 
> > 	#define k_CommonType_TrafficQueue              @"TFTr"
> > 
> > 	#define k_CommonType_TrafficSpeed              @"TFSp"
> > 
> > 	#define k_CommonType_TrafficScoot              @"TFSc"
> > 
> > 	#define k_CommonType_TrafficTime               @"TFTi"
> > 
> > 	#define k_CommonType_CarParks                  @"CP"
> > 
> > 	#define k_CommonType_Roadworks                 @"RW"
> > 
> > 	#define k_CommonType_Events                    @"EV"
> > 
> > 	#define k_CommonType_BitCarrierNode            @"BCN"
> > 
> > 	#define k_CommonType_BitCarrierSketch          @"BCS"
> > 
> > 	#define k_CommonType_BitCarrierVector          @"BCV"
> > 
> > 	#define k_CommonType_BitCarrierConfigVector    @"BCCV"
> > 
> > 	#define k_CommonType_BitCarrierTravel          @"BCT"
> > 
> > 	#define k_CommonType_ClearViewDevice           @"CVD"
> > 
> > 	#define k_CommonType_ClearViewTraffic          @"CVT"
 
> > **`NSString *title`** Title of the object from the CSE
> > 
> > **`NSNumber *favourite`** Bool favourited in the app
> > 
> > **`NSNumber *latitudeTo`** **`double`** latitude of 2nd traffic location if available
> > 
> > **`NSNumber *longitudeTo`** **`double`** longitude of 2nd traffic location if available
> > 
> > **`NSString *typeSubFrom`** fromType for traffic
> > 
> > **`NSString *typeSubTo`** toType for traffic
> > 
> > **`NSString *titleTo`** name of the end of the link
> > 
> > **`NSString *tpegDirection`** tpegDirection for traffic
> > 
> > **`NSNumber *counter1`** **`NSInteger`** primary value to show on maps
> > 
> > **`NSNumber *counter2`** **`NSInteger`** secondary value to show on maps
> > 
> > **`NSNumber *angle`** **`float`** calculated angle between from and to coordinates
> >
	Example data
	    reference = "GUIDGLOU-BC005-WP00100500223610100";
	    angle = 0;
	    counter1 = 0;
	    counter2 = 0;
	    favourite = 0;
	    latitude = "51.7619324";
	    latitudeTo = 0;
	    longitude = "-2.53026152";
	    longitudeTo = 0;
	    timestamp = "2016-10-26 08:36:32 +0000";
	    title = "GUIDGLOU-BC005-WP00100500223610100";
	    titleTo = nil;
	    tpegDirection = nil;
	    type = RW;
	    typeSubFrom = "";
	    typeSubTo = "";


> ## `CarParks`

> > **`NSString *reference`** unique identifier that matches that of the Common record
> > 
> > **`NSDate *timestamp`** timestamp from CSE of last update to the record
> > 
> > **`NSNumber *capacity`** **`NSInteger`** total capacity
> > 
> > **`NSNumber *spacesAvailable`** **`NSInteger`** available spaces
> > 
> > **`NSNumber *rateExit`** **`NSInteger`** cars leaving per hour
> > 
> > **`NSNumber *rateFill`** **`NSInteger`** cars entering per hour
> > 
> > **`NSNumber *almostFullDec`** **`NSInteger`** number of spaces below which 'almost full' becomes 'spaces available' as cars leave
> > 
> > **`NSNumber *almostFullInc`** **`NSInteger`** number of spaces above which 'spaces available' becomes 'almost full' as cars enter
> > 
> > **`NSNumber *fullDec`** **`NSInteger`** number of spaces below which 'full' becomes 'almost full' as cars leave
> > 
> > **`NSNumber *fullInc`** **`NSInteger`** number of spaces below which 'full' becomes 'almost full' as cars enter
> > 
> > **`NSNumber *full`** **`NSInteger`** number of spaces above which the car park is considered full (so the entrance sign lights up 'FULL')
> > 
> > **`NSNumber *occupancy`**
> > 
> > **`NSString *occupancyTrend`**
> > 
> > **`NSString *status`**
> > 
> > **`NSNumber *queuingTime`** current queuing time for car park entry
> > 
	Example data
	    reference = BHMNCPPLS01;
	    almostFullDec = 0;
	    almostFullInc = 0;
	    capacity = 450;
	    full = 0;
	    fullDec = 0;
	    fullInc = 0;
	    occupancy = 109;
	    occupancyTrend = Filling;
	    queuingTime = 0;
	    rateExit = 0;
	    rateFill = 1;
	    spacesAvailable = 0;
	    status = OPEN;
	    timestamp = "2016-10-26 12:09:30 +0000";


> ## `Event`
> > **`NSString *reference`** unique identifier that matches that of the Common record
> > 
> > **`NSDate *timestamp`** timestamp from CSE of last update to the record
> > 
> > **`NSDate *periodStart`** time the event starts
> > 
> > **`NSDate *periodEnd`** time the event ends
> > 
> > **`NSString *impactOnTraffic`** how traffic flow in the region of the event is affected
> > 
> > **`NSDate *overallStart`** same as periodStart
> > 
> > **`NSDate *overEnd`** same as PeriodEnd
> > 
> > **`NSString *validityStatus`** 
> >
	Example data
		reference = "GUIDBUCK-1786358096";
		impactOnTraffic = heavy;
		overEnd = "2016-12-22 21:30:00 +0000";
		overallStart = "2016-12-22 16:30:00 +0000";
		periodEnd = "2016-12-22 21:30:00 +0000";
		periodStart = "2016-12-22 16:30:00 +0000";
		timestamp = "2016-10-26 12:05:56 +0000";
		validityStatus = active;


> ## `Roadworks`
> > **`NSString *reference`** unique identifier that matches that of the Common record
> > 
> > **`NSString *comment`** description of the works to be carried out
> > 
> > **`NSString *effectOnRoadLayout`** how the traffic flow changes, if at all
> > 
> > **`NSString *roadMaintenanceType`** 
> > 
> > **`NSString *impactOnTraffic`** 
> > 
> > **`NSString *type`**
> > 
> > **`NSString *status`**
> > 
> > **`NSDate *overallStartTime`** when the roadworks were started
> > 
> > **`NSDate *overallEndTime`** scheduled end time
> > 
> > **`NSString *periods`**
> > 
> > **`NSDate *timestamp`** timestamp from CSE of last update to the record
> > 
	Example data
	    reference = "GUIDBUCK-01184645";
	    comment = "HIGHWAYS ACT PERMITS WORKS ON MANDEVILLE ROAD, AYLESBURY. NO C/W INCURSION";
	    effectOnRoadLayout = roadLayoutUnchanged;
	    impactOnTraffic = freeFlow;
	    overallEndTime = "2023-03-16 00:00:00 +0000";
	    overallStartTime = "2014-03-17 00:00:00 +0000";
	    periods = "2014-03-17T00:00:00";
	    roadMaintenanceType = other;
	    status = active;
	    timestamp = "2016-10-26 12:15:25 +0000";
	    type = other;

> ## `TrafficFlow` 
> > **`NSString *reference`** unique identifier that matches that of the Common record
> > 
> > **`NSDate *timestamp`** timestamp from CSE of last update to the record
> > 
> > **`NSNumber *vehicleFlow`** number of vehicles along the link per hour
> >
	Example data
		reference = "LINKBUCK-43:706:103";
		timestamp = "2016-10-26 12:11:00 +0000";
		vehicleFlow = 52;

> ## `TrafficQueue`
> > **`NSString *reference`** unique identifier that matches that of the Common record
> > 
> > **`NSDate *timestamp`** timestamp from CSE of last update to the record
> > 
> > **`NSNumber *severity`** **`NSInteger`** severity
> > 
> > **`NSString *present`** 'Y' if a queue exists, 'N' otherwise
> >
	Example data
		reference = "LINKBUCK-43:706:103";
		timestamp = "2016-10-26 12:11:00 +0000";
		severity = 1;
		present = Y;

> ## `TrafficScoot`
> > **`NSString *reference`** unique identifier that matches that of the Common record
> > 
> > **`NSDate *timestamp`** timestamp from CSE of last update to the record
> > 
> > **`NSNumber *averageSpeed`** **`NSInteger`** average speed of vehicles
> > 
> > **`NSNumber *congestionPercent`** **`float`** level of congestion on this link
> > 
> > **`NSNumber *currentFlow`** **`NSInteger`** vehicles per hour travelling along this link
> > 
> > **`NSNumber *linkTravelTime`**
> >
	Example data
		reference = "SECTIONBUCK-N01111A";
		averageSpeed = 80;
		congestionPercent = 0;
		currentFlow = 0;
		linkTravelTime = 0;
		timestamp = "2016-10-26 11:55:08 +0000";

> ## `TrafficSpeed`
> > **`NSString *reference`** unique identifier that matches that of the Common record
> > 
> > **`NSDate *timestamp`** timestamp from CSE of last update to the record
> > 
> > **`NSNumber *averageVehicleSpeed`** **`NSInteger`** average speed along this link in km/h
> > 
	Example data
	    reference = N33121J;
	    averageVehicleSpeed = 0;
	    timestamp = nil;

> ## `TrafficTravelTime`
> > **`NSString *reference`** unique identifier that matches that of the Common record
> > 
> > **`NSDate *timestamp`** timestamp from CSE of last update to the record
> > 
> > **`NSNumber *travelTime`** **`float`** actual time taken to traverse this link
> > 
> > **`NSNumber *freeFlowSpeed`** **`NSInteger`** best possible time given minimal congestion 
> > 
> > **`NSNumber *freeFlowTravelTime`** **`NSInteger`** best possible speed given minimal congestion
> > 
	Example data
	    reference = "SECTIONNHAM-010";
	    freeFlowSpeed = 0;
	    freeFlowTravelTime = 0;
	    timestamp = "2016-10-26 10:50:00 +0000";
	    travelTime = 39;

> ## `VariableMessageSign`
> > **`NSString *reference`** unique identifier that matches that of the Common record
> > 
> > **`NSDate *timestamp`** timestamp from CSE of last update to the record
> > 
> > **`NSString *legends`** lines of text currently displayed by this sign
> > 
> > **`NSString *type`**
> >
	Example data
	    reference = VMSCFB613DE807D3254E0433CC411ACFD01;
	    legends = "M6 J3A-J4A\n30 MIN DELAY";
	    timestamp = "2016-10-26 12:21:07 +0000";
	    type = other;

## Silverstone near-real-time and historical data

We have two groups of feeds supplied by Clearview and BitCarrier, for the
car parks and roads at Silverstone circuit.

Clearview has parking sensors located at the entrances to car parks at the
venue and BitCarrier has Bluetooth sensors on road junctions that can match
Bluetooth ids from in-car entertainment systems or passengers' mobile phones.

Both providers supply relatively static feeds describing the configuration
of devices, that only need to be consumed once, and dynamic feeds about the
current state of car parks and road networks that can be read repeatedly to
build up a continuous picture of traffic information.

In addition, we can supply a group of TSV files that contains historical data
for the weekends of the Formula One Grand Prix and Moto GP races in 2016.
You can add import this data into your app and continue to add to it with current
feed data if you like.

> ## `Device`
> > **`NSString *primary_id`** TSV line id
> > 
> > **`NSString *reference`** unique identifier for this car park sensor
> > 
> > **`NSString *title`** sensor name
> >  
> > **`NSString *comment`** describes the sensor location
> > 
> > **`NSString *type`** sensor part code
> > 
> > **`NSNumber *latitude`** **`double`** latitude of object
> > 
> > **`NSNumber *longitude`** **`double`** longitude of object
> > 
> > **`NSDate *changed`** timestamp the object was last changed
> > 
> > **`NSString *cin_id`** Content Instance id
> > 
> > **`NSDate *timestamp`**
> > 
	Example data
		primary_id = 5;
		reference = 1749;
		changed = nil;
		cin_id = cin19700513T15314311460703139872857749248;
		comment = "Site 5, Car Park Area 44";
		latitude = "52.070038";
		longitude = "-1.026317";
		timestamp = "2016-07-05 09:57:44 +0000";
		title = Silverstone05;
		type = M680;

> ## `Traffic`
> > **`NSString *primary_id`** TSV line id
> > 
> > **`NSString *reference`** sensor id
> > 
> > **`NSDate *timestamp`** timestamp the object was last changed
> > 
> > **`NSDate *creationtime`** timestamp the object was created
> > 
> > **`NSNumber *lane`** **`NSInteger`** lane in which the vehicle was detected
> > 
> > **`NSNumber *direction`** **`NSInteger`** 0 for entering, 1 for leaving
> > 
> > **`NSString *cin_id`** Content Instance id
> > 
	Example data
		primary_id = 38561;
		reference = 1748;
		cin_id = cin19721119T08034291008222140234941646592;
		creationtime = "2016-09-04 08:48:19 +0000";
		direction = 1;
		lane = 0;
		timestamp = "2016-09-04 09:49:47 +0000";


> ## `Node`
> > **`NSString *primary_id`** TSV line id
> > 
> > **`NSString *reference`** node id
> > 
> > **`NSString *customer_id`** customer id
> > 
> > **`NSString *customer_name`** unique identifier assigned by the implementer, usually containing a description of the location
> > 
> > **`NSNumber *latitude`** **`double`** latitude of this sensor
> > 
> > **`NSNumber *longitude`** **`double`** longitude of this sensor
> > 
> > **`NSDate *timestamp`** timestamp the object was last changed
> > 
> > **`NSString *cin_id`** Content Instance id
> > 
	Example data
		primary_id = 14;
		reference = 1172;
		cin_id = cin20010219T154146982597306139987234436864;
		customer_id = 27;
		customer_name = "27-Dadford Road (Silverstone Southern Roundabout)";
		latitude = "52.068155";
		longitude = "-1.025687";
		timestamp = "2016-08-17 00:00:11 +0000";


> ## `Sketch`
> > **`NSString *primary_id`** TSV line id
> > 
> > **`NSString *sketch_id`**
> > 
> > **`NSString *lat_lon_array`** JSON encoded array or latitude/longitude coordinates
> > 
> > **`NSString *level_of_service`** red, yellow or green, with red being the most congested and green being the least
> > 
> > **`NSString *vector_id`** vector id
> > 
> > **`NSString *cin_id`** Content Instance id
> > 
> > **`NSDate *timestamp`** timestamp the object was last changed
> >
	Example data
		primary_id = 43;
		sketch_id = 48;
		cin_id = cin19710905T19103852945838140490192189184;
		lat_lon_array = "[{\"lat\":51.99990999999999, \"lon\":-0.98785},{\"lat\":51.99992, \"lon\":-0.9877499999999999},{\"lat\":51.999799999999986, \"lon\":-0.98773},{\"lat\":51.99974999999999, \"lon\":-0.98773},{\"lat\":51.99965999999999, \"l";
		level_of_service = 1;
		timestamp = "2016-08-25 11:03:56 +0000";
		vector_id = 364;


> ## `Vector`
> > **`NSString *primary_id`** TSV line id
> > 
> > **`NSString *reference`** vector id
> > 
> > **`NSString *levelOfService`** red, yellow or green, with red being the most congested and green being the least
> > 
> > **`NSNumber *speed`** **`NSInteger`** speed
> > 
> > **`NSNumber *elapsedTime`** **`NSInteger`** elapsed time
> > 
> > **`NSString *cin_id`** Content Instance id
> > 
> > **`NSDate *timestamp`** timestamp the object was last changed
> > 
	Example data
		primary_id = 75255;
		reference = 278;
		cin_id = cin19990401T062150922947710139982983395072;
		elapsedTime = 0;
		levelOfService = green;
		speed = 0;
		timestamp = nil;

> ## `Config Vector`
> > **`NSString *primary_id`** TSV line id
> > 
> > **`NSString *reference`** vector id
> > 
> > **`NSString *name`**
> > 
> > **`NSString *customer_name`** location of this vector prefixed by a unique identifier
> > 
> > **`NSString *from_location`** start node of this vector
> > 
> > **`NSString *to_location`** end node of this vector
> > 
> > **`NSNumber *distance`** length of this link in kilometres
> > 
> > **`NSString *sketch_id`** identifier of the sketch pertaining to this vector
> > 
> > **`NSString *cin_id`** Content Instance id
> > 
> > **`NSDate *timestamp`** timestamp the object was last changed
> > 
	Example data
		primary_id = 8;
		reference = 277;
		cin_id = cin19760214T205051193179051140490192189184;
		customer_name = "Link_14->2";
		distance = 6224;
		from_location = 1165;
		name = 277;
		sketch_id = 2;
		timestamp = "2016-08-25 08:34:34 +0000";
		to_location = 1159;


> ## `Travel`
> > **`NSString *primary_id`** TSV line id
> > 
> > **`NSString *travel_summary_id`**
> > 
> > **`NSDate *clock_time`**
> > 
> > **`NSNumber *score`** **`float`**
> > 
> > **`NSNumber *speed`** **`float`** average speed in km/h along a link
> > 
> > **`NSNumber *elapsed`** **`float`** time taken to traverse this link
> > 
> > **`NSString *from_location`** a node customer id
> > 
> > **`NSString *to_location`** a node customer id
> > 
> > **`NSString *cin_id`** Content Instance id
> > 
> > **`NSNumber *trend`** **`float`**
> > 
> > **`NSDate *timestamp`** timestamp the object was last changed
> > 
	Example data
		primary_id = 225851;
		travel_summary_id = 10;
		cin_id = cin19861128T141131533571091139983576987392;
		clock_time = "2016-07-08 19:44:00 +0000";
		elapsed = 788;
		from_location = 10;
		score = 100;
		speed = "56.84163";
		timestamp = "2016-07-08 19:46:29 +0000";
		to_location = 27;
		trend = "-68.97638";



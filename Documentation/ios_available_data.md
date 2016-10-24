What data is available?
=======================

## Near-real-time local authority feeds

Data sources are provided by county and by data type, but note that there
is a fair amount of overlap between the regions and councils may control
items outside their boundaries.  For example, Northamptonshire has variable
message signs near Luton and Leicester.  We suggest consuming all the feeds
for the items in which you are interested and then filtering with a geonet
if needed.

Also, not every local authority provides every type of data.  These feeds are
available:

|                        | Bucks   | Herts   |Northants| Oxon    |Birmingham|
|------------------------|:-------:|:-------:|:-------:|:-------:|:--------:|
| Variable Message Signs |    X    |    X    |    X    |    X    |    X     |
| Car Parks              |    X    |    X    |    X    |    X    |    X     |
| Traffic Flow           |    X    |    X    |    X    |    X    |    X     |
| Traffic Queue          |    X    |    -    |    -    |    X    |    -     |
| Traffic Speed          |    X    |    X    |    -    |    X    |    X     |
| Traffic Scoot          |    X    |    X    |    -    |    X    |    X     |
| Traffic Time           |    X    |    X    |    X    |    X    |    X     |
| Roadworks              |    X    |    X    |    X    |    X    |    X     |
| Events                 |    X    |    X    |    -    |    X    |    -     |

The data types in each feed are common across counties, so a car park object from Bucks will be the same format as one from Northants.  Objects retrieved from a feed are generally indicative of the current situation, so if an average speed reading across a link is 40kph, then that was true when the last reading was observed a few minutes ago.  If an event occurs in a feed, then that event is happening now.

Here are some examples to show the structure for data classes:

> ### `Common`
> > **`NSString *reference`** unique identifier
> > 
> > **`NSDate *timestamp`** timestamp from CSE of last update to the record
> > 
> > **`NSNumber *latitude`** double latitude of object
> > 
> > **`NSNumber *longitude`** double longitude of object
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
> > **`NSNumber *latitudeTo`** double latitude of 2nd traffic location if available
> > 
> > **`NSNumber *longitudeTo`** double longitude of 2nd traffic location if available
> > 
> > **`NSString *typeSubFrom`** fromType for traffic
> > 
> > **`NSString *typeSubTo`** toType for traffic
> > 
> > **`NSString *titleTo`** name of the end of the link
> > 
> > **`NSString *tpegDirection`** tpegDirection for traffic
> > 
> > **`NSNumber *counter1`** NSInteger primary value to show on maps
> > 
> > **`NSNumber *counter2`** NSInteger secondary value to show on maps
> > 
> > **`NSNumber *angle`** float calculated angle between from and to coordinates


> ### `CarParks`

> > **`NSString *reference`** unique identifier that matches that of the Common record
> > 
> > **`NSDate *timestamp`** timestamp from CSE of last update to the record
> > 
> > **`NSNumber *capacity`** total capacity
> > 
> > **`NSNumber *spacesAvailable`** available spaces
> > 
> > **`NSNumber *rateExit`** cars leaving per hour
> > 
> > **`NSNumber *rateFill`** cars entering per hour
> > 
> > **`NSNumber *almostFullDec`** number of spaces below which 'almost full' becomes 'spaces available' as cars leave
> > 
> > **`NSNumber *almostFullInc`** number of spaces above which 'spaces available' becomes 'almost full' as cars enter
> > 
> > **`NSNumber *fullDec`** number of spaces below which 'full' becomes 'almost full' as cars leave
> > 
> > **`NSNumber *fullInc`** number of spaces below which 'full' becomes 'almost full' as cars enter
> > 
> > **`NSNumber *full`** number of spaces above which the car park is considered full (so the entrance sign lights up 'FULL')
> > 
> > **`NSNumber *occupancy`**
> > 
> > **`NSString *occupancyTrend`**
> > 
> > **`NSString *status`**
> > 
> > **`NSNumber *queuingTime`** current queuing time for car park entry


> ### `Event`
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


> ### `Roadworks`
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

> ### `TrafficFlow` 
> > **`NSString *reference`** unique identifier that matches that of the Common record
> > 
> > **`NSDate *timestamp`** timestamp from CSE of last update to the record
> > 
> > **`NSNumber *vehicleFlow`** number of vehicles along the link per hour

> ### `TrafficQueue`
> > **`NSString *reference`** unique identifier that matches that of the Common record
> > 
> > **`NSDate *timestamp`** timestamp from CSE of last update to the record
> > 
> > **`NSNumber *severity`** NSInteger severity
> > 
> > **`NSString *present`** 'Y' if a queue exists, 'N' otherwise

> ### `TrafficScoot`
> > **`NSString *reference`** unique identifier that matches that of the Common record
> > 
> > **`NSDate *timestamp`** timestamp from CSE of last update to the record
> > 
> > **`NSNumber *averageSpeed`** NSInteger average speed of vehicles
> > 
> > **`NSNumber *congestionPercent`** float level of congestion on this link
> > 
> > **`NSNumber *currentFlow`** NSInteger vehicles per hour travelling along this link
> > 
> > **`NSNumber *linkTravelTime`**

> ### `TrafficSpeed`
> > **`NSString *reference`** unique identifier that matches that of the Common record
> > 
> > **`NSDate *timestamp`** timestamp from CSE of last update to the record
> > 
> > **`NSNumber *averageVehicleSpeed`** NSInteger average speed along this link in km/h

> ### `TrafficTravelTime`
> > **`NSString *reference`** unique identifier that matches that of the Common record
> > 
> > **`NSDate *timestamp`** timestamp from CSE of last update to the record
> > 
> > **`NSNumber *travelTime`** float actual time taken to traverse this link
> > 
> > **`NSNumber *freeFlowSpeed`** NSInteger best possible time given minimal congestion 
> > 
> > **`NSNumber *freeFlowTravelTime`** NSInteger best possible speed given minimal congestion

> ### `VariableMessageSign`
> > **`NSString *reference`** unique identifier that matches that of the Common record
> > 
> > **`NSDate *timestamp`** timestamp from CSE of last update to the record
> > 
> > **`NSString *legends`** lines of text currently displayed by this sign
> > 
> > **`NSString *type`**

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

> ### `Device`
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
> > **`NSNumber *latitude`** double latitude of object
> > 
> > **`NSNumber *longitude`** double longitude of object
> > 
> > **`NSDate *changed`** timestamp the object was last changed
> > 
> > **`NSString *cin_id`**
> > 
> > **`NSDate *timestamp`**
> > 

> ### `Traffic`
> > **`NSString *primary_id`** TSV line id
> > 
> > **`NSString *reference`** sensor id
> > 
> > **`NSDate *timestamp`** timestamp the object was last changed
> > 
> > **`NSDate *creationtime`** timestamp the object was created
> > 
> > **`NSNumber *lane`** NSInteger lane in which the vehicle was detected
> > 
> > **`NSNumber *direction`** NSInteger 0 for entering, 1 for leaving
> > 
> > **`NSString *cin_id`**


> ### `Node`
> > **`NSString *primary_id`** TSV line id
> > 
> > **`NSString *reference`** node id
> > 
> > **`NSString *customer_id`** customer id
> > 
> > **`NSString *customer_name`** unique identifier assigned by the implementer, usually containing a description of the location
> > 
> > **`NSNumber *latitude`** double latitude of this sensor
> > 
> > **`NSNumber *longitude`** double longitude of this sensor
> > 
> > **`NSDate *timestamp`** timestamp the object was last changed
> > 
> > **`NSString *cin_id`**

> ### `Sketch`
> > **`NSString *primary_id`** TSV line id
> > 
> > **`NSString *lat_lon_array`**
> > 
> > **`NSString *level_of_service`** red, yellow or green, with red being the most congested and green being the least
> > 
> > **`NSString *vector_id`**
> > 
> > **`NSString *sketch_id`**
> > 
> > **`NSString *cin_id`**
> > 
> > **`NSDate *timestamp`** timestamp the object was last changed
> >

> ### `Vector`
> > **`NSString *primary_id`** TSV line id
> > 
> > **`NSString *reference`** vector id
> > 
> > **`NSString *levelOfService`** red, yellow or green, with red being the most congested and green being the least
> > 
> > **`NSNumber *speed`** NSInteger speed
> > 
> > **`NSNumber *elapsedTime`** NSInteger elapsed time
> > 
> > **`NSString *cin_id`**
> > 
> > **`NSDate *timestamp`** timestamp the object was last changed

> ### `Config Vector`
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
> > **`NSString *cin_id`**
> > 
> > **`NSDate *timestamp`** timestamp the object was last changed

> ### `Travel`
> > **`NSString *primary_id`** TSV line id
> > 
> > **`NSString *travel_summary_id`**
> > 
> > **`NSDate *clock_time`**
> > 
> > **`NSNumber *score`** float
> > 
> > **`NSNumber *speed`** float average speed in km/h along a link
> > 
> > **`NSNumber *elapsed`** float time taken to traverse this link
> > 
> > **`NSString *from_location`** a node customer id
> > 
> > **`NSString *to_location`** a node customer id
> > 
> > **`NSString *cin_id`**
> > 
> > **`NSNumber *trend`** float
> > 
> > **`NSDate *timestamp`** timestamp the object was last changed


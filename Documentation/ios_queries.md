# CoreData queries
If you run requests, it is then possible to apply CoreData queries to the data sets

Custom queries are possible using standard NSPredicate objects and the helper retrieval methods in the oneTRANSPORT framework.

Example 1 - to extract ClearView traffic sensor 1747 data for yesterday:

	let calendar = Calendar(identifier: .gregorian)

	let ref = "1747"
	let DateFrom = calendar.startOfDay(for: calendar.date(byAdding: .day, value: -1, to: Date())!)
	let dateTo = calendar.startOfDay(for: Date())

	let predicate = NSPredicate.init(format:"reference == %@ && timestamp >= %@ && timestamp < %@",	ref, dateFrom as CVarArg, dateTo as CVarArg)
	let array = OTSingleton.sharedInstance().clearViewTraffic.retrieveSummary(predicate)
	
	Exmaple record:
		cin_id = cin19790616T082638298369598139983551809280;
		creationtime = "2016-07-09 07:09:50 +0000";
		direction = 0;
		lane = 1;
		primary_id = 118895;
		reference = 1753;
		timestamp = "2016-07-09 08:08:14 +0000";


Example 2 - to extract newly started roadworks

	let Date = calendar.startOfDay(for: calendar.date(byAdding: .day, value: -1, to: Date())!)
	let predicate = NSPredicate.init(format: "overallStartTime > %@", date as CVarArg)
	let array = OTSingleton.sharedInstance().roadworks.retrieveAll(predicate)
	print ("Current roadworks \(array)")
	
	Example record:
	    comment = "Dig out Setts and remove soil, , WOODSTOCK ROAD, YARNTON,";
	    effectOnRoadLayout = roadLayoutUnchanged;
	    impactOnTraffic = heavy;
	    overallEndTime = "2016-10-28 23:59:59 +0000";
	    overallStartTime = "2016-10-26 00:00:00 +0000";
	    periods = "2016-10-26T00:00:00";
	    reference = "GUIDOXFO-north-20121395";
	    roadMaintenanceType = other;
	    status = active;
	    timestamp = "2016-10-26 08:36:32 +0000";
	    type = other;



Predicates can also be applied directly to the data set using your own CoreData methods. Initialise the managed object context and create a simple fetch request as follows:

Objective-C
	
	OTSingleton *singleton = [OTSingleton sharedInstance];
	NSManagedObjectContext *moc = [singleton.coreData managedObjectContext];
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:singleton.carParks.entityName];
	NSArray *array = [moc executeFetchRequest:fetchRequest error:nil];
	NSLog(@"%@", array);
	
Swift

	let singleton = OTSingleton.sharedInstance()
	let moc = singleton.coreData.managedObjectContext()
	let fetchRequest : NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: singleton.carParks.entityName)
	do {
	    let array = try moc?.execute(fetchRequest)
	    print (array)
	} catch let error {
	    print (error)
	}

From this simple request, you can apply standard NSPredicate objects.
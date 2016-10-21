CoreData queries
================

Custom queries are possible using standard NSPredicate objects and the helper retrieval methods in the oneTRANSPORT framework.

For example, to extract ClearView traffic sensor 1747 data for yesterday:

	let calendar = Calendar(identifier: .gregorian)

	let ref = "1747"
	let DateFrom = calendar.startOfDay(for: calendar.date(byAdding: .day, value: -1, to: Date())!)
	let dateTo = calendar.startOfDay(for: Date())

	let predicate = NSPredicate.init(format:"reference == %@ && timestamp >= %@ && timestamp < %@",	ref, dateFrom as CVarArg, dateTo as CVarArg)
	let array = OTSingleton.sharedInstance().clearViewTraffic.retrieveSummary(predicate)


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
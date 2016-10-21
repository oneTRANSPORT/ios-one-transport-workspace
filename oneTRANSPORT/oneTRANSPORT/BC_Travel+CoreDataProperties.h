//
//  BC_Travel+CoreDataProperties.h
//  
//
//  Created by Dominic Frazer Imregh on 06/09/2016.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "BC_Travel.h"

NS_ASSUME_NONNULL_BEGIN

@interface BC_Travel (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *primary_id;
@property (nullable, nonatomic, retain) NSString *travel_summary_id;
@property (nullable, nonatomic, retain) NSDate *timestamp;
@property (nullable, nonatomic, retain) NSDate *clock_time;
@property (nullable, nonatomic, retain) NSNumber *score;
@property (nullable, nonatomic, retain) NSNumber *speed;
@property (nullable, nonatomic, retain) NSNumber *elapsed;
@property (nullable, nonatomic, retain) NSString *from_location;
@property (nullable, nonatomic, retain) NSString *to_location;
@property (nullable, nonatomic, retain) NSString *cin_id;
@property (nullable, nonatomic, retain) NSNumber *trend;

@end

NS_ASSUME_NONNULL_END

//
//  BC_Sketch+CoreDataProperties.h
//  
//
//  Created by Dominic Frazer Imregh on 06/09/2016.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "BC_Sketch.h"

NS_ASSUME_NONNULL_BEGIN

@interface BC_Sketch (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *primary_id;
@property (nullable, nonatomic, retain) NSString *lat_lon_array;
@property (nullable, nonatomic, retain) NSString *level_of_service;
@property (nullable, nonatomic, retain) NSString *vector_id;
@property (nullable, nonatomic, retain) NSString *sketch_id;
@property (nullable, nonatomic, retain) NSString *cin_id;
@property (nullable, nonatomic, retain) NSDate *timestamp;

@end

NS_ASSUME_NONNULL_END

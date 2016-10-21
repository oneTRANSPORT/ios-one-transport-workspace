//
//  BC_Node+CoreDataProperties.h
//  
//
//  Created by Dominic Frazer Imregh on 06/09/2016.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "BC_Node.h"

NS_ASSUME_NONNULL_BEGIN

@interface BC_Node (CoreDataProperties)

@property (nonnull, nonatomic, retain)  NSString *reference;
@property (nullable, nonatomic, retain) NSString *customer_id;
@property (nullable, nonatomic, retain) NSString *customer_name;
@property (nullable, nonatomic, retain) NSString *cin_id;
@property (nullable, nonatomic, retain) NSNumber *latitude;
@property (nullable, nonatomic, retain) NSNumber *longitude;
@property (nullable, nonatomic, retain) NSDate *timestamp;
@property (nullable, nonatomic, retain) NSString *primary_id;

@end

NS_ASSUME_NONNULL_END

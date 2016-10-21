//
//  BC_Vector+CoreDataProperties.h
//  
//
//  Created by Dominic Frazer Imregh on 06/09/2016.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "BC_Vector.h"

NS_ASSUME_NONNULL_BEGIN

@interface BC_Vector (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *primary_id;
@property (nonnull, nonatomic, retain)  NSString *reference;
@property (nullable, nonatomic, retain) NSString *levelOfService;
@property (nullable, nonatomic, retain) NSNumber *speed;
@property (nullable, nonatomic, retain) NSNumber *elapsedTime;
@property (nullable, nonatomic, retain) NSString *cin_id;
@property (nullable, nonatomic, retain) NSDate   *timestamp;

@end

NS_ASSUME_NONNULL_END

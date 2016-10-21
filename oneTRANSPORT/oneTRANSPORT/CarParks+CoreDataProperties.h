//
//  CarParks+CoreDataProperties.h
//  oneTRANSPORT
//
//  Created by Dominic Frazer Imregh on 16/08/2016.
//  Copyright 2016 InterDigital Communications, Inc.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//    http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "CarParks.h"

NS_ASSUME_NONNULL_BEGIN

@interface CarParks (CoreDataProperties)

@property (nonnull, nonatomic, retain)  NSString *reference;
@property (nullable, nonatomic, retain) NSNumber *capacity;
@property (nullable, nonatomic, retain) NSNumber *spacesAvailable;
@property (nullable, nonatomic, retain) NSNumber *rateExit;
@property (nullable, nonatomic, retain) NSNumber *rateFill;
@property (nullable, nonatomic, retain) NSNumber *almostFullDec;
@property (nullable, nonatomic, retain) NSNumber *almostFullInc;
@property (nullable, nonatomic, retain) NSNumber *fullDec;
@property (nullable, nonatomic, retain) NSNumber *fullInc;
@property (nullable, nonatomic, retain) NSNumber *full;
@property (nullable, nonatomic, retain) NSDate *timestamp;
@property (nullable, nonatomic, retain) NSNumber *occupancy;
@property (nullable, nonatomic, retain) NSString *occupancyTrend;
@property (nullable, nonatomic, retain) NSString *status;
@property (nullable, nonatomic, retain) NSNumber *queuingTime;

@end

NS_ASSUME_NONNULL_END

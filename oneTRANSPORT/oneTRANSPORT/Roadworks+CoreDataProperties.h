//
//  Roadworks+CoreDataProperties.h
//  oneTRANSPORT
//
//  Created by Dominic Frazer Imregh on 18/08/2016.
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

#import "Roadworks.h"

NS_ASSUME_NONNULL_BEGIN

@interface Roadworks (CoreDataProperties)

@property (nonnull, nonatomic, retain)  NSString *reference;
@property (nullable, nonatomic, retain) NSString *comment;
@property (nullable, nonatomic, retain) NSString *effectOnRoadLayout;
@property (nullable, nonatomic, retain) NSString *roadMaintenanceType;
@property (nullable, nonatomic, retain) NSString *impactOnTraffic;
@property (nullable, nonatomic, retain) NSString *type;             //TODO - remove?
@property (nullable, nonatomic, retain) NSString *status;           //TODO - remove?
@property (nullable, nonatomic, retain) NSDate *overallStartTime;   //TODO - remove?
@property (nullable, nonatomic, retain) NSDate *overallEndTime;     //TODO - remove?
@property (nullable, nonatomic, retain) NSString *periods;          //TODO - remove?
@property (nullable, nonatomic, retain) NSDate *timestamp;

@end

NS_ASSUME_NONNULL_END

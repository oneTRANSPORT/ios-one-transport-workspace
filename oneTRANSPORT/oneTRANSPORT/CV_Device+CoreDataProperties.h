//
//  CV_Device+CoreDataProperties.h
//  oneTRANSPORT
//
//  Created by Dominic Frazer Imregh on 12/09/2016.
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

#import "CV_Device.h"

NS_ASSUME_NONNULL_BEGIN

@interface CV_Device (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *primary_id;
@property (nonnull, nonatomic, retain)  NSString *reference;
@property (nullable, nonatomic, retain) NSString *title;
@property (nullable, nonatomic, retain) NSString *comment;
@property (nullable, nonatomic, retain) NSString *type;
@property (nullable, nonatomic, retain) NSNumber *latitude;
@property (nullable, nonatomic, retain) NSNumber *longitude;
@property (nullable, nonatomic, retain) NSDate *changed;
@property (nullable, nonatomic, retain) NSString *cin_id;
@property (nullable, nonatomic, retain) NSDate *timestamp;

@end

NS_ASSUME_NONNULL_END

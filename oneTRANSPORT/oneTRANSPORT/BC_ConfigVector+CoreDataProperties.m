//
//  BC_ConfigVector+CoreDataProperties.m
//  oneTRANSPORT
//
//  Created by Dominic Frazer Imregh on 09/09/2016.
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

#import "BC_ConfigVector+CoreDataProperties.h"

@implementation BC_ConfigVector (CoreDataProperties)

@dynamic primary_id;
@dynamic reference;
@dynamic name;
@dynamic customer_name;
@dynamic from_location;
@dynamic to_location;
@dynamic distance;
@dynamic sketch_id;
@dynamic cin_id;
@dynamic timestamp;

@end

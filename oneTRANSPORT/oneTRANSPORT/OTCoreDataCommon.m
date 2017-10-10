//
//  OTCoreDataCommon.m
//  oneTRANSPORT
//
//  Created by Dominic Frazer Imregh on 30/08/2016.
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

#import "OTCoreDataCommon.h"
#import "OTCoreDataBase+Private.h"
#import "OTCoreData+Private.h"
#import "NSObject+Collection.h"
#import "OTTransportTypes.h"

@implementation OTCoreDataCommon

- (instancetype)initWithCoreData:(id)parent {
    
    if (self = [super initWithCoreData:parent]) {
        self.entityName = kCoreDataEntityCommon;
    }
    return self;
}

- (void)populateTableWith:(id)data type:(NSString *)type {
        
    NSError *error = nil;
    NSManagedObjectContext *moc = [self.coreData managedObjectContext];    
    Common *object;
    
    NSPredicate *predicate;
    NSFetchRequest *fetchRequest = [self getFetchRequest];
    [fetchRequest setFetchLimit:1];
    
    NSArray *array = data;
    for (NSDictionary *item in array) {
        NSString *reference = [NSObject validateString:item[kCommonReference]];
        
        predicate = [NSPredicate predicateWithFormat:@"reference == %@ && type == %@", reference, type];
        [fetchRequest setPredicate:predicate];
        
        NSArray *arrayExisting = [moc executeFetchRequest:fetchRequest error:&error];
        if ([arrayExisting count]) {
            object = arrayExisting[0];
        } else {
            object = [NSEntityDescription insertNewObjectForEntityForName:self.entityName inManagedObjectContext:moc];
            object.reference      = reference;
            object.type           = type;
        }
        object.timestamp          = item[kCommonTimestamp];
        object.latitude           = [NSObject validateNumberDouble:item[kCommonLat]];
        object.longitude          = [NSObject validateNumberDouble:item[kCommonLon]];
        if ([item[kCommonTitle] length] > 0) {
            object.title = item[kCommonTitle];
        }
        object.latitudeTo         = [NSObject validateNumberDouble:item[kCommonLatTo]];
        object.longitudeTo        = [NSObject validateNumberDouble:item[kCommonLonTo]];
        if ([item[kCommonTitleTo] length] > 0) {
            object.titleTo = item[kCommonTitleTo];
        }
        object.tpegDirection      = item[kCommonTpegDir];
        object.typeSubFrom        = [NSObject validateString:item[kCommonTypeFrom]];
        object.typeSubTo          = [NSObject validateString:item[kCommonTypeTo]];
        object.counter1           = [NSObject validateNumberInt:item[kCommonCounter1]];
        object.counter2           = [NSObject validateNumberInt:item[kCommonCounter2]];
       
        if (object.latitudeTo.floatValue != 0.0) {
            float diffLon = object.longitudeTo.floatValue - object.longitude.floatValue;
            float y = sinf(diffLon);
            float x = cosf(object.latitude.floatValue) * sinf(object.latitudeTo.floatValue) -
                        sinf(object.latitude.floatValue) * cosf(object.latitudeTo.floatValue) * cosf(diffLon);
            float angle = atan2f(y, x);
            object.angle          = @(angle);
        } else {
            object.angle          = @(0.0);
        }
    }
    [self.coreData saveContext];
}

- (void)removeReference:(NSString *)reference type:(NSString *)type {
    
    NSError *error = nil;
    NSManagedObjectContext *moc = [self.coreData managedObjectContext];
    
    NSFetchRequest *fetchRequest = [self getFetchRequest];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"reference == %@ && type == %@", reference, type];
    [fetchRequest setPredicate:predicate];

    NSArray *array = [moc executeFetchRequest:fetchRequest error:&error];
    for (Common *object in array) {
        [moc deleteObject:object];
    }
    [self.coreData saveContext];
}

- (NSArray <Common *> *)retrieveAll:(NSString *)queryString {
    
    NSPredicate *predicate = nil;
    if (queryString) {
        predicate = [NSPredicate predicateWithFormat:queryString];
    }
    return [super retrieveAll:predicate];
}

- (NSString *)objectTypeAsString:(ObjectType)type {
    
    NSString *typeString;
    switch (type) {
        case ObjectTypeVariableMessageSigns:
            typeString = k_CommonType_VariableMS;
            break;
        case ObjectTypeTrafficFlow:
            typeString = k_CommonType_TrafficFlow;
            break;
        case ObjectTypeTrafficQueue:
            typeString = k_CommonType_TrafficQueue;
            break;
        case ObjectTypeTrafficSpeed:
            typeString = k_CommonType_TrafficSpeed;
            break;
        case ObjectTypeTrafficScoot:
            typeString = k_CommonType_TrafficScoot;
            break;
        case ObjectTypeTrafficTime:
            typeString = k_CommonType_TrafficTime;
            break;
        case ObjectTypeCarParks:
            typeString = k_CommonType_CarParks;
            break;
        case ObjectTypeRoadworks:
            typeString = k_CommonType_Roadworks;
            break;
        case ObjectTypeEvents:
            typeString = k_CommonType_Events;
            break;
        case ObjectTypeBitCarrier:
            typeString = k_CommonType_BitCarrierNode;
            break;
            
        default:
            typeString = k_CommonType_CarParks;
            break;
    }
    return typeString;
}

- (ObjectType)objectTypeFromString:(NSString *)typeString {
    
    ObjectType type;
    if ([typeString isEqualToString:k_CommonType_VariableMS]) {
        type = ObjectTypeVariableMessageSigns;
    } else if ([typeString isEqualToString:k_CommonType_TrafficFlow]) {
        type = ObjectTypeTrafficFlow;
    } else if ([typeString isEqualToString:k_CommonType_TrafficQueue]) {
        type = ObjectTypeTrafficQueue;
    } else if ([typeString isEqualToString:k_CommonType_TrafficSpeed]) {
        type = ObjectTypeTrafficSpeed;
    } else if ([typeString isEqualToString:k_CommonType_TrafficScoot]) {
        type = ObjectTypeTrafficScoot;
    } else if ([typeString isEqualToString:k_CommonType_TrafficTime]) {
        type = ObjectTypeTrafficTime;
    } else if ([typeString isEqualToString:k_CommonType_CarParks]) {
        type = ObjectTypeCarParks;
    } else if ([typeString isEqualToString:k_CommonType_Roadworks]) {
        type = ObjectTypeRoadworks;
    } else if ([typeString isEqualToString:k_CommonType_Events]) {
        type = ObjectTypeEvents;
    } else if ([typeString isEqualToString:k_CommonType_BitCarrierNode]) {
        type = ObjectTypeBitCarrier;
    } else { //if ([typeString isEqualToString:k_CommonType_ClearViewDevice]) {
        type = ObjectTypeClearView;
    }
    return type;
}

- (NSArray <Common *> * _Nonnull)retrieveType:(ObjectType)type {
    
    NSString *queryString = [NSString stringWithFormat:@"type == '%@'", [self objectTypeAsString:type]];
    return [self retrieveAll:queryString];
}

- (NSArray <Common *> * _Nonnull)retrieveType:(ObjectType)type topLeft:(CLLocationCoordinate2D)topLeft bottomRight:(CLLocationCoordinate2D)bottomRight {
    
    NSString *queryString = [NSString stringWithFormat:@"type == '%@' && latitude <= %.4f && longitude >= %.4f && latitude >= %.4f && longitude <= %.4f",
                             [self objectTypeAsString:type], topLeft.latitude, topLeft.longitude, bottomRight.latitude, bottomRight.longitude];
    return [self retrieveAll:queryString];

}

- (Common *)retrieve:(NSString *)reference type:(ObjectType)type {
    
    NSError *error = nil;
    NSManagedObjectContext *moc = [self.coreData managedObjectContext];
    
    NSFetchRequest *fetchRequest = [self getFetchRequest];
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"reference == %@ && type == %@", reference, [self objectTypeAsString:type]]];
    NSArray *array = [moc executeFetchRequest:fetchRequest error:&error];
    if (array.count > 0) {
        return array[0];
    } else {
        return nil;
    }
}

- (bool)isFavourite:(NSString *)reference type:(ObjectType)type {
    
    Common *object = [self retrieve:reference type:type];
    if (object) {
        return object.favourite.boolValue;
    } else {
        return false;
    }
}

- (void)setFavourite:(NSString *)reference type:(ObjectType)type set:(BOOL)set {
    
    Common *object = [self retrieve:reference type:type];
    if (object) {
        object.favourite = @(set);
        [[self.coreData managedObjectContext] save:nil];
    }
}

//SELECT 'latitude', 'longitude', 'reference', 'direction', COUNT(*) FROM 'CV_Traffic' GROUP BY 'creationtime, direction'
- (NSArray <NSDictionary *> *)retrieveDuplicates:(NSPredicate *)predicate {
    
    NSError *error = nil;
    NSManagedObjectContext *moc = [self.coreData managedObjectContext];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:self.entityName];
    if (predicate) {
        [fetchRequest setPredicate:predicate];
    }
    
    NSExpression *keyPathExpression1 = [NSExpression expressionForKeyPath:@"latitude"];
    NSExpression *countExpression = [NSExpression expressionForFunction:@"count:" arguments:@[keyPathExpression1]];
    
    NSExpressionDescription *expressionDescription = [NSExpressionDescription new];
    [expressionDescription setName:@"counter"];
    [expressionDescription setExpression:countExpression];
    [expressionDescription setExpressionResultType:NSInteger32AttributeType];
    
    [fetchRequest setPropertiesToFetch:@[@"latitude", expressionDescription]];
    [fetchRequest setReturnsDistinctResults:YES];
    
    [fetchRequest setPropertiesToGroupBy:@[@"latitude"]];
    [fetchRequest setResultType:NSDictionaryResultType];
    
    NSArray *results = [moc executeFetchRequest:fetchRequest error:&error];
    return results;
}

@end

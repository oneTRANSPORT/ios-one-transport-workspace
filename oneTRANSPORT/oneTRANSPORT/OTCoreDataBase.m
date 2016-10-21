//
//  OTCoreDataBase.m
//  oneTRANSPORT
//
//  Created by Dominic Frazer Imregh on 19/08/2016.
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

#import "OTCoreDataBase+Private.h"
#import "OTCoreData+Private.h"
#import "OTTransportTypes.h"
#import <CoreLocation/CLLocation.h>
#import "OTSingleton.h"
#import "NSObject+Collection.h"

@interface OTCoreDataBase()

@property (nonatomic) CLLocationCoordinate2D min;
@property (nonatomic) CLLocationCoordinate2D max;

@end

@implementation OTCoreDataBase

- (instancetype)initWithCoreData:(id)parent {

    if (self = [super init]) {
        _coreData = parent;
    }
    return self;
}

- (BOOL)isAllowedToMakeRequest:(LocalAuthority)la {

    return ([[NSUserDefaults standardUserDefaults] boolForKey:self.userDefaultsUse]);
}

- (NSFetchRequest *)getFetchRequest {

    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:self.entityName];
    [fetchRequest setReturnsObjectsAsFaults:false];
    return fetchRequest;
}

- (NSDate *)getCurrentTimestamp {
    
    NSDate *date = [[NSUserDefaults standardUserDefaults] valueForKey:self.userDefaultsCurrentData];
    if (date == nil) {
        date = [NSDate dateWithTimeIntervalSince1970:0];
    }
    return date;
}

- (void)setTimestamp:(NSDate *)date {
    
    [[NSUserDefaults standardUserDefaults] setValue:date forKey:self.userDefaultsCurrentData];
}

- (void)setImportFilter {
    
    _min = [[OTSingleton sharedInstance] getMinImportFilter];
    _max = [[OTSingleton sharedInstance] getMaxImportFilter];
}

- (BOOL)validForImport:(NSNumber *)lat lon:(NSNumber *)lon {
    
    double dblLat = lat.doubleValue;
    double dblLon = lon.doubleValue;
    
    if (dblLat == 0.0 && dblLon == 0.0) {
        return false;
    }
    
    if (_min.latitude >= dblLat && _min.longitude <= dblLon && _max.latitude <= dblLat && _max.longitude >= dblLon) {
        return true;
    }

    return false;
}

- (void)setupLat:(NSNumber **)latitude lon:(NSNumber **)longitude from:(NSDictionary *)item {
    
    *latitude = [NSObject validateNumberDouble:item[@"toLatitude"]];
    *longitude = [NSObject validateNumberDouble:item[@"toLongitude"]];
    NSInteger lon = [*longitude integerValue];
    if ((lon == 0 || lon > 1000) && item[@"latitude"]) {
        *latitude = [NSObject validateNumberDouble:item[@"latitude"]];
        *longitude = [NSObject validateNumberDouble:item[@"longitude"]];
    }
    lon = [*longitude integerValue];
    if ((lon == 0 || lon > 1000) && item[@"fromLatitude"]) {
        *latitude = [NSObject validateNumberDouble:item[@"fromLatitude"]];
        *longitude = [NSObject validateNumberDouble:item[@"fromLongitude"]];
    }
}

- (NSInteger)retrieveRecordCount {
    
    NSError *error = nil;
    NSManagedObjectContext *moc = [self.coreData managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:self.entityName];
    NSArray *array = [moc executeFetchRequest:fetchRequest error:&error];
    return array.count;
}

- (NSArray *)retrieveAll:(NSPredicate *)predicateAnd {
    
    NSDate *currentData;
    if (self.userDefaultsCurrentData) {
        currentData = [[NSUserDefaults standardUserDefaults] valueForKey:self.userDefaultsCurrentData];
    }
    NSError *error = nil;
    NSManagedObjectContext *moc = [self.coreData managedObjectContext];
    
    NSFetchRequest *fetchRequest = [self getFetchRequest];
    
    NSPredicate *predicate;
    if (currentData) {
        NSSortDescriptor *sort1 = [[NSSortDescriptor alloc] initWithKey:@"timestamp" ascending:false];
        [fetchRequest setSortDescriptors:@[sort1]];
    }
    if (predicateAnd) {
        if (predicate) {
            predicate = [NSCompoundPredicate andPredicateWithSubpredicates:@[predicate, predicateAnd]];
        } else {
            predicate = predicateAnd;
        }
    }
    if (predicate) {
        [fetchRequest setPredicate:predicate];
    }
    
    NSArray *array = [moc executeFetchRequest:fetchRequest error:&error];
    return array;
}

- (NSArray *)retrieveHistory:(NSString *)reference {
    
    NSError *error = nil;
    NSManagedObjectContext *moc = [self.coreData managedObjectContext];
    
    NSFetchRequest *fetchRequest = [self getFetchRequest];
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"reference == %@", reference]];
    if (self.userDefaultsCurrentData) {
        NSSortDescriptor *sort1 = [[NSSortDescriptor alloc] initWithKey:@"timestamp" ascending:false];
        [fetchRequest setSortDescriptors:@[sort1]];
    }
    [fetchRequest setFetchLimit:999];
    
    NSArray *array = [moc executeFetchRequest:fetchRequest error:&error];
    return array;
}

- (void)removeAll {
    
    NSError *error = nil;
    NSManagedObjectContext *moc = [self.coreData managedObjectContext];
    
    NSFetchRequest *fetchRequest = [self getFetchRequest];
    
    NSArray *array = [moc executeFetchRequest:fetchRequest error:&error];
    for (id object in array) {
        [moc deleteObject:object];
    }
    [self.coreData saveContext];
}

- (void)removeOld {
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSDate *currentData = [userDefaults valueForKey:self.userDefaultsCurrentData];
    
    NSError *error = nil;
    NSManagedObjectContext *moc = [self.coreData managedObjectContext];
    
    NSFetchRequest *fetchRequest = [self getFetchRequest];
    
    if (currentData) {
        NSInteger hours = [userDefaults integerForKey:kUserDefaultsDataAge];
        NSDate *expireDate = [currentData dateByAddingTimeInterval:-hours * 60 * 60];
        [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"timestamp < %@", expireDate]];
    }
    NSArray *array = [moc executeFetchRequest:fetchRequest error:&error];
    for (id object in array) {
        [moc deleteObject:object];
    }
    [self.coreData saveContext];
}

#pragma mark - Empty methods that need instances in child classes

- (NSArray *)populateTableWith:(id)data timestamp:(NSDate *)date { return nil; }

- (NSArray *)checkForChanges:(NSArray <NSDictionary *> *)arrayCommon { return nil; }

@end

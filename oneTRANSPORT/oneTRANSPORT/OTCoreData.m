//
//  OTCoreData.m
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

#import "OTCoreData+Private.h"

@interface OTCoreData()

@property (nonatomic, strong) NSManagedObjectContext *mainContext;

@end

@implementation OTCoreData

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (id)init {
    
    if (self = [super init]) {

    }
    return self;
}

#pragma mark - Core Data stack

#define kThreadMoc      @"ThreadMoc"

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext {
    
    if ([NSThread isMainThread]) {
        if (!_mainContext) {
            _mainContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
            [_mainContext setPersistentStoreCoordinator:[self persistentStoreCoordinator]];
            [_mainContext setMergePolicy:NSMergeByPropertyObjectTrumpMergePolicy];
            
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(contextWillSave:) name:NSManagedObjectContextWillSaveNotification object:_mainContext];
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(contextHasChanged:) name:NSManagedObjectContextDidSaveNotification object:_mainContext];
        }
        return _mainContext;
    } else {
        if (!_mainContext) {    //ensure that there is a parent context before continuing
            dispatch_sync(dispatch_get_main_queue(), ^{
                [self managedObjectContext];
            });
        }
        NSManagedObjectContext *newMoc = [[[NSThread currentThread] threadDictionary] objectForKey:kThreadMoc];
        if (!newMoc) {
            newMoc = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
            [newMoc setParentContext:_mainContext];
            [newMoc setMergePolicy:NSMergeByPropertyObjectTrumpMergePolicy];
            
            [[[NSThread currentThread] threadDictionary] setObject:newMoc forKey:kThreadMoc];
            
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(contextWillSave:) name:NSManagedObjectContextWillSaveNotification object:newMoc];
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(contextHasChanged:) name:NSManagedObjectContextDidSaveNotification object:newMoc];
        }
        return newMoc;
    }
}

- (void)contextWillSave:(NSNotification*)notification {

    NSManagedObjectContext *context = [notification object];
    NSSet *insertedObjects = [context insertedObjects];
    
    if ([insertedObjects count])
    {
        NSError *error = nil;
        BOOL success = [context obtainPermanentIDsForObjects:[insertedObjects allObjects] error:&error];
        if (!success)
        {
            NSLog(@"Failed to obtainPermanentIDsForObjects");
            NSLog(@"%@", error);
        }
    }
}

- (void)contextHasChanged:(NSNotification*)notification {
    
    if ([NSThread isMainThread]) {
        [self.managedObjectContext mergeChangesFromContextDidSaveNotification:notification];
    } else {
        dispatch_sync(dispatch_get_main_queue(), ^{
            [self contextHasChanged:notification];
            [self.managedObjectContext save:nil];
        });
    }
}

- (BOOL)saveContext {
    
    BOOL ok = true;
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        [NSThread sleepForTimeInterval:0.001];
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            ok = false;
        }
        [managedObjectContext refreshAllObjects];
    }
    return ok;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel {

    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle bundleForClass:[self class]] URLForResource:@"OneTransport" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
//    [self removeOldCoreData];     //testing only
    
    NSURL *storeURL = [self urlCoreDataDirectory];
    storeURL = [storeURL URLByAppendingPathComponent:@"OneTransport.sqlite"];
    NSLog(@"\n\n>>>>\nCoreData Location\n%@\n>>>>\n\n", storeURL);
    
    NSError *error = nil;
    NSManagedObjectModel *model = [self managedObjectModel];
    if (model) {
        _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model];
        NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
                                 @YES, NSMigratePersistentStoresAutomaticallyOption,
                                 @YES, NSInferMappingModelAutomaticallyOption,nil];
        
        if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:options error:&error]) {
            //delete for now... and try again
            [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil];
            _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
            if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:options error:&error]) {
//                DLog(@"Unresolved error %@, %@", error, [error userInfo]);
//                abort();
            }
        }
    }
    
    return _persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)urlCoreDataDirectory {
    
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (void)removeOldCoreData {
    
    NSString *pathDoc = [self urlCoreDataDirectory].absoluteString;
    NSString *filePath = [NSString stringWithFormat:@"%@/OneTransport.sqlite", pathDoc];
    
    [[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];
}

@end

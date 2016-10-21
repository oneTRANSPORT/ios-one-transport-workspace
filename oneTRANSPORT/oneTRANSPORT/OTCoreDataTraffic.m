//
//  OTCoreDataTraffic.m
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

#import "OTCoreDataTraffic+Private.h"
#import "OTCoreData+Private.h"
#import "NSObject+Collection.h"
#import "OTTransportTypes.h"
#import "OTCoreDataBase+Private.h"

@interface OTCoreDataTraffic()

@property (nonatomic, strong) NSDateFormatter *formatter;

@end

@implementation OTCoreDataTraffic

- (instancetype)initWithCoreData:(id)parent {
    
    if (self = [super initWithCoreData:parent]) {
        self.userDefaultsCurrentData = kUserDefaultsStampTraffic;
   }
    return self;
}

- (NSMutableDictionary *)buildCommon:(NSDictionary *)item lat:(NSNumber *)latitude lon:(NSNumber *)longitude {
    
    NSString *reference = [NSObject validateString:item[@"id"]];

    NSMutableDictionary *dict = [NSMutableDictionary new];
    [dict setValue:reference forKey:kCommonReference];
    [dict setValue:[NSObject validateString:item[@"fromDescriptor"]] forKey:kCommonTitle];
    [dict setValue:latitude forKey:kCommonLat];
    [dict setValue:longitude forKey:kCommonLon];
    [dict setValue:[NSObject validateNumberDouble:item[@"toLatitude"]] forKey:kCommonLatTo];
    [dict setValue:[NSObject validateNumberDouble:item[@"toLongitude"]] forKey:kCommonLonTo];
    [dict setValue:[NSObject validateString:item[@"toDescriptor"]] forKey:kCommonTitleTo];
    [dict setValue:[NSObject validateString:item[@"toType"]] forKey:kCommonTypeTo];
    [dict setValue:[NSObject validateString:item[@"fromType"]] forKey:kCommonTypeFrom];
    [dict setValue:[NSObject validateString:item[@"tpegDirection"]] forKey:kCommonTpegDir];
    return dict;
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

#pragma mark - Dates
- (NSDate *)dateFromString:(NSString *)string {
    
    return [[self dateFormatter] dateFromString:string];
}

- (NSDateFormatter *)dateFormatter {
    
    if (!self.formatter)
    {
        NSDateFormatter *formatter = [NSDateFormatter new];
        [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
        [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZZZ"];
        self.formatter = formatter;
    }
    return self.formatter;
}

@end

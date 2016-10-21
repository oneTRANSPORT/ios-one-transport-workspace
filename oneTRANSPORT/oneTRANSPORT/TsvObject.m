//
//  TsvObject.m
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

#import "TsvObject.h"

@implementation TsvObject

+ (NSArray *)prepareTsvArray:(NSString *)stringData {
    
    NSArray *rows = [stringData componentsSeparatedByString:@"\n"];
    return rows;
}

+ (NSArray *)cleanTsvColumns:(NSString *)row {
    
    NSMutableArray *arrayColumns = [NSMutableArray new];
    NSArray *columns = [row componentsSeparatedByString:@"\t"];
    for (int i=0; i<columns.count; i++) {
        NSString *column = columns[i];
        if ([column hasSuffix:@"\r"]) {
            column = [column substringWithRange:NSMakeRange(0, column.length-1)];
        }
        if ([column hasPrefix:@"\""] && [column hasSuffix:@"\""]) {
            column = [column substringWithRange:NSMakeRange(1, column.length-2)];
        }
        [arrayColumns addObject:column];
    }
    return [NSArray arrayWithArray:arrayColumns];
}

+ (BOOL)validateColumns:(NSArray *)array arrayCompare:(NSArray *)arrayCompare {

    BOOL matching = true;
    NSInteger i = 0;
    for (NSString *row in arrayCompare) {
        if (array.count > i) {
            if (![row isEqualToString:array[i]]) {
                matching = false;
                break;
            }
        } else {
            matching = false;
            break;
        }
        i++;
    }
    
    if (!matching) {
        NSLog(@"TSV does not matched required headers of\n%@", arrayCompare);
    }
    
    return matching;
}

+ (NSDateFormatter *)formatter {
    
    NSDateFormatter *formatter = [NSDateFormatter new];
    [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss'Z'"];
    return formatter;
}

@end

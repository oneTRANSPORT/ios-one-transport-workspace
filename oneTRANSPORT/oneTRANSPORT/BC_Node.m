//
//  BC_Node.m
//  
//
//  Created by Dominic Frazer Imregh on 06/09/2016.
//
//

#import "BC_Node.h"

@implementation BC_Node

- (NSString *)localizedMessage {
    
    if (self.customer_name == nil) {
        return @"";
    } else {
        return self.customer_name;
    }
}

- (NSInteger)localizedCounter {
    
    return 0;
}

- (NSInteger)localizedCounterSub {
    
    return 0;
}

@end

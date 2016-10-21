//
//  ViewController.m
//  OTObjCExample
//
//  Created by Dominic Frazer Imregh on 28/09/2016.
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

#import "ViewController.h"
#import <oneTRANSPORT/oneTRANSPORT.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)pressedRefresh {
    
    [self refreshData];
}

- (void)refreshData {
    
    CompletionType completionBlock = ^(NSDictionary *response, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.activityIndicator.hidden = true;
        
            if (error != nil) {
                self.textViewLog.text = [error localizedDescription];
            } else {
                self.textViewLog.text = [NSString stringWithFormat:@"%@", response];
                NSArray *arrayChanges = response[kResponseChangesAll];
                NSLog(@"%@", arrayChanges);

                
                NSArray *array = [[OTSingleton sharedInstance].carParks retrieveAll:false];
                self.textViewLog.text = [NSString stringWithFormat:@"%@\n\n============================\nCoreData CarParks contains %zd records\n", self.textViewLog.text, array.count];
                
                NSArray *arrayCommon = [[OTSingleton sharedInstance].common retrieveType:ObjectTypeCarParks];
                self.textViewLog.text = [NSString stringWithFormat:@"%@\n\n============================\nCoreData Common contains %zd car park records\n", self.textViewLog.text, arrayCommon.count];
                
                [self.textViewLog scrollRangeToVisible:NSMakeRange(self.textViewLog.text.length - 1, 1)];
            }
        });
    };
    
    self.activityIndicator.hidden = false;
    [[OTSingleton sharedInstance] requestData:LocalAuthorityBirmingham container:ContainerTypeCarParks completion:completionBlock];
}

@end

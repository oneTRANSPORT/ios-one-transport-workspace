//
//  ExampleViewController.swift
//  OTMap
//
//  Created by Dominic Frazer Imregh on 26/09/2016.
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

import UIKit
import oneTRANSPORT

class ExampleViewController: BaseViewController {

    @IBOutlet weak var activityIndicator: ActivityView!
    @IBOutlet weak var textViewLog: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        self.checkForDuplicateLat()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func checkForDuplicateLat() {
        
        let array = OTSingleton.sharedInstance().common.retrieveDuplicates(nil)
        var count = 0
        for dict in array {
            if let item = dict as? [NSString : AnyObject] {
                if item["counter"]!.integerValue > 1 {
                    print (dict)
                    count += 1
                }
            }
        }
        print ("Counter \(count)")
        
        let arrayRef = OTSingleton.sharedInstance().common.retrieveAll("latitude == 51.65702")
        print (arrayRef)
    }
    
    @IBAction func pressedRefresh() {
    
        self.refreshData()
    }
    
    func refreshData() {
        self.activityIndicator.start()
        
        
        OTSingleton.sharedInstance().requestData(.bucks, container: .roadWorks) {response, error in
            self.activityIndicator.stop()
            
            if error != nil {
                self.showMessage(error!.localizedDescription) { }
            } else {
                self.showMessage("Data request completed and CoreData updated") { }
                
                DispatchQueue.main.async {
                    self.textViewLog.text = String.init(format: "%@", response!)
                    if let arrayChanges = response?[kResponseChangesAll] as? [Common] {
                        print ("ChangesArray \(arrayChanges)")
                    }
                    
                    let array = OTSingleton.sharedInstance().roadworks.retrieveAll()
                    self.textViewLog.text = String.init(format: "%@\n\n============================\nCoreData Roadworks contains %zd records\n", self.textViewLog.text, array.count)
                    
                    let arrayCommon = OTSingleton.sharedInstance().common.retrieveType(.roadworks)
                    self.textViewLog.text = String.init(format: "%@\n\n============================\nCoreData Common contains %zd events records\n", self.textViewLog.text, arrayCommon.count)
                    
                    self.textViewLog.scrollRangeToVisible(NSMakeRange(self.textViewLog.text.count - 1, 1))
                }
            }
        }

        OTSingleton.sharedInstance().requestData(.herts, container: .events) {response, error in
            self.activityIndicator.stop()
            
            if error != nil {
                self.showMessage(error!.localizedDescription) { }
            } else {
                self.showMessage("Data request completed and CoreData updated") { }
                
                DispatchQueue.main.async {
                    self.textViewLog.text = String.init(format: "%@", response!)
                    if let arrayChanges = response?[kResponseChangesAll] as? [Common] {
                        print ("ChangesArray \(arrayChanges)")
                    }
                    
                    let array = OTSingleton.sharedInstance().events.retrieveAll()
                    self.textViewLog.text = String.init(format: "%@\n\n============================\nCoreData Events contains %zd records\n", self.textViewLog.text, array.count)
                    
                    let arrayCommon = OTSingleton.sharedInstance().common.retrieveType(.events)
                    self.textViewLog.text = String.init(format: "%@\n\n============================\nCoreData Common contains %zd events records\n", self.textViewLog.text, arrayCommon.count)
                    
                    self.textViewLog.scrollRangeToVisible(NSMakeRange(self.textViewLog.text.count - 1, 1))
                }
            }
        }

        OTSingleton.sharedInstance().requestData(.bucks, container: .carParks) {response, error in
            self.activityIndicator.stop()

            if error != nil {
                self.showMessage(error!.localizedDescription) { }
            } else {
                self.showMessage("Data request completed and CoreData updated") { }
                
                DispatchQueue.main.async {
                    self.textViewLog.text = String.init(format: "%@", response!)
                    if let arrayChanges = response?[kResponseChangesAll] as? [Common] {
                        print ("ChangesArray \(arrayChanges)")
                    }
             
                    let array = OTSingleton.sharedInstance().carParks.retrieveAll(false)
                    self.textViewLog.text = String.init(format: "%@\n\n============================\nCoreData CarParks contains %zd records\n", self.textViewLog.text, array.count)

                    let arrayCommon = OTSingleton.sharedInstance().common.retrieveType(.carParks)
                    self.textViewLog.text = String.init(format: "%@\n\n============================\nCoreData Common contains %zd car park records\n", self.textViewLog.text, arrayCommon.count)

                    self.textViewLog.scrollRangeToVisible(NSMakeRange(self.textViewLog.text.count - 1, 1))
                }
            }
        }        
    }
}

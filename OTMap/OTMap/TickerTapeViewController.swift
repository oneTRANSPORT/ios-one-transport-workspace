//
//  TickerTapeViewController.swift
//  OTMap
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

import UIKit
import oneTRANSPORT

let kNotificationReceivedMessage = "NotificationUpdatedMessage"

class TickerTapeViewController: UIViewController {

    @IBOutlet weak var label1: UILabel!
    @IBOutlet weak var label2: UILabel!
    @IBOutlet weak var constraintLeft1: NSLayoutConstraint!
    @IBOutlet weak var constraintLeft2: NSLayoutConstraint!
    var timer = Timer()
    var arrayMessage : [String] = []
    
    var arrayLabels : [UILabel] = []
    var arrayConstraints : [NSLayoutConstraint] = []
    var currentLabel = 1
    var previousLabel = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        arrayLabels = [label1, label2]
        arrayConstraints = [constraintLeft1, constraintLeft2]
        
        NotificationCenter.default.addObserver(self, selector: #selector(messageReceived), name: NSNotification.Name(rawValue: kNotificationReceivedMessage), object: nil)
    }
    
    deinit {
        
        self.timer.invalidate()
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: kNotificationUpdatedLocation), object: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
     
        self.label1.text = ""
        self.label2.text = ""
        
        self.startTimer()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.timer.invalidate()
    }

    let timeInterval = 10.0
    func startTimer() {
        
        self.timer.invalidate()
        self.timer = Timer.scheduledTimer(timeInterval: self.timeInterval, target: self, selector: #selector(checkTicker), userInfo: nil, repeats: true)
        self.checkTicker()
    }
    
    @objc func checkTicker() {

        if !arrayMessage.isEmpty {
            self.previousLabel = self.currentLabel
            self.currentLabel += 1
            if self.currentLabel > 1 {
                self.currentLabel = 0
            }

            DispatchQueue.main.async(execute: {
                self.arrayLabels[self.currentLabel].text = "    \(self.arrayMessage[0])"
                self.arrayMessage.removeFirst()
                
                self.arrayConstraints[self.currentLabel].constant = self.view.frame.size.width
                self.view.layoutIfNeeded()
                
                let width = self.arrayLabels[self.currentLabel].frame.size.width
                self.arrayConstraints[self.currentLabel].constant -= width
                self.arrayConstraints[self.previousLabel].constant -= width
                
                UIView.animate(withDuration: self.timeInterval - 0.5, animations: {
                    self.view.layoutIfNeeded()
 
                    }, completion: { (Bool) in

                })
            })
        }
    }

    @objc func messageReceived(_ notification: Notification) {

        if let array = notification.object as? [Common] {
            var message = ""
            
            let singleton = OTSingleton.sharedInstance()
            for common in array {
                switch common.type! {
                case singleton.variableMS.dataType:
                    let array = OTSingleton.sharedInstance().variableMS.retrieveHistory(common.reference)
                    if !array.isEmpty {
                        let object = array[0]
                        message = object.localizedMessage()
                    }
                case singleton.trafficFlow.dataType:
                    let array = OTSingleton.sharedInstance().trafficFlow.retrieveHistory(common.reference)
                    if !array.isEmpty {
                        let object = array[0]
                        message = object.localizedMessage()
                    }
                case singleton.trafficQueue.dataType:
                    let array = OTSingleton.sharedInstance().trafficQueue.retrieveHistory(common.reference)
                    if !array.isEmpty {
                        let object = array[0]
                        message = object.localizedMessage()
                    }
                case singleton.trafficSpeed.dataType:
                    let array = OTSingleton.sharedInstance().trafficSpeed.retrieveHistory(common.reference)
                    if !array.isEmpty {
                        let object = array[0]
                        message = object.localizedMessage()
                    }
                case singleton.trafficScoot.dataType:
                    let array = OTSingleton.sharedInstance().trafficScoot.retrieveHistory(common.reference)
                    if !array.isEmpty {
                        let object = array[0]
                        message = object.localizedMessage()
                    }
                case singleton.trafficTime.dataType:
                    let array = OTSingleton.sharedInstance().trafficTime.retrieveHistory(common.reference)
                    if !array.isEmpty {
                        let object = array[0]
                        message = object.localizedMessage()
                    }
                case singleton.carParks.dataType:
                    let array = OTSingleton.sharedInstance().carParks.retrieveHistory(common.reference)
                    if !array.isEmpty {
                        let object = array[0]
                        message = object.localizedMessage()
                    }
                case singleton.roadworks.dataType:
                    let array = OTSingleton.sharedInstance().roadworks.retrieveHistory(common.reference)
                    if !array.isEmpty {
                        let object = array[0]
                        message = object.localizedMessage()
                    }
                case singleton.bitCarrierNode.dataType:
                    break
                case singleton.clearViewDevice.dataType:
                    break
                default:
                    break
                }
                
                arrayMessage.append("Change:\(common.type!): \(common.reference),\(message)")
            }
        }
    }

}

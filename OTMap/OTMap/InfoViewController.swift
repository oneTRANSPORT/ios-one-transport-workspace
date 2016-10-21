//
//  InfoViewController.swift
//  OTMap
//
//  Created by Dominic Frazer Imregh on 12/08/2016.
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

let kUserDefaultsRefreshInterval = "RefreshInterval"
let kUserDefaultsLastRefresh = "LastRefresh"

class InfoViewController: BaseViewController {

    @IBOutlet weak var labelRefresh: UILabel!
    @IBOutlet weak var sliderRefresh: UISlider!
    @IBOutlet weak var switchKph: UISwitch!
    @IBOutlet weak var switchTrace: UISwitch!
    @IBOutlet weak var activityIndicator: ActivityView!
    @IBOutlet weak var labelActivity: UILabel!
    @IBOutlet weak var labelFilters: UILabel!
    @IBOutlet weak var buttonFilters: UIButton!
    @IBOutlet weak var textViewLog: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.activityIndicator.stop()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        var value = UserDefaults.standard.float(forKey: kUserDefaultsRefreshInterval)
        if value == 0 {
            value = 1
        }
        self.sliderRefresh.value = value
        self.changedSlider(self.sliderRefresh)
        
        self.switchKph.setOn(OTSingleton.sharedInstance().isKph(), animated: false)
        self.switchTrace.setOn(OTSingleton.sharedInstance().isTrace(), animated: false)
        
        self.showFilter()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        self.showRecordLog(true)
    }
    
    func showRecordLog(_ nslog: Bool) {
        self.textViewLog.text = ""
        
        let singleton = OTSingleton.sharedInstance()
        self.appendText("Common records = \(singleton.common.retrieveRecordCount())", nslog: nslog)
        self.appendText("VMS records = \(singleton.variableMS.retrieveRecordCount())", nslog: nslog)
        self.appendText("Traffic Flow records = \(singleton.trafficFlow.retrieveRecordCount())", nslog: nslog)
        self.appendText("Traffic Queue records = \(singleton.trafficQueue.retrieveRecordCount())", nslog: nslog)
        self.appendText("Traffic Speed records = \(singleton.trafficSpeed.retrieveRecordCount())", nslog: nslog)
        self.appendText("Traffic Scoot records = \(singleton.trafficScoot.retrieveRecordCount())", nslog: nslog)
        self.appendText("Traffic Times records = \(singleton.trafficTime.retrieveRecordCount())", nslog: nslog)
        self.appendText("CarParks records = \(singleton.carParks.retrieveRecordCount())", nslog: nslog)
        self.appendText("Roadworks records = \(singleton.roadworks.retrieveRecordCount())", nslog: nslog)
        self.appendText("Events records = \(singleton.events.retrieveRecordCount())", nslog: nslog)
    
        self.textViewLog.scrollRangeToVisible(NSMakeRange(self.textViewLog.text.characters.count - 1, 1))
    }
    
    func appendText(_ string: String, nslog: Bool) {
        
        self.textViewLog.text = String.init(format: "%@\n%@", self.textViewLog.text, string)
        
        if nslog {
            print (string)
        }
    }
    
    @IBAction func changedSlider(_ sender : UISlider) {
        
        var key : String
        let value = floorf(self.sliderRefresh.value * 10) / 10
        UserDefaults.standard.set(value, forKey: kUserDefaultsRefreshInterval)
        
        if value == 1 {
            key = "minute"
        } else {
            key = "minutes"
        }
        self.labelRefresh.text = String(format: "Refresh Interval : %.1f %@", arguments :[value, key])
    }

    @IBAction func changedSwitchKph() {
        OTSingleton.sharedInstance().setKph(self.switchKph.isOn)
    }

    @IBAction func changedSwitchTrace() {
        OTSingleton.sharedInstance().setTrace(self.switchTrace.isOn)
    }

    @IBAction func pressedFlushData() {
        
        self.activityIndicator.start()
        self.labelActivity.text = ""
        OTSingleton.sharedInstance().removeAll() { success in
            
            self.showRecordLog(false)
            if success {
                self.activityIndicator.stop()
                self.showMessage("Finished") { }
                self.showRecordLog(true)
            } else {
                self.labelActivity.text?.append(".")
            }
        }
    }
    
    func showFilter() {
        let singleton = OTSingleton.sharedInstance()
        
        if Int(singleton.getMinImportFilter().latitude) == EmptyLatLon.minLat.rawValue {
            self.labelFilters.text = "Data request/import filter not set"
            self.buttonFilters.isHidden = true
        } else {
            let coord1 = singleton.getMinImportFilter()
            let coord2 = singleton.getMaxImportFilter()
            self.labelFilters.text = String.init(format: "Data request/import filter set\nTop Left = %.4f, %.4f\nBottom Right = %.4f, %.4f", coord1.latitude, coord1.longitude, coord2.latitude, coord2.longitude)
            self.buttonFilters.isHidden = false
        }
    }
    
    @IBAction func pressedClearFilter() {
        
        OTSingleton.sharedInstance().clearDataImportFilter()
        self.showFilter()
    }
}

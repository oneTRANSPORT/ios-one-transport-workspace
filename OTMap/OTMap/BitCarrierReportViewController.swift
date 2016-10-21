//
//  BitCarrierReportViewController.swift
//  OTMap
//
//  Created by Dominic Frazer Imregh on 21/09/2016.
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

class BitCarrierReportViewController: BaseViewController {

    @IBOutlet weak var activityIndicator: ActivityView!
    @IBOutlet weak var viewReport: UIView!
    @IBOutlet weak var buttonHide: UIButton!
    @IBOutlet weak var datePickerFrom: UIDatePicker!
    @IBOutlet weak var datePickerTo: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
 
        self.pressedChangeDates()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    
        self.establishDateRange()
    }
    
    func establishDateRange() {

        self.activityIndicator.start()
        DispatchQueue.global(qos: DispatchQoS.QoSClass.userInitiated).async {

            let array = OTSingleton.sharedInstance().clearViewTraffic.retrieveSummary(nil)
            if !array.isEmpty {
                let first = array.first
                let last = array.last
        
                let dateStart = first!["creationtime"] as! Date
                let dateEnd = last!["creationtime"] as! Date
            
                DispatchQueue.main.async {
                    self.datePickerFrom.setDate(dateStart, animated: false)
                    self.datePickerTo.setDate(dateEnd, animated: false)
                }
            }
            self.activityIndicator.stop()
        }
    }

    @IBAction func pressedClearViewReport() {
        
        self.hideDatePickers(true)
        
        for subview in self.viewReport.subviews {
            subview.removeFromSuperview()
        }
        
        let arrayDevices = OTSingleton.sharedInstance().clearViewDevice.retrieveAll(nil)
        if arrayDevices.count == 0 {
            self.showMessage("No devices found in table") { }
        }
        
        let calendar = Calendar(identifier: .gregorian)

        //Calculate max chart height
        var maxCount : CGFloat = 0.0
        for device in arrayDevices {
            let ref = (device as AnyObject).reference!
            let dateFrom = calendar.startOfDay(for: self.datePickerFrom.date)
            let dateTo   = calendar.startOfDay(for: calendar.date(byAdding: .day, value: 1, to: self.datePickerTo.date)!)
            let predicate = NSPredicate.init(format:"reference == %@ && timestamp >= %@ && timestamp < %@",
                                             ref,
                                             dateFrom as CVarArg,
                                             dateTo as CVarArg)
            let array = OTSingleton.sharedInstance().clearViewTraffic.retrieveSummary(predicate)
            var startCount : CGFloat = 0.0
            for dict in array {
                let direction = dict["direction"]! as! Int
                let counter = dict["counter"]! as! Int
                if direction == 0 {
                    startCount -= CGFloat(counter)
                } else {
                    startCount += CGFloat(counter)
                }
                
                if abs(startCount) > maxCount {
                    maxCount = abs(startCount)
                }
            }
        }
        var heightRatio : CGFloat = maxCount / ((self.viewReport.bounds.height / 2) - 16)
        if heightRatio == 0 {
            heightRatio = 1
        }

        //Generate charts
        let arrayColor : [UIColor] = [UIColor.red, UIColor.green, UIColor.blue, UIColor.brown, UIColor.cyan, UIColor.magenta, UIColor.orange, UIColor.purple]
        for (i, device) in arrayDevices.enumerated() {
            let ref = (device as AnyObject).reference!
            let dateFrom = calendar.startOfDay(for: self.datePickerFrom.date)
            let dateTo   = calendar.startOfDay(for: calendar.date(byAdding: .day, value: 1, to: self.datePickerTo.date)!)
            let predicate = NSPredicate.init(format:"reference == %@ && timestamp >= %@ && timestamp < %@",
                                             ref,
                                             dateFrom as CVarArg,
                                             dateTo as CVarArg);
            let array = OTSingleton.sharedInstance().clearViewTraffic.retrieveSummary(predicate)
            self.buildChart((device as AnyObject).reference, colour: arrayColor[i % arrayColor.count], dateStart: dateFrom, dateEnd: dateTo, array: array, heightRatio: heightRatio)
        }
    }
    
    func buildChart(_ reference : String, colour : UIColor, dateStart : Date, dateEnd : Date, array : [[AnyHashable: Any]], heightRatio: CGFloat) {
        
        let viewChart = ClearViewReportView()
        viewChart.frame = CGRect.init(x: 8, y: 8, width: self.viewReport.bounds.width - 16, height: self.viewReport.bounds.height - 16)
        viewChart.backgroundColor = UIColor.clear
        viewChart.configure(reference, colour: colour, dateStart: dateStart, dateEnd: dateEnd, array: array, heightRatio: heightRatio)
        
        self.viewReport.addSubview(viewChart)
    }
    
    @IBAction func pressedChangeDates() {
        
        self.hideDatePickers(!self.datePickerFrom.isHidden)
    }
    
    func hideDatePickers(_ hide : Bool) {
        
        self.datePickerFrom.isHidden = hide;
        self.datePickerTo.isHidden = hide;
        
        if hide {
            self.buttonHide.setTitle("Show Dates", for: UIControlState())
        } else {
            self.buttonHide.setTitle("Hide Dates", for: UIControlState())
        }
    }
}

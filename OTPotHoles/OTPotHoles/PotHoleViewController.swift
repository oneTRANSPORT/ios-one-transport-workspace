//
//  PotHoleViewController.swift
//  OTMap
//
//  Created by Dominic Frazer Imregh on 05/09/2016.
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
import MapKit
import oneTRANSPORT

class PotHoleViewController: BaseViewController {

    @IBOutlet weak var activityIndicator: ActivityView!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var textFieldComment: UITextField!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var labelLocation: UILabel!
    @IBOutlet weak var buttonSubmit: UIButton!
    @IBOutlet weak var buttonBump: UIButton!

    var locationPotHole = CLLocationCoordinate2D()
    
    let fakeLocationWithSimulator = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(locationChanged), name: NSNotification.Name(rawValue: kNotificationUpdatedLocation), object: nil)
        
        self.enableSubmit(false)
   
        let buttonL = UIBarButtonItem.init(title: "Clear", style: .plain, target: self, action: #selector(didPressClear))
        let buttonR = UIBarButtonItem.init(title: "Done", style: .plain, target: self, action: #selector(didPressDone))
        let buttonSpace = UIBarButtonItem.init(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let accessoryView = UIToolbar.init(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 50))
        accessoryView.items = [buttonL, buttonSpace, buttonR]
        accessoryView.sizeToFit()
        self.textFieldComment.inputAccessoryView = accessoryView

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.activityIndicator.start()
        let status = LocationManager.sharedInstance.start()
        if status != .good {
            self.showBackgroundError(status)
        }
    }

    @objc func locationChanged(_ notification: Notification) {
        
        self.activityIndicator.stop()
        if let locationObj = notification.object as? CLLocation {
            
            if fakeLocationWithSimulator {
                //California - 37.7634,    -122.4051
                //Aylesbury    51.8173523,   -0.8081491
                //Difference  +14.054,     -121.5969509
                self.locationPotHole = CLLocationCoordinate2D(latitude: locationObj.coordinate.latitude + 14.054, longitude: locationObj.coordinate.longitude + 121.5969509)
            } else {
                self.locationPotHole = locationObj.coordinate
            }
            
            let viewRegion = MKCoordinateRegionMake(self.locationPotHole, MKCoordinateSpanMake(0.01, 0.01))
            let adjustedRegion = self.mapView.regionThatFits(viewRegion)
            self.mapView.setRegion(adjustedRegion, animated: true)
            self.mapView.showsUserLocation = true
            
            self.labelLocation.text = "Location: \(self.locationPotHole.latitude.string(4)), \(self.locationPotHole.longitude.string(4))"
            self.enableSubmit(true)
        } else {
            if LocationManager.sharedInstance.currentStatus != .good {
                self.showBackgroundError(LocationManager.sharedInstance.currentStatus)
            }
        }
    }
    
    func showBackgroundError(_ status : LocationStatus) {
        
        var message : String = ""
        if status == .noBackgroundRefresh {
            message = "The app doesn't work without the Background app Refresh enabled. To turn it on, go to Settings > General > Background app Refresh"
        } else if status == .restrictedBackgroundRefresh {
            message = "The functions of this app are limited because the Background app Refresh is disabled."
        }
        if message != "" {
            self.showMessage(message, completionHandler: { })
        }
    }

    @objc func didPressClear() {
        self.textFieldComment.text = ""
    }
    
    @objc func didPressDone() {
        self.textFieldComment.resignFirstResponder()
    }

    func enableSubmit(_ enable : Bool) {
    
        self.buttonSubmit.isEnabled = enable
        self.buttonSubmit.alpha = enable ? 1.0 : 0.5
        self.buttonBump.isEnabled = enable
        self.buttonBump.alpha = enable ? 1.0 : 0.5
    }
    
    @IBAction func pressedSubmit() {
        
        self.submitPotHole(coord: self.locationPotHole,
                           comment: self.textFieldComment.text! as NSString,
                           rating: self.segmentControl.selectedSegmentIndex)
    }
    
    @IBAction func pressedBump() {
        
        self.submitPotHole(coord: self.locationPotHole,
                           comment: "Hit a bump!",
                           rating: Int(arc4random_uniform(4)))
    }
    
    func submitPotHole(coord : CLLocationCoordinate2D, comment : NSString, rating : Int) {
        
        self.activityIndicator.start()
        
        let ae = OTSingleton.sharedInstance().cse?.createAe(withId: APP_ID, name: APP_ID)
        let cnt = ae?.createContainer(withName: kPotHoleCNT)
        let cin = cnt?.createContentInstance(withName: "cin-\(self.stringFromDate(Date()))")
        cin!.content = "{\"comment\":\"\(comment)\",\"rating\":\(rating),\"latitude\":\(coord.latitude),\"longitude\":\(coord.longitude)"
        cin!.remoteRequest(.create, subMethod: .none, session: OTSingleton.sharedInstance().sessionTask) {response, error in
            if error == nil {
                self.showMessage("Submitted") {
                    self.dismiss(animated: true, completion:nil);
                }
                
            } else {
                self.showMessage(error!.localizedDescription, completionHandler: {})
            }
            self.activityIndicator.stop()
        }        
    }

    func stringFromDate(_ date : Date) ->String {
        
        let formatter = DateFormatter.init()
        formatter.timeZone = TimeZone.init(identifier: "GMT")
        formatter.dateFormat = "yyyyMMdd'T'HHmmss"
    
        return formatter.string(from: date)
    }

}

extension PotHoleViewController: MKMapViewDelegate {
    
    func mapViewDidFinishLoadingMap(_ mapView: MKMapView) {
        
        self.activityIndicator.stop()
    }
}

extension Double {
    
    func string(_ fractionDigits : Int) -> String {
        
        let formatter = NumberFormatter()
        formatter.minimumFractionDigits = fractionDigits
        formatter.maximumFractionDigits = fractionDigits
        return formatter.string(from: NSNumber(value: self))!
    }
}

//
//  LocationManager.swift
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
import CoreLocation

let kNotificationUpdatedLocation = "LocationUpdated"
let kUserDefaultsActiveLocation = "ActiveLocation"
let kUserDefaultsActiveTrackPath = "ActiveTrackPath"

enum LocationStatus {
    case good
    case noBackgroundRefresh
    case restrictedBackgroundRefresh
}

class LocationManager: NSObject, CLLocationManagerDelegate {
    
    static let sharedInstance = LocationManager()
    var locationManager = CLLocationManager()
    var seenError = false
    var allowed = false
    var trackPath = ""
    var currentStatus : LocationStatus = .good
    var tracking = false
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
//        locationManager.startUpdatingLocation()
    }
    
    func start() -> LocationStatus {
        
        if UIApplication.shared.backgroundRefreshStatus == .denied {
            self.currentStatus = .noBackgroundRefresh
        } else if UIApplication.shared.backgroundRefreshStatus == .restricted {
            self.currentStatus = .restrictedBackgroundRefresh
        } else {
            if UserDefaults.standard.bool(forKey: kUserDefaultsActiveLocation) {
                if let trackPath : String = UserDefaults.standard.value(forKey: kUserDefaultsActiveTrackPath) as? String {
                    self.trackPath = trackPath
                } else {
                    self.trackPath = ""
                }
            }
            
            if self.trackPath == "" {
                self.trackPath = UUID().uuidString
            }
            locationManager.startUpdatingLocation()
            UserDefaults.standard.set(true, forKey: kUserDefaultsActiveLocation)
            UserDefaults.standard.setValue(self.trackPath, forKey: kUserDefaultsActiveTrackPath)
            self.currentStatus = .good
            self.tracking = true
        }
        return self.currentStatus
    }
    
    func stop() {
    
        self.trackPath = ""
        UserDefaults.standard.set(false, forKey: kUserDefaultsActiveLocation)
        UserDefaults.standard.setValue("", forKey: kUserDefaultsActiveTrackPath)
        locationManager.stopUpdatingLocation()
        self.tracking = false
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
        self.stop()
        if (self.seenError == false) {
            self.seenError = true
            self.currentStatus = .noBackgroundRefresh
            if self.trackPath != "" {
                NotificationCenter.default.post(name: Notification.Name(rawValue: kNotificationUpdatedLocation), object: nil)
            }
        }
    }
    
    internal func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if self.trackPath != "" && !locations.isEmpty {
            let locationObject = locations[locations.count - 1]
                        
            NotificationCenter.default.post(name: Notification.Name(rawValue: kNotificationUpdatedLocation), object: locationObject)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        var locationStatus : String = ""
        
        self.allowed = false
        switch status {
        case .restricted:
            locationStatus = "Restricted Access to location"
        case .denied:
            locationStatus = "User denied access to location"
        case .notDetermined:
            locationStatus = "Location status not determined"
        default:
            self.allowed = true
        }
        
        NotificationCenter.default.post(name: Notification.Name(rawValue: "LocationAuthorisationChanged"), object: nil)
        
        if (self.allowed == true) {
            print("Location allowed")
            locationManager.startUpdatingLocation()
        } else {
            print("Denied access: \(locationStatus)")
        }
    }
}

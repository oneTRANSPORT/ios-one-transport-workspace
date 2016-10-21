//
//  ViewController.swift
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
import MapKit
import oneTRANSPORT

class MapViewController: BaseViewController {

    @IBOutlet weak var mapView: MapView!
    @IBOutlet weak var activityIndicator: ActivityView!
    @IBOutlet weak var barButtonRefresh: UIBarButtonItem!

    @IBOutlet weak var constraintViewBottom: NSLayoutConstraint!
    @IBOutlet weak var constraintViewHeight: NSLayoutConstraint!
    @IBOutlet weak var textViewLog: UITextView!
    @IBOutlet weak var imageViewIcon: UIImageView!
    @IBOutlet weak var imageViewFavourite: UIImageView!
    @IBOutlet weak var buttonFavourite: UIButton!

    let manualMode = true
    let dataSource = MapDataSource.init()
    var firstTime = true
    var currentPoint = PointAnnotation()
    var timer = Timer()

    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(self, selector: #selector(locationChanged), name: NSNotification.Name(rawValue: kNotificationUpdatedLocation), object: nil)
        
        self.mapView.delegateParent = self

        let array = OTSingleton.sharedInstance().common.retrieveAll(nil)
        NotificationCenter.default.post(name: Notification.Name(rawValue: kNotificationReceivedMessage), object: array)
    }

    deinit {
        print ("deinit MapViewController")
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: kNotificationUpdatedLocation), object: nil)
        LocationManager.sharedInstance.stop()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.mapView.setupDataSource(dataSource, showLocation: !manualMode)
        self.hideInfoView()
        
        if (self.firstTime) {
            self.activityIndicator.start()

            if (manualMode) {
                LocationManager.sharedInstance.stop()
                
                var locationObject = CLLocation()
                let singleton = OTSingleton.sharedInstance()
                let min = singleton.getMinImportFilter()
                if Int(min.latitude) == EmptyLatLon.minLat.rawValue {
                    if CellRequest.la_Bucks.getUserDefaultsValue() {
                        locationObject = CLLocation.init(latitude: 51.8173523, longitude: -0.8081491) //default to Aylesbury
                    } else if CellRequest.la_Oxon.getUserDefaultsValue() {
                        locationObject = CLLocation.init(latitude: 51.755406, longitude: -1.259261)   //default to Oxford
                    } else if CellRequest.la_Herts.getUserDefaultsValue() {
                        locationObject = CLLocation.init(latitude: 51.754553, longitude: -0.336229)   //default to St Albans
                    } else if CellRequest.la_Northants.getUserDefaultsValue() {
                        locationObject = CLLocation.init(latitude: 52.234996, longitude: -0.901513)   //default to Northampton
                    } else {
                        locationObject = CLLocation.init(latitude: 52.49178, longitude: -1.8924)      //default to Birmingham
                    }
                } else {
                    let max = singleton.getMaxImportFilter()
                    
                    let lat = min.latitude + (max.latitude - min.latitude) / 2
                    let lon = min.longitude + (max.longitude - min.longitude) / 2
                    locationObject = CLLocation.init(latitude: lat, longitude: lon)
                }
                NotificationCenter.default.post(name: Notification.Name(rawValue: kNotificationUpdatedLocation), object: locationObject)
            } else {
                let status = LocationManager.sharedInstance.start()
                if status != .good {
                    self.showBackgroundError(status)
                }
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if !self.firstTime {
            self.refreshData()
        } else {
            self.firstTime = false
        }
        
        self.mapView.addSketches(false)
        self.startTimer()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        self.timer.invalidate()
    }
    
    func locationChanged(_ notification: Notification) {
        
        self.activityIndicator.stop()
        if let locationObj = notification.object as? CLLocation {
            let viewRegion = MKCoordinateRegionMake(locationObj.coordinate, MKCoordinateSpanMake(0.01, 0.01))
            let adjustedRegion = self.mapView.regionThatFits(viewRegion)
            self.mapView.setRegion(adjustedRegion, animated: true)
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if segue.identifier == "Detail" {
            
            if let vc = segue.destination as? DetailViewController {
                vc.point = sender as? PointAnnotation
            }
        }
    }
    
    func startTimer() {

        var value = UserDefaults.standard.double(forKey: kUserDefaultsRefreshInterval) * 60
        if value == 0 {
            value = 1 * 60
        }

        var refresh = true
        if let date = UserDefaults.standard.value(forKey: kUserDefaultsLastRefresh) as? Date {
            if date.timeIntervalSinceNow < value {
                refresh = false
            }
        }
        if refresh {
            self.pressedRefresh()
        }
        
        self.timer.invalidate()
        self.timer = Timer.scheduledTimer(timeInterval: value, target: self, selector: #selector(pressedRefresh), userInfo: nil, repeats: true)
    }
    
    @IBAction func pressedRefresh() {
        
        self.view.isUserInteractionEnabled = false
        self.activityIndicator.start()

        UserDefaults.standard.setValue(Date(), forKey: kUserDefaultsLastRefresh)
        self.startTimer()
        
        OTSingleton.sharedInstance().requestData() {response, error in
            if error != nil {
                DispatchQueue.main.async {
                    self.showMessage(error!.localizedDescription) { }
                    self.view.isUserInteractionEnabled = true
                    self.activityIndicator.stop()
                }
            } else {
                if let arrayChanges = response?[kResponseChangesAll] as? [Common] {
                    print ("ChangesArray \(arrayChanges)")

                    for object in arrayChanges {
                        let notif = UILocalNotification()
                        notif.fireDate = Date()
                        notif.alertBody = object.title;
                        notif.alertAction = "OK"
                        UIApplication.shared.scheduleLocalNotification(notif)
                        break
                    }
                }
                self.refreshData()
            }
        }
        self.barButtonRefresh.isEnabled = false
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(30 * Int64(NSEC_PER_SEC)) / Double(NSEC_PER_SEC)) {
            self.barButtonRefresh.isEnabled = true
        }
    }
    
    func refreshData() {
        
        DispatchQueue.global(qos: DispatchQoS.QoSClass.default).async {
            self.mapView.refreshDataSource()
            DispatchQueue.main.async {
                self.mapView.refreshMapPins()

                self.view.isUserInteractionEnabled = true
                self.activityIndicator.stop()
            }
        }
    }
    
    func hideInfoView() {
        
        if self.constraintViewBottom.constant == 0 {
            self.constraintViewBottom.constant = -self.constraintViewHeight.constant
            UIView.animate(withDuration: 0.5, animations: {
                self.view.layoutIfNeeded()
            })
        }
    }

    func showInfoView(_ point : PointAnnotation) {

        if self.constraintViewBottom.constant == -self.constraintViewHeight.constant {
            self.constraintViewBottom.constant = 0
            UIView.animate(withDuration: 0.5, animations: {
                self.view.layoutIfNeeded()
            })
        }
        
        self.currentPoint = point
        if let imageName = self.currentPoint.pointerToView?.getImagePath() {
            self.imageViewIcon.image = UIImage.init(named: imageName)
        }
        
        self.showFavourite()
        
        if let common = OTSingleton.sharedInstance().common.retrieve(self.currentPoint.reference, type: self.currentPoint.annotationType) {
            self.appendText(common.title!)

            let objectClass = OTSingleton.sharedInstance().getObjectClass(self.currentPoint.annotationType)
            let array = objectClass.retrieveHistory(self.currentPoint.reference)
            if !array.isEmpty {
                self.appendText((array[0] as AnyObject).localizedMessage())
            }
        }
        self.appendText("\n")
    }
    
    func appendText(_ object : String) {
    
        self.textViewLog.text = String(format: "%@%@\n", arguments: [self.textViewLog.text, object])
        DispatchQueue.main.async {
            self.textViewLog.scrollRangeToVisible(NSMakeRange(self.textViewLog.text.characters.count-2, 1))
        }
    }

    @IBAction func pressedDebug() {

        self.performSegue(withIdentifier: "Detail", sender: self.currentPoint)
    }

    func showFavourite() {
        
        let favourite = OTSingleton.sharedInstance().common.isFavourite(self.currentPoint.reference, type: self.currentPoint.annotationType)
        self.imageViewIcon.alpha = favourite ? 1.0 : 0.5
        let favName = favourite ? "favourite_on" : "favourite_off"
        self.imageViewFavourite.image = UIImage.init(named: favName)
    }
    
    @IBAction func pressedFavourite() {
        
        let favourite = OTSingleton.sharedInstance().common.isFavourite(self.currentPoint.reference, type: self.currentPoint.annotationType)
        OTSingleton.sharedInstance().common.setFavourite(self.currentPoint.reference, type: self.currentPoint.annotationType, set: !favourite)
        self.showFavourite()
    }
    
    @IBAction func pressedMapFilter() {
        
        let singleton = OTSingleton.sharedInstance()
        
        if Int(singleton.getMinImportFilter().latitude) == EmptyLatLon.minLat.rawValue {        //not set yet
            let topLeft  = CGPoint(x: mapView.bounds.minX, y: mapView.bounds.minY)
            let botRight = CGPoint(x: mapView.bounds.maxX, y: mapView.bounds.maxY)
            let coord1 = mapView.convert(topLeft, toCoordinateFrom: mapView)
            let coord2 = mapView.convert(botRight, toCoordinateFrom: mapView)
            
            OTSingleton.sharedInstance().setDataImportFilterMin(coord1, max: coord2)
            
            self.showMessage("Data request/import filter set to current map bounds") { }
        } else {
            OTSingleton.sharedInstance().clearDataImportFilter()

            self.showMessage("Data filter cleared") { }
        }
        
        self.refreshData()
    }
}

extension MapViewController: MKMapViewDelegate {
   
    func mapViewDidFinishLoadingMap(_ mapView: MKMapView) {
    
        self.activityIndicator.stop()
    }
}

extension MapViewController: MapViewProtocol {
    
    func didSelectPin(_ point : PointAnnotation) {

        self.showInfoView(point)
    }
    
    func didChangeRegion() {
        
        self.hideInfoView()
    }
}

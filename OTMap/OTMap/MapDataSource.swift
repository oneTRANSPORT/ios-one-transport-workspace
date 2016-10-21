//
//  MapDataSource.swift
//  OTMap
//
//  Created by Dominic Frazer Imregh on 15/08/2016.
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
import MapKit

class MapDataSource: NSObject {

    let show_ToLatLon = false
    
    var arrayPinsUnfiltered : [PointAnnotation] = []
    var getFavouritesOnly = false
    let clusterManager = ClusterManager.init()
    var coord1 = CLLocationCoordinate2D()
    var coord2 = CLLocationCoordinate2D()
    
    func setupData(coord1 : CLLocationCoordinate2D, coord2 : CLLocationCoordinate2D) {
        
        self.coord1 = coord1
        self.coord2 = coord2
        
        for point in self.arrayPinsUnfiltered {
            point.remove = true
        }
        self.getFavouritesOnly = CellRequest.favourites.getUserDefaultsValue()
        
        self.setupDataWith(.variableMessageSigns)
        self.setupDataWith(.trafficFlow)
        self.setupDataWith(.trafficQueue)
        self.setupDataWith(.trafficSpeed)
        self.setupDataWith(.trafficScoot)
        self.setupDataWith(.trafficTime)
        self.setupDataWith(.carParks)
        self.setupDataWith(.roadworks)
        self.setupDataWith(.events)
        self.setupDataWith(.bitCarrier)
    }
    
    func setupDataWith(_ type : CellRequest) {
        
        if !type.getUserDefaultsValue() {
            return
        }

        let min = OTSingleton.sharedInstance().getMinImportFilter()
        let max = OTSingleton.sharedInstance().getMaxImportFilter()
        
        let typeAnnotation = type.getAnnotationType()
        
        let array = OTSingleton.sharedInstance().common.retrieveType(typeAnnotation)//, topLeft : min, bottomRight : max)
        for object in array {
            if Double(min.latitude) >= Double(object.latitude!) && Double(min.longitude) <= Double(object.longitude!) &&
                Double(max.latitude) <= Double(object.latitude!) && Double(max.longitude) >= Double(object.longitude!) {

                if let point = self.createPoint(object) {
                    point.annotationType = typeAnnotation
                    point.counter = Int(object.counter1!)
                    point.counterSub = Int(object.counter2!)
                    point.angleForArrow = Float(object.angle!)
                    self.addObjectToArray(point)
                }
                
                if show_ToLatLon {
                    if object.latitudeTo! != 0 {
                        if let point2 = self.createPoint(object) {
                            point2.coordinate.latitude = object.latitudeTo!.doubleValue
                            point2.coordinate.longitude = object.longitudeTo!.doubleValue
                            point2.annotationType = typeAnnotation
                            self.addObjectToArray(point2)
                        }
                    }
                }
            }
        }
    }
    
    func createPoint(_ object : AnyObject) -> PointAnnotation? {
        
        if (self.getFavouritesOnly && (object.favourite)!!.boolValue) || !self.getFavouritesOnly {
            let point = PointAnnotation.init()
            point.reference = object.reference
            point.title = object.title!
            point.coordinate.latitude = object.latitude!!.doubleValue
            point.coordinate.longitude = object.longitude!!.doubleValue
            return point
        }
        
        return nil
    }
    
    func addObjectToArray(_ object : PointAnnotation) {
        
        if (object.coordinate.latitude != 0 || object.coordinate.longitude != 0) {
            var duplicate = false
            for point in self.arrayPinsUnfiltered {
                if object.reference == point.reference && object.annotationType == point.annotationType {
                    point.remove = false
                    duplicate = true
                    break
                }
            }
            if !duplicate {
                object.remove = false
                self.arrayPinsUnfiltered.append(object)
            }
        }
    }
    
    func pinsOfType(_ type : ObjectType) ->[PointAnnotation] {
        
        var array : [PointAnnotation] = []
        for point in self.arrayPinsUnfiltered {
            if point.annotationType == type {
                array.append(point)
            }
        }
        return array
    }
    
    
    func sketch(_ object : BC_Sketch) -> PolyLineAnnotation? {
        
        if let contentsJson = object.lat_lon_array {
            if contentsJson.characters.count > 0 {
                do {
                    let array = try JSONSerialization.jsonObject(with: contentsJson.data(using: String.Encoding.utf8)!, options: []) as! [AnyObject]
                    if !array.isEmpty {
                        let count = array.count
                        var pointsToUse: [CLLocationCoordinate2D] = []
                        
                        for i in 0...count-1 {
                            if let dict = array[i] as? [String : AnyObject] {
                                let lat = dict["lat"] as? Double
                                let lon = dict["lon"] as? Double
                                
                                pointsToUse += [CLLocationCoordinate2DMake(lat!, lon!)]
                            }
                        }

                        let polyLine = PolyLineAnnotation(coordinates: &pointsToUse, count: count)

                        let history = OTSingleton.sharedInstance().bitCarrierVector.retrieveVectors(object.vector_id!, max: 1)
                        if !history.isEmpty {
                            if let vector = history[0].levelOfService {
                                polyLine.levelOfService = String(format: "%@", vector)
                            }
                        } else {
                            polyLine.levelOfService = "unknown"
                        }
                        return polyLine
                    }
                } catch {
                    print ("Bad data in sketch")
                }
            }
        }
        return nil
    }
    
}

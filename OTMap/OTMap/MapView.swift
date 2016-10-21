//
//  MapView.swift
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
import MapKit
import oneTRANSPORT

protocol MapViewProtocol: class {
    func didSelectPin(_ point : PointAnnotation)
    func didChangeRegion()
}

class MapView: MKMapView {

    weak var delegateParent : MapViewProtocol?
    var currentZoom : CGFloat = -1.0
    weak var dataSource : MapDataSource! = MapDataSource()
    var shouldClusterPins = false
    let clusterManager = ClusterManager()
    
    var oldCoord1 = CLLocationCoordinate2D()
    var oldCoord2 = CLLocationCoordinate2D()
    var oldZoom = CGFloat()
    
    func setupDataSource(_ dataSource : MapDataSource, showLocation : Bool) {

        self.showsUserLocation = showLocation
        self.delegate = self
        self.dataSource = dataSource

        self.refreshDataSource()
    }
    
    func refreshDataSource() {
        
        let innerLeft  = CGPoint(x: -self.bounds.maxX*0.75, y: -self.bounds.maxY*0.75)
        let innerRight = CGPoint(x: self.bounds.maxX*1.75, y: self.bounds.maxY*1.75)
        self.oldCoord1 = self.convert(innerLeft, toCoordinateFrom: self)
        self.oldCoord2 = self.convert(innerRight, toCoordinateFrom: self)
        self.oldZoom = self.currentZoom
        
        let topLeft  = CGPoint(x: -self.bounds.maxX, y: -self.bounds.maxY)
        let botRight = CGPoint(x: self.bounds.maxX*2, y: self.bounds.maxY*2)
        let coord1 = self.convert(topLeft, toCoordinateFrom: self)
        let coord2 = self.convert(botRight, toCoordinateFrom: self)

        self.dataSource.setupData(coord1: coord1, coord2: coord2)
    }
    
    func refreshMapPins() {
        
        self.oldZoom = 0;
        self.currentZoom = -1;
        self.mapView(self, regionDidChangeAnimated: true)
    }
    
    func mapViewDidZoom() -> Bool {

        let newZoom = CGFloat(self.visibleMapRect.size.width * self.visibleMapRect.size.height)
        if self.currentZoom == newZoom {
            return false
        } else {
            self.currentZoom = newZoom
            return true
        }
    }
    
    func setPinsToRemove() {
        //filter out any pins that we don't want to remove, e.g. ourself, destination, etc
    }
    
    func addSketches(_ always: Bool) {
        
        self.removeOverlays(self.overlays)
        
        if always || CellRequest.bitCarrier.getUserDefaultsValue() {
            let arrayObjects = OTSingleton.sharedInstance().bitCarrierSketch.retrieveAll(nil)
            for object in arrayObjects {
                if let polyline = self.dataSource.sketch(object as! BC_Sketch) {
                    self.add(polyline)
                }
            }
        }
    }
}

extension MapView : MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {

        if annotation.isKind(of: ClusterAnnotation.self) {
            let object = annotation as! ClusterAnnotation
            let cellId = object.getCellId()
            var ann = self.dequeueReusableAnnotationView(withIdentifier: cellId) as? AnnotationView
            if ann == nil {
                ann = AnnotationView(annotation: annotation, reuseIdentifier: cellId)
            }
            ann!.isCluster = true
            ann!.reference = object.reference
            ann!.counter = object.counter
            ann!.setupImage(object.annotationType)
            
            object.pointerToView = ann
            return ann
        } else if annotation.isKind(of: PointAnnotation.self) {
            let object = annotation as! PointAnnotation
            let cellId = object.getCellId()
            var ann = self.dequeueReusableAnnotationView(withIdentifier: cellId) as? AnnotationView
            if ann == nil {
                ann = AnnotationView(annotation: annotation, reuseIdentifier: cellId)
            }
            ann!.isCluster = false
            ann!.reference = object.reference
            ann!.counter = object.counter
            ann!.counterSub = object.counterSub
            ann!.angleForArrow = object.angleForArrow
            ann!.setupImage(object.annotationType)

            object.pointerToView = ann
            return ann
        }
        
        return nil
    }

    func mapView(_ mapView: MKMapView, didAdd views: [MKAnnotationView]) {
     
        //remove obsolete pins
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        
        if view.annotation!.isKind(of: PointAnnotation.self) {
            self.delegateParent?.didSelectPin(view.annotation as! PointAnnotation)
        }
    }
 
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        
        let middle  = CGPoint(x: -self.center.x, y: -self.center.y)
        let coord = self.convert(middle, toCoordinateFrom: self)
        let inSameRegion = (Double(self.oldCoord1.latitude) >= Double(coord.latitude) && Double(self.oldCoord1.longitude) <= Double(coord.longitude) &&
            Double(self.oldCoord2.latitude) <= Double(coord.latitude) && Double(self.oldCoord2.longitude) >= Double(coord.longitude))

        if !inSameRegion || self.oldZoom != self.currentZoom {
            self.refreshDataSource()
            let count = self.dataSource.arrayPinsUnfiltered.count
            if count > 0 && self.mapViewDidZoom() {
                self.setPinsToRemove()

                if self.shouldClusterPins {
                    self.removeAnnotations(self.annotations)

                    let zoomFactor = CGFloat(Float(self.visibleMapRect.size.width) / Float(self.bounds.size.width))

                    let arrayClusterType : [ObjectType] = [.variableMessageSigns, .trafficFlow, .trafficQueue, .trafficSpeed, .trafficScoot, .trafficTime, .carParks, .roadworks]
                    for type in arrayClusterType {
                        let array = self.dataSource.pinsOfType(type)
                        if array.count > 0 {
                            self.clusterManager.clustersForAnnotations(array, zoom: zoomFactor) { pins in
                                DispatchQueue.main.async {
                                    for point in pins {
                                        point.addedToMapView = true
                                        self.addAnnotation(point)
                                    }
                                }
                            }
                        }
                    }
                } else {
                    var i = count - 1
                    for _ in 0..<count {
                        let point = self.dataSource.arrayPinsUnfiltered[i]
                        if point.remove {
                            if point.addedToMapView {
                                self.removeAnnotation(point)
                            }
                            self.dataSource.arrayPinsUnfiltered.remove(at: i)
                        }
                        i -= 1
                    }
                    
                    for point in self.dataSource.arrayPinsUnfiltered {
                        if !point.addedToMapView {
                            point.addedToMapView = true
                            self.addAnnotation(point)
                        }
                    }
                }
            }
        }
        self.delegateParent?.didChangeRegion()
    }

//    func addPoint(point : PointAnnotation) {
//        
//        let index = [self.annotations.contains(where: { (,$0.coordinate.latitude == point.coordinate.latitude) -> Bool in
//            
//        })
//
//        
//        }
//    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        
        if overlay is PolyLineAnnotation {
            let objectOverlay = overlay as! PolyLineAnnotation
            
            let lineView = MKPolylineRenderer(overlay: objectOverlay)
            
            if objectOverlay.levelOfService == "green" {
                lineView.strokeColor = UIColor.green
            } else if objectOverlay.levelOfService == "red" {
                lineView.strokeColor = UIColor.red
            } else if objectOverlay.levelOfService == "yellow" {
                lineView.strokeColor = UIColor.yellow
            } else {
                lineView.strokeColor = UIColor.gray
            }
            return lineView
        }
        return MKOverlayRenderer()
    }
}

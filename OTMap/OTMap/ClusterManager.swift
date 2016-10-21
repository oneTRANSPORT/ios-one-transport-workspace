//
//  ClusterManager.swift
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

class ClusterManager: NSObject {

    var zoomFactor : CGFloat = 0.0
    
    func clustersForAnnotations(_ arrayAnnotations: [PointAnnotation], zoom: CGFloat, completionBlock:@escaping ([PointAnnotation])->Void) {
 
        self.zoomFactor = zoom
        
        let opQ = OperationQueue.init()
        opQ.addOperation { 

            var processed : [PointAnnotation] = []
            var final : [PointAnnotation] = []
            var remainder : [PointAnnotation] = []
            remainder.append(contentsOf: arrayAnnotations)
            
            for point in arrayAnnotations {
                if !processed.contains(point) {
                    processed.append(point)
                
                    if (point.avoidsClusters) {
                        final.append(point)
                    } else {
                        let neighbours = self.findNeighboursForAnnotation(point, inNeighbourhood: remainder, zoom: zoom)
                        if neighbours.count == 0 {
                            processed.append(point)
                            final.append(point)
                        } else {
                            processed.append(contentsOf: neighbours)

                            let cluster = ClusterAnnotation.init()
                            cluster.annotationType = point.annotationType
                            cluster.reference = "Cluster around \(point.reference)"
                            cluster.arrayAnnotations.append(contentsOf: neighbours)
                            cluster.arrayAnnotations.append(point)
                            cluster.counter = neighbours.count
                            cluster.coordinate = cluster.clusterCentre()
                            final.append(cluster)
                        }

                        for processedObject in processed {
                            var count = 0
                            for remainderObject in remainder {
                                if remainderObject == processedObject {
                                    remainder.remove(at: count)
                                    break
                                }
                                count += 1
                            }
                        }
                    }
                }
            }
            
            completionBlock(final)
        }
    }
    
    func approxDistance(_ coord1 : CLLocationCoordinate2D, coord2 : CLLocationCoordinate2D) -> Int {
        
        let mapPoint1 = MKMapPointForCoordinate(coord1)
        let mapPoint2 = MKMapPointForCoordinate(coord2)
        let distance = MKMetersBetweenMapPoints(mapPoint1, mapPoint2)
        return Int(distance/1000)
    }

    func shouldAvoidClusterAnnotation(_ annotation : AnyObject) -> Bool {
        
        if annotation.isKind(of: MKUserLocation.self) {
            return true
        }
        
        if annotation.isKind(of: PointAnnotation.self) {
            let object = annotation as! PointAnnotation
            return object.avoidsClusters
        }
        
        return false
    }

    func findNeighboursForAnnotation(_ ann : PointAnnotation, inNeighbourhood : [PointAnnotation], zoom : CGFloat) -> [PointAnnotation] {
        
        var distance : Int
        if ann.annotationType == .variableMessageSigns {
            if zoom < 100 {
                distance = 0
            } else if zoom < 250 {
                distance = 1
            } else if zoom < 1000 {
                distance = 2
            } else if zoom < 2000 {
                distance = 10
            } else if zoom < 5000 {
                distance = 20
            } else {
                distance = 100
            }
        } else {
            if zoom < 64 {
                distance = 0
            } else if zoom < 50 {
                distance = 1
            } else if zoom < 100 {
                distance = 3
            } else if zoom < 250 {
                distance = 6
            } else if zoom < 1000 {
                distance = 10
            } else if zoom < 2000 {
                distance = 20
            } else if zoom < 5000 {
                distance = 50
            } else {
                distance = 100
            }
        }
        
        var arrayNearbyPoints : [PointAnnotation] = []
        
        if distance > 0 {
            for point in inNeighbourhood {
                if point != ann && !self.shouldAvoidClusterAnnotation(point) {
                    if point.coordinate.latitude != ann.coordinate.latitude || point.coordinate.longitude != ann.coordinate.longitude {
                        if self.approxDistance(ann.coordinate, coord2: point.coordinate) < distance {
                            arrayNearbyPoints.append(point)
                        }
                    }
                }
            }
        }
        
        return arrayNearbyPoints
    }
    
}

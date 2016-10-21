//
//  ClusterAnnotation.swift
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

class ClusterAnnotation: PointAnnotation {

    var arrayAnnotations : [PointAnnotation] = []

    func clusterCentre() -> CLLocationCoordinate2D {
        
        var lat = 0.0
        var lon = 0.0
        var count = 0.0
        
        for object in arrayAnnotations {
            lat += object.coordinate.latitude
            lon += object.coordinate.longitude
            count += 1
        }
        
        return CLLocationCoordinate2DMake(lat/count, lon/count);
    }

    override func getCellId() ->String {
        
        var key = ""
        switch self.annotationType {
        case .variableMessageSigns:
            key = "ClusterVariableSigns"
        case .carParks:
            key = "ClusterCarParks"
        case .trafficFlow:
            key = "ClusterTrafficFlow"
        case .trafficQueue:
            key = "ClusterTrafficQueue"
        case .trafficSpeed:
            key = "ClusterTrafficSpeed"
        case .trafficScoot:
            key = "ClusterTrafficScoot"
        case .trafficTime:
            key = "ClusterTrafficTime"
        case .roadworks:
            key = "ClusterRoadWorks"
        case .events:
            key = "ClusterEvents"
        case .bitCarrier:
            key = "ClusterBitCarrier"
        case .clearView:
            key = "ClusterClearView"
        }
        return key
    }
}

//
//  PointAnnotation.swift
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

class PointAnnotation: MKPointAnnotation {

    var reference : String = ""
    var annotationType : ObjectType = .variableMessageSigns
    var pointerToView : AnnotationView? = nil
    var counter : Int = 0
    var counterSub : Int = 0
    var angleForArrow : Float = 0.0
    var image : UIImage? = nil
    var avoidsClusters = false
    var remove = false
    var addedToMapView = false
    
    func getCellId() ->String {
        
        var key = ""
        switch self.annotationType {
        case .variableMessageSigns:
            key = "CellVariableSigns"
        case .carParks:
            key = "CellCarParks"
        case .trafficFlow:
            key = "CellTrafficFlow"
        case .trafficQueue:
            key = "CellTrafficQueue"
        case .trafficSpeed:
            key = "CellTrafficSpeed"
        case .trafficScoot:
            key = "CellTrafficScoot"
        case .trafficTime:
            key = "CellTrafficTime"
        case .roadworks:
            key = "CellRoadWorks"
        case .events:
            key = "CellEvents"
        case .bitCarrier:
            key = "CellBitCarrier"
        case .clearView:
            key = "CellClearView"
        }
        return key
    }

}

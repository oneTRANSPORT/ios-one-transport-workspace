//
//  AnnotationView.swift
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

class AnnotationView: MKAnnotationView {

    var annotationType : ObjectType = .variableMessageSigns
    var isCluster = false
    var title = ""
    var reference = ""
    var counter = 0
    var counterSub = 0
    var angleForArrow : Float = 0.0
    var hideCustomView = false
    var warningLevel = 0.0
    
    let kCustomViewTag = 981
    let kDirectionTag = 982
    
    func setupImage(_ objectType : ObjectType) {
        
        self.annotationType = objectType
        
        self.canShowCallout = false
        
        var key = ""
        if (self.isCluster) {
            key = self.getImagePathCluster()
        } else {
            key = self.getImagePathFull()
            if key == "" {
                key = self.getImagePath()
            }
        }
        
        self.image = UIImage.init(named: key)
        self.centerOffset = CGPoint(x: 0, y: 0)
        self.layer.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        self.transform = self.transform.rotated(by: 0)
        self.layer.zPosition = self.getZPosition()
        
        self.directionAdd()
        self.customViewAdd()
    }
    
    func customViewRemove() {
        
        if let view = self.viewWithTag(kCustomViewTag) {
            view.removeFromSuperview()
        }
    }
    
    func customViewFrame(_ size : CGSize) -> CGRect {
        
        let boxWidth : CGFloat = size.width
        let boxHeight : CGFloat = size.height
        
        return CGRect(x: fabs((self.frame.size.width - boxWidth) / 2), y: fabs((self.frame.size.height - boxHeight) / 2), width: boxWidth, height: boxHeight)
    }
    
    func customViewAdd() {
        
        self.customViewRemove()
        if self.isCluster || self.hideCustomView {
            return
        }
            
        switch self.annotationType {
        case .carParks:
            if self.counterSub == 0 {
                return
            }
        case .trafficFlow, .trafficQueue, .trafficSpeed, .trafficScoot, .trafficTime:
            break
        default:
            return
        }
        
        let view = UIView.init(frame: self.customViewFrame(self.frame.size))
        view.backgroundColor = UIColor.clear
        view.tag = kCustomViewTag
        self.addSubview(view)

        let label = self.newLabel()
        
        switch self.annotationType {
        case .trafficFlow, .trafficQueue, .trafficSpeed, .trafficScoot, .trafficTime:
            if self.counter > 0 {
                label.frame = CGRect(x: view.frame.size.width / 2, y: view.frame.size.height * 0.25, width: view.frame.size.width / 2, height: view.frame.size.height * 0.75)
//                label.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height)
                label.layer.shadowColor = UIColor.init(red: 7.0/255.0, green: 134.0/255.0, blue: 27.0/255.0, alpha: 1.0).cgColor
                label.text = "\(self.counter)"
            } else {
                label.frame = CGRect(x: view.frame.size.width / 2, y: view.frame.size.height * 0.25, width: view.frame.size.width / 2, height: view.frame.size.height * 0.75)
                label.layer.shadowColor = UIColor.init(red: 7.0/255.0, green: 134.0/255.0, blue: 27.0/255.0, alpha: 1.0).cgColor
                label.text = "\(self.counterSub)"
            }
        case .carParks:
            if self.counter >= 0 {
                let labelCapacity = self.newLabel()
                labelCapacity.frame = CGRect(x: 2, y: 2, width: view.frame.size.width-4.0, height: view.frame.size.height * 0.5)
                labelCapacity.layer.shadowColor = UIColor.init(red: 47.0/255.0, green: 79.0/255.0, blue: 203.0/255.0, alpha: 1.0).cgColor
                labelCapacity.text =  "\(self.counter)%"
                view.addSubview(labelCapacity)
            }
            label.frame = CGRect(x: view.frame.size.width / 2, y: view.frame.size.height * 0.25, width: view.frame.size.width / 2, height: view.frame.size.height * 0.75)
            label.layer.shadowColor = UIColor.init(red: 47.0/255.0, green: 79.0/255.0, blue: 203.0/255.0, alpha: 1.0).cgColor
            label.text = "\(self.counterSub)"
        default:
            break
        }
        view.addSubview(label)
    }
    
    func newLabel() -> UILabel {
        let label = UILabel.init()
        label.textAlignment = .center
        label.textColor = UIColor.white
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.1
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.layer.shadowRadius = 2.0
        label.layer.shadowOpacity = 1.0
        return label
    }
    
    func directionRemove() {
        
        if let view = self.viewWithTag(kDirectionTag) {
            view.removeFromSuperview()
        }
    }

    func directionAdd() {
        
        self.directionRemove()
        if self.angleForArrow == 0 {
            return
        }
        
        let view = UIImageView.init(frame: self.customViewFrame(CGSize.init(width: 25, height: 25)))
        view.image = UIImage.init(named: "arrow")
        view.backgroundColor = UIColor.clear
        view.tag = kDirectionTag
        self.addSubview(view)
        view.transform = CGAffineTransform(rotationAngle: CGFloat(self.angleForArrow) + CGFloat(Double.pi))
        
    }
    
    func getZPosition() ->CGFloat {
        
        var key : CGFloat = 0
        switch self.annotationType {
        case .variableMessageSigns:
            key = 10
        case .carParks:
            key = 20
        case .trafficFlow, .trafficQueue, .trafficSpeed, .trafficScoot, .trafficTime:
            key = 15
        case .roadworks:
            key = 5
        case .events:
            key = 4
        default:
            key = 1
        }
        return key
    }
    
    func getImagePathFull() ->String {
        
        var key = ""
        switch self.annotationType {
        case .carParks:
            if self.counter == -1 || self.counter == 100 {
                key = "carpark_full_icon"
            }
        default:
            key = ""
        }
        return key
    }

    func getImagePath() ->String {
        
        var key = ""
        switch self.annotationType {
        case .variableMessageSigns:
            key = "vm_sign_icon"
        case .carParks:
            key = "carpark_icon"
        case .trafficFlow:
            key = "anpr_icon"
        case .trafficQueue:
            key = "queue_icon"
        case .trafficSpeed:
            key = "speed_icon"
        case .trafficScoot:
            key = "scoot_icon"
        case .trafficTime:
            key = "travel_time_icon"
        case .roadworks:
            key = "roadworks_icon"
        case .events:
            key = "events_icon"
        case .bitCarrier:
            key = "bitcarrier_icon"
        case .clearView:
            key = "clearview_icon"
        }
        return key
    }
    
    func getImagePathCluster() ->String {
        
        var key = ""
        switch self.annotationType {
        case .variableMessageSigns:
            key = "vms_cluster_icon"
        case .carParks:
            key = "carpark_cluster_icon"
        case .trafficFlow:
            key = "anpr_cluster_icon"
        case .trafficQueue:
            key = "queue_cluster_icon"
        case .trafficSpeed:
            key = "speed_cluster_icon"
        case .trafficScoot:
            key = "scoot_cluster_icon"
        case .trafficTime:
            key = "travel_time_cluster_icon"
        case .roadworks:
            key = "roadworks_cluster_icon"
        case .events:
            key = "events_cluster_icon"
        case .bitCarrier:
            key = "bitcarrier_cluster_icon"
        case .clearView:
            key = "clearview_cluster_icon"
        }
        return key
    }

}

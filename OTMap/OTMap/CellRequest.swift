//
//  CellRequest.swift
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

import Foundation
import oneTRANSPORT

enum CellRequest {
    case notSet
    
    case variableMessageSigns
    case trafficFlow
    case trafficQueue
    case trafficSpeed
    case trafficScoot
    case trafficTime
    case carParks
    case roadworks
    case events
    
    case variableMessageSignsActive
    case carParksNotFull
    
    case bitCarrier
    case clearView
    
    case favourites
    
    case la_Bucks
    case la_Northants
    case la_Oxon
    case la_Herts
    case la_Birmingham
    
    func getCellId() ->String {
     
        return "CellSwitch"
    }
    
    func getHeading() ->String {
     
        var key : String
        switch self {
        case .variableMessageSigns:
            key = "Variable Signs"
        case .trafficFlow:
            key = "Traffic Flow"
        case .trafficQueue:
            key = "Traffic Queues"
        case .trafficSpeed:
            key = "Traffic Speeds"
        case .trafficScoot:
            key = "Traffic Scoots"
        case .trafficTime:
            key = "Traffic Times"
        case .carParks:
            key = "Car Parks"
        case .roadworks:
            key = "Roadworks"
        case .events:
            key = "Traffic Events"
            
        case .variableMessageSignsActive:
            key = "Active Variable Signs only"
        case .carParksNotFull:
            key = "Car Parks With Spaces"
        case .bitCarrier:
            key = "BitCarrier Traffic"
        case .clearView:
            key = "ClearView Parking"
        case .favourites:
            key = "Favourites Only"

        case .la_Bucks:
            key = "Buckinghamshire"
        case .la_Northants:
            key = "Northamptonshire"
        case .la_Oxon:
            key = "Oxfordshire"
        case .la_Herts:
            key = "Hertfordshire"
        case .la_Birmingham:
            key = "Birmingham"
            
        default:
            key = ""
        }
        
        return key
    }
    
    func getBackgroundColor() ->UIColor {
        
        var key : UIColor
        switch self {
        case .la_Bucks, .la_Northants, .la_Oxon, .la_Herts, .la_Birmingham:
            key = UIColor.lightGray
        case .bitCarrier, .clearView:
            key = UIColor.yellow
        default:
            key = UIColor.white
        }
        return key
    }
    
    func getActive() ->CellRequest {
        
        var key : CellRequest
        switch self {
        case .variableMessageSigns:
            key = .variableMessageSignsActive
        case .carParks:
            key = .carParksNotFull
        default:
            key = .notSet
            break
        }

        return key
    }

    func getAnnotationType() ->ObjectType {
        
        var key : ObjectType
        switch self {
        case .variableMessageSigns:
            key = .variableMessageSigns
        case .trafficFlow:
            key = .trafficFlow
        case .trafficQueue:
            key = .trafficQueue
        case .trafficSpeed:
            key = .trafficSpeed
        case .trafficScoot:
            key = .trafficScoot
        case .trafficTime:
            key = .trafficTime
        case .carParks:
            key = .carParks
        case .roadworks:
            key = .roadworks
        case .events:
            key = .events
        case .bitCarrier:
            key = .bitCarrier
        case .clearView:
            key = .clearView
            
        default:
            key = .variableMessageSigns
            break
        }
        
        return key
    }
    
    func getLaType() ->LocalAuthority {
        
        var key : LocalAuthority
        switch self {
        case .la_Bucks:
            key = .bucks
        case .la_Northants:
            key = .northants
        case .la_Oxon:
            key = .oxon
        case .la_Herts:
            key = .herts
        case .la_Birmingham:
            key = .birmingham
        default:
            key = .bucks
        }
        
        return key
    }
    
    func getUserDefaultsKey() ->String {
     
        var key : String
        switch self {
        case .la_Bucks, .la_Northants, .la_Oxon, .la_Herts, .la_Birmingham:
            key = OTSingleton.sharedInstance().getUserDefault(self.getLaType())
        case .variableMessageSigns,
             .trafficFlow, .trafficQueue, .trafficSpeed, .trafficScoot, .trafficTime,
             .carParks, .roadworks, .events, .bitCarrier, .clearView:
            key = OTSingleton.sharedInstance().getObjectClass(self.getAnnotationType()).userDefaultsUse
        case .variableMessageSignsActive:
            key = "UserDefaultsVariableSignsActive"
        case .carParksNotFull:
            key = "UserDefaultsCarParksNotFull"
        case .favourites:
            key = "UserDefaultsFavouritesOnly"
        default:
            key = ""
        }
        
        return key
    }
    
    func getUserDefaultsValue() ->Bool {
   
        let key = self.getUserDefaultsKey()
        
        if UserDefaults.standard.value(forKey: key) == nil {
            return false
        } else {
            return UserDefaults.standard.bool(forKey: key)
        }
    }
    
    func setUserDefaultsValue(_ value : Bool) {
        
        UserDefaults.standard.set(value, forKey:self.getUserDefaultsKey())
    }
}

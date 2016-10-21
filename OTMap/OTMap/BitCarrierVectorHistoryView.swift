//
//  BitCarrierVectorHistoryView.swift
//  OTMap
//
//  Created by Dominic Frazer Imregh on 08/09/2016.
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

class BitCarrierVectorHistoryView: UIView {

    var arraySpeeds : [CGFloat] = []
    var speedMin : CGFloat = 0
    var speedMax : CGFloat = 0
    
    func configure(_ reference: String!) {
        
        self.buildChart(NSPredicate.init(format: "from_location == %@ || to_location == %@", reference, reference))
    }

    func configureIndividual(_ from: String!, to: String!) {
        
        self.buildChart(NSPredicate.init(format: "from_location == %@ AND to_location == %@", from, to))
    }

    func buildChart(_ predicate: NSPredicate) {
        
        arraySpeeds.removeAll()
        speedMin = 99999
        speedMax = 0
        
        let singleton = OTSingleton.sharedInstance()
        if let array : [BC_ConfigVector] = singleton.bitCarrierConfigVector.retrieveAll(predicate) as? [BC_ConfigVector] {
            for vconfig in array {
                let arrayVector = singleton.bitCarrierVector.retrieveVectors(vconfig.reference, max: 100)
                if !arrayVector.isEmpty {
                    for vector in arrayVector {
                        if let speedFloat = vector.speed?.floatValue {
                            let speed = CGFloat(speedFloat)
                            arraySpeeds.append(speed)
                            
                            if speed < speedMin {
                                speedMin = speed
                            }
                            if speed > speedMax {
                                speedMax = speed
                            }
                        }
                    }
                    break
                }
            }
        }
        self.setNeedsDisplay()
    }

    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        if speedMax <= 0 {
            return
        }
        
        let context = UIGraphicsGetCurrentContext()
        context?.setLineWidth(2.0)
        context?.setStrokeColor(UIColor.gray.cgColor)
        
        var i : CGFloat = 0.0
        for speed in self.arraySpeeds {
            let offset = (speed / speedMax) * 40.0
            
            if i == 0 {
                context?.move(to: CGPoint(x: 0.0, y: 40.0 - offset))
            } else {
                context?.addLine(to: CGPoint(x: i, y: 40 - offset))
            }
            i += 2.0
        }
        context?.strokePath();
    }

}

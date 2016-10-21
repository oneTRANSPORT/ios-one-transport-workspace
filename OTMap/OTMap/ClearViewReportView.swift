//
//  ClearViewReportView.swift
//  OTMap
//
//  Created by Dominic Frazer Imregh on 19/09/2016.
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

class ClearViewReportView: UIView {
    
    var arrayValues : [CGFloat] = []
    var rangePixel = CGFloat(1.0)
    var colour = UIColor()
    var reference = ""
    var heightRatio = CGFloat(0.0)
    
    func configure(_ reference : String, colour : UIColor, dateStart : Date, dateEnd : Date, array : [[AnyHashable: Any]], heightRatio : CGFloat) {

        self.reference = reference
        self.colour = colour
        self.heightRatio = heightRatio
        arrayValues.removeAll()
        
        let dateStartInterval = dateStart.timeIntervalSince1970
        rangePixel = CGFloat((dateEnd.timeIntervalSince1970 - dateStartInterval) / Double(self.bounds.width))

        var startCount : CGFloat = 0.0
        for dict in array {
            let creationtime = dict["creationtime"]!
            let offset = CGFloat((creationtime as AnyObject).timeIntervalSince1970 - dateStartInterval) / rangePixel
            
            let direction = dict["direction"]! as! Int
            let counter = dict["counter"]! as! Int
            if direction == 0 {
                startCount -= CGFloat(counter)
            } else {
                startCount += CGFloat(counter)
            }
            
            arrayValues.append(offset)
            arrayValues.append(startCount)
        }

        self.backgroundColor = UIColor.clear
        self.setNeedsDisplay()
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        if arrayValues.count == 0 {
            return
        }
        
        if let context = UIGraphicsGetCurrentContext() {
            context.setLineWidth(2.0)
            context.setStrokeColor(self.colour.cgColor)
            
            var i = 0
            while i < arrayValues.count {
                let x = arrayValues[i]
                let y = (self.bounds.height / 2) - (arrayValues[i+1] / self.heightRatio)
                
                if i == 0 {
                    context.move(to: CGPoint(x: x, y: y))
                }
                
                context.addLine(to: CGPoint(x: x, y: y))
                
                i += 2
            }
            
            context.strokePath();
        }
    }
}

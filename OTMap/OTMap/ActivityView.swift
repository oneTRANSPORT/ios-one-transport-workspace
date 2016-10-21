//
//  ActivityView.swift
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

class ActivityView: UIView {
    
    let activityViewTag = 9999998
    
    func start() {
        
        DispatchQueue.main.async {
            if self.viewWithTag(self.activityViewTag) == nil {
                let imageView = UIImageView.init(frame: self.bounds)
                imageView.tag = self.activityViewTag
                imageView.image = UIImage.init(named: "OneT_60")
                self.addSubview(imageView)
                
                let indicator = UIActivityIndicatorView.init(frame: self.bounds)
                indicator.activityIndicatorViewStyle  = .whiteLarge
                indicator.startAnimating()
                self.addSubview(indicator)
            }
            
            self.alpha = 0.0
            self.isHidden = false
            UIView.animate(withDuration: 0.5, animations: {
                self.alpha = 1.0
            }) 
        }
    }
    
    func stop() {
        
        DispatchQueue.main.async {
            if self.alpha != 0.0 {
                UIView.animate(withDuration: 0.5, animations: {
                    self.alpha = 0.0
                }, completion: { (Bool) in
                    self.isHidden = true
                }) 
            }
        }
    }
}

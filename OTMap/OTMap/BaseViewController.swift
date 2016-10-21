//
//  BaseViewController.swift
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

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    
    }

    func showMessage(_ message: String, completionHandler:@escaping () -> Void) {
        
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: "oneTRANSPORT", message: message, preferredStyle: UIAlertControllerStyle.alert)
            
            let dismissAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) { (action) -> Void in
                completionHandler()
            }
            
            alertController.addAction(dismissAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }

}

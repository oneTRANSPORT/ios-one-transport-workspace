//
//  BitCarrierViewController.swift
//  OTMap
//
//  Created by Dominic Frazer Imregh on 06/09/2016.
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

class BitCarrierViewController: BaseViewController {

    @IBOutlet weak var activityIndicator: ActivityView!
    @IBOutlet weak var textField1: UITextField!
    @IBOutlet weak var textField2: UITextField!
    @IBOutlet weak var textLog: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.textLog.text = ""
        
    }

    func showCompleted(_ success : Bool) {
        
        self.activityIndicator.stop()
        self.showMessage(success ? "Data Loaded" : "Failed to load, check TSV file matches oneTransport requirements", completionHandler: { })
    }

    @IBAction func pressedRetrieveBitCarrier() {
        
        self.activityIndicator.start()

        let ae = OTSingleton.sharedInstance().cse?.createAe(withId: k_AE_ID_BitCarrier, name: k_AE_ID_BitCarrier)
        let cnt = ae?.createContainer(withName: "BitCarrier")
        let cin = cnt?.createContentInstance(withName: self.textField1.text!)
        cin!.remoteRequest(.get, subMethod: .latest, session: OTSingleton.sharedInstance().sessionTask) {response, error in
            if error == nil {
                self.textLog.text = String.init(format: "%@\nContent=\n%@", response!, cin!.content)
            } else {
                self.showMessage(error!.localizedDescription, completionHandler: {})
            }
            self.activityIndicator.stop()
        }
    }

    @IBAction func pressedRetrieveClearView() {
        
        self.activityIndicator.start()
        
        let ae = OTSingleton.sharedInstance().cse?.createAe(withId: k_AE_ID_ClearView, name: k_AE_ID_ClearView)
        let cin = ae?.createContentInstance(withName: self.textField2.text!)
        cin!.remoteRequest(.get, subMethod: .latest, session: OTSingleton.sharedInstance().sessionTask) {response, error in
            if error == nil {
                self.textLog.text = String.init(format: "%@\nContent=\n%@", response!, cin!.content)
            } else {
                self.showMessage(error!.localizedDescription, completionHandler: {})
            }
            self.activityIndicator.stop()
        }
    }

}

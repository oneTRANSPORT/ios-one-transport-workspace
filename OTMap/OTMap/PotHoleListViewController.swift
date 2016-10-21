//
//  PotHoleListViewController.swift
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

let kPotHoleAE = "C-IOS-AE-USER-DATA"
let kPotHoleCNT = "POT-HOLES"

class PotHoleListViewController: BaseViewController {

    @IBOutlet weak var activityIndicator: ActivityView!
    @IBOutlet weak var textView: UITextView!

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.listPotHoles()
    }
    
    func listPotHoles() {
        
        self.activityIndicator.start()
        
        let ae = OTSingleton.sharedInstance().cse?.createAe(withId: kPotHoleAE, name: kPotHoleAE)
        let cnt = ae?.createContainer(withName: kPotHoleCNT)
        cnt!.remoteRequest(.create, subMethod: .none, session: OTSingleton.sharedInstance().sessionTask) {response, error in
//        cnt!.remoteRequest(.discoverViaRcn, subMethod: .none, session: OTSingleton.sharedInstance().sessionTask) {response, error in
            if error == nil {
                self.textView.text = "\(response)"
                if let dictCh = response?[kKey_Response_Cnt] as? [String : AnyObject] {
                    if let arrayCnt = dictCh["ch"] as? [[String : AnyObject]] {
                        for dictCnt in arrayCnt {
                            if let contentName = dictCnt["-nm"] as? String {
                                let content = cnt!.createContentInstance(withName: contentName)
                                content?.remoteRequest(.get, subMethod: .none, session: OTSingleton.sharedInstance().sessionTask) {response, error in
                                    DispatchQueue.main.async {
                                        self.textView.text = String.init(format: "%@\n\n%@", self.textView.text, response!)
                                    }
                                }
                            }
                        }
                    }
                }
            } else {
                self.showMessage(error!.localizedDescription, completionHandler: {})
            }
            self.activityIndicator.stop()
        }
    }
    
}

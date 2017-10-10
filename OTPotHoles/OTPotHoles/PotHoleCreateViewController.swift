//
//  PotHoleCreateViewController.swift
//  OTPotHoles
//
//  Created by Dominic Frazer Imregh on 21/10/2016.
//  Copyright © 2016 InterDigital. All rights reserved.
//

import UIKit
import oneTRANSPORT

class PotHoleCreateViewController: BaseViewController {
    
    @IBOutlet weak var activityIndicator: ActivityView!
    @IBOutlet weak var textView: UITextView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.createPotHoleContainer()
    }
    
    func createPotHoleContainer() {
        
        self.activityIndicator.start()
        
        let ae = OTSingleton.sharedInstance().cse?.createAe(withId: APP_ID, name: APP_ID)
        let cnt = ae?.createContainer(withName: kPotHoleCNT)
        cnt!.remoteRequest(.create, subMethod: .none, session: OTSingleton.sharedInstance().sessionTask) {response, error in
            if error == nil {
                self.textView.text = "\(String(describing: response))"
                self.showMessage("One time creation of Pot Hole Container completed", completionHandler: {})
            } else {
                self.showMessage(error!.localizedDescription, completionHandler: {})
            }
            self.activityIndicator.stop()
        }
    }
    
}

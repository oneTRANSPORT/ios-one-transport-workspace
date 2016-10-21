//
//  BitCarrierTsvViewController.swift
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
import oneTRANSPORT

class BitCarrierTsvViewController: BaseViewController {

    @IBOutlet weak var activityIndicator: ActivityView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    func showCompleted(_ success : Bool) {
        
        self.activityIndicator.stop()
        self.showMessage(success ? "Data Loaded" : "Failed to load, check TSV file matches oneTransport requirements", completionHandler: { })
        
    }

    @IBAction func pressedClearAndLoadAll() {
        self.activityIndicator.start()
        DispatchQueue.global(qos: DispatchQoS.QoSClass.userInitiated).async {
            OTSingleton.sharedInstance().bitCarrierNode.populateTSV(self.prepareStringData("bit_carrier_silverstone_node.tsv")) { success in
                let arrayCommon = OTSingleton.sharedInstance().bitCarrierNode.returnNodesForCommon()
                OTSingleton.sharedInstance().common.populateTable(with: arrayCommon, type: OTSingleton.sharedInstance().bitCarrierNode.dataType)

                OTSingleton.sharedInstance().bitCarrierSketch.populateTSV(self.prepareStringData("bit_carrier_silverstone_sketch.tsv")) { success in
             
                    OTSingleton.sharedInstance().bitCarrierTravel.populateTSV(self.prepareStringData("bit_carrier_silverstone_travel_summary.tsv")) { success in

                        OTSingleton.sharedInstance().bitCarrierVector.populateTSV(self.prepareStringData("bit_carrier_silverstone_data_vector.tsv")) { success in

                            OTSingleton.sharedInstance().bitCarrierConfigVector.populateTSV(self.prepareStringData("bit_carrier_silverstone_config_vector.tsv")) { success in

                                OTSingleton.sharedInstance().clearViewDevice.populateTSV(self.prepareStringData("clearview_silverstone_device.tsv")) { success in

                                    OTSingleton.sharedInstance().clearViewTraffic.populateTSV(self.prepareStringData("clearview_silverstone_traffic.tsv")) { success in

                                        self.showCompleted(success)
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    @IBAction func pressedClearAndLoadNodes() {
        
        self.activityIndicator.start()
        DispatchQueue.global(qos: DispatchQoS.QoSClass.userInitiated).async {
            OTSingleton.sharedInstance().bitCarrierNode.populateTSV(self.prepareStringData("bit_carrier_silverstone_node.tsv")) { success in
                let arrayCommon = OTSingleton.sharedInstance().bitCarrierNode.returnNodesForCommon()
                OTSingleton.sharedInstance().common.populateTable(with: arrayCommon, type: OTSingleton.sharedInstance().bitCarrierNode.dataType)
                self.showCompleted(success)
            }
        }
    }

    @IBAction func pressedClearAndLoadSketches() {
        
        self.activityIndicator.start()
        DispatchQueue.global(qos: DispatchQoS.QoSClass.userInitiated).async {
            OTSingleton.sharedInstance().bitCarrierSketch.populateTSV(self.prepareStringData("bit_carrier_silverstone_sketch.tsv")) { success in
                self.showCompleted(success)
            }
        }
    }
    
    @IBAction func pressedClearAndLoadTravel() {
        
        self.activityIndicator.start()
        DispatchQueue.global(qos: DispatchQoS.QoSClass.userInitiated).async {
            OTSingleton.sharedInstance().bitCarrierTravel.populateTSV(self.prepareStringData("bit_carrier_silverstone_travel_summary.tsv")) { success in
                self.showCompleted(success)
            }
        }
    }
    
    @IBAction func pressedClearAndLoadVectors() {
        
        self.activityIndicator.start()
        DispatchQueue.global(qos: DispatchQoS.QoSClass.userInitiated).async {
            OTSingleton.sharedInstance().bitCarrierVector.populateTSV(self.prepareStringData("bit_carrier_silverstone_data_vector.tsv")) { success in
                self.showCompleted(success)
            }
        }
    }
    
    @IBAction func pressedClearAndLoadConfigVectors() {
        
        self.activityIndicator.start()
        DispatchQueue.global(qos: DispatchQoS.QoSClass.userInitiated).async {
            OTSingleton.sharedInstance().bitCarrierConfigVector.populateTSV(self.prepareStringData("bit_carrier_silverstone_config_vector.tsv")) { success in
                self.showCompleted(success)
            }
        }
    }
    
    @IBAction func pressedClearAndLoadCv_Devices() {
        
        self.activityIndicator.start()
        DispatchQueue.global(qos: DispatchQoS.QoSClass.userInitiated).async {
            OTSingleton.sharedInstance().clearViewDevice.populateTSV(self.prepareStringData("clearview_silverstone_device.tsv")) { success in
                self.showCompleted(success)
            }
        }
    }
    
    @IBAction func pressedClearAndLoadCv_Traffic() {
        
        self.activityIndicator.start()
        DispatchQueue.global(qos: DispatchQoS.QoSClass.userInitiated).async {
            OTSingleton.sharedInstance().clearViewTraffic.populateTSV(self.prepareStringData("clearview_silverstone_traffic.tsv")) { success in
                self.showCompleted(success)
            }
        }
    }
    
    func prepareStringData(_ filename : String) ->String {
        
        do {
            let path = Bundle.main.path(forResource: filename, ofType: nil)
            let stringData = try String.init(contentsOfFile: path!, encoding: String.Encoding.utf8)
            return stringData
        } catch {
            return ""
        }
    }
}

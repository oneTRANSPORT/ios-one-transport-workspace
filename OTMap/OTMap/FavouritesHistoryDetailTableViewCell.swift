//
//  FavouritesHistoryDetailTableViewCell.swift
//  OTMap
//
//  Created by Dominic Frazer Imregh on 12/09/2016.
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
import MapKit

class FavouritesHistoryDetailTableViewCell: UITableViewCell {

    @IBOutlet weak var labelHeading : UILabel!
    @IBOutlet weak var viewVectorHistory: BitCarrierVectorHistoryView!
    @IBOutlet weak var imageViewMap1: MapImageView!
    @IBOutlet weak var imageViewMap2: MapImageView!
    var reference : String = ""

    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.backgroundColor = UIColor.clear
        self.selectionStyle = .none
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }

    func configure(_ reference: String!) {
        self.reference = reference
        let singleton = OTSingleton.sharedInstance()
        
        let objectArray = singleton.bitCarrierConfigVector.retrieveAll(NSPredicate.init(format: "reference == %@", reference))
        if !objectArray.isEmpty {
            if let object = objectArray[0] as? BC_ConfigVector {
                self.labelHeading.text = object.customer_name
                
                self.viewVectorHistory.configureIndividual(object.from_location!, to: object.to_location!)
                
                self.setMapImage(object.from_location!, image: self.imageViewMap1)
                self.setMapImage(object.to_location!, image: self.imageViewMap2)
            }
        } else {
            self.labelHeading.text = "Not found \(reference)"
        }
        
        self.selectionStyle = .gray
        self.accessoryType = .none
    }

    func setMapImage(_ location : String, image : MapImageView) {
        
        let nodeArray = OTSingleton.sharedInstance().bitCarrierNode.retrieveAll(NSPredicate.init(format: "reference == %@", location))
        if !nodeArray.isEmpty {
            if let node = nodeArray[0] as? BC_Node {
                let coord = CLLocationCoordinate2DMake(node.latitude!.doubleValue, node.longitude!.doubleValue)
                image.generateImage(coord, to: coord)
            }
        }
    }
}

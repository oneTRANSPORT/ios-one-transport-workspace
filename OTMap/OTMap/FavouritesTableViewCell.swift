//
//  FavouritesTableViewCell.swift
//  OTMap
//
//  Created by Dominic Frazer Imregh on 31/08/2016.
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

class FavouritesTableViewCell: UITableViewCell {

    @IBOutlet weak var labelHeading : UILabel!
    @IBOutlet weak var labelBody : UILabel!
    @IBOutlet weak var imageViewFace: UIImageView!
    @IBOutlet weak var imageViewMap: MapImageView!

    var reference : String = ""
    var type : ObjectType = .variableMessageSigns

    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.backgroundColor = UIColor.clear
        self.selectionStyle = .none
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }

    func configure(_ reference: String!, type: ObjectType!) {
        self.reference = reference
        self.type = type
        
        self.imageViewFace.clipsToBounds = true
        self.labelBody.text = ""

        if let object = OTSingleton.sharedInstance().common.retrieve(self.reference, type: self.type) {
            if object.title != "" {
                self.labelHeading.text = object.title
            } else if object.titleTo != "" {
                self.labelHeading.text = object.titleTo
            } else {
                self.labelHeading.text = object.reference
            }
            self.setupImages()

            let coord = CLLocationCoordinate2DMake(object.latitude!.doubleValue, object.longitude!.doubleValue)
            self.imageViewMap.generateImage(coord, to: coord)

            self.retrieveLatest()
        } else {
            self.type = .variableMessageSigns
            self.labelHeading.text = ""
        }
        
        self.selectionStyle = .gray
    }
    
    func setupImages() {
        
        let tempView = AnnotationView()
        tempView.annotationType = self.type
        let key = tempView.getImagePath()
        self.imageViewFace.image = UIImage.init(named: key)
        self.imageViewFace.alpha = 1.0
    }
    
    
    func retrieveLatest() {

        let objectClass = OTSingleton.sharedInstance().getObjectClass(self.type)
        let array = objectClass.retrieveHistory(self.reference)
        if !array.isEmpty {
            self.labelBody.text = (array[0] as AnyObject).localizedMessage()
        }
    }
}

//
//  FilterTableViewCell.swift
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

class FilterTableViewCell: UITableViewCell {
    
    @IBOutlet weak var labelHeading : UILabel!
    @IBOutlet weak var switchYesNo : UISwitch!

    var item: CellRequest?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.backgroundColor = UIColor.clear
        self.selectionStyle = .none
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    func configure(_ item: CellRequest!) {
       
        self.item = item
    
        self.selectionStyle = .none
        self.backgroundColor = item.getBackgroundColor()
        self.labelHeading.text = item.getHeading()
        self.switchYesNo.setOn(self.item!.getUserDefaultsValue(), animated: false)
    }
    
    @IBAction func didChangeSwitch(_ sender: AnyObject!) {
        
        self.item!.setUserDefaultsValue(self.switchYesNo.isOn);
    }
}

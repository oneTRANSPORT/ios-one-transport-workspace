//
//  FilterViewController.swift
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

class FilterViewController: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    var arrayRows:[CellRequest] = []

    override func viewDidLoad() {
        super.viewDidLoad()
                
        self.tableView.register(UINib.init(nibName: "FilterTableViewCell", bundle: nil), forCellReuseIdentifier: "CellSwitch")
        self.tableView.estimatedRowHeight = 80
        self.tableView.backgroundColor = UIColor.clear
        
        self.arrayRows = [.la_Bucks, .la_Northants, .la_Oxon, .la_Herts, .la_Birmingham,
                          .variableMessageSigns,
                          .trafficFlow, .trafficQueue, .trafficSpeed, .trafficScoot, .trafficTime,
                          .carParks, .roadworks, .events,
                          .bitCarrier, .clearView, .favourites]
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

}

extension FilterViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
        return self.arrayRows.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellId = self.arrayRows[(indexPath as NSIndexPath).row].getCellId()
        let cell : FilterTableViewCell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! FilterTableViewCell
        cell.configure(self.arrayRows[(indexPath as NSIndexPath).row])
        return cell
    }
}

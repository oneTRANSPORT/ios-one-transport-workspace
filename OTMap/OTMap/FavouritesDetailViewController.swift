//
//  FavouritesDetailViewController.swift
//  OTMap
//
//  Created by Dominic Frazer Imregh on 09/09/2016.
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

class FavouritesDetailViewController: BaseViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: ActivityView!
    @IBOutlet weak var barButtonRefresh: UIBarButtonItem!

    var common : Common?
    var arrayRows:[String] = []
    let cellIdHistoryDetail = "CellHistoryDetail"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.activityIndicator.start()

        self.tableView.register(UINib.init(nibName: "FavouritesHistoryDetailTableViewCell", bundle: nil), forCellReuseIdentifier: cellIdHistoryDetail)
        self.tableView.estimatedRowHeight = 80
        self.tableView.backgroundColor = UIColor.clear
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.dataRefreshed()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func dataRefreshed() {
        
        self.arrayRows.removeAll()
        
        let singleton = OTSingleton.sharedInstance()
        
        let arrayNode = singleton.bitCarrierNode.retrieveAll(NSPredicate.init(format: "reference == %@", common!.reference))
        if !arrayNode.isEmpty {
            let objectNode = arrayNode[0] as! BC_Node
            if let arrayCF = singleton.bitCarrierConfigVector.retrieveAll(NSPredicate.init(format: "from_location == %@ || to_location == %@", objectNode.reference, objectNode.reference)) as? [BC_ConfigVector] {
                for vconfig in arrayCF {
                    self.arrayRows.append(vconfig.reference)
                }
            }
        }

        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
        
        self.activityIndicator.stop()
    }
}

extension FavouritesDetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrayRows.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let reference = self.arrayRows[indexPath.row]
        
        let cell : FavouritesHistoryDetailTableViewCell = tableView.dequeueReusableCell(withIdentifier: cellIdHistoryDetail, for: indexPath) as! FavouritesHistoryDetailTableViewCell
        cell.configure(reference)
        return cell
    }
}

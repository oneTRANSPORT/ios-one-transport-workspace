//
//  FavouritesViewController.swift
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

class FavouritesViewController: BaseViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: ActivityView!
    @IBOutlet weak var barButtonRefresh: UIBarButtonItem!

    var arrayRows:[String] = []
    var arrayTypes:[ObjectType] = []
    let cellId = "Cell"
    let cellIdHistory = "CellHistory"
    var timer = Timer()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.activityIndicator.start()

        self.tableView.register(UINib.init(nibName: "FavouritesTableViewCell", bundle: nil), forCellReuseIdentifier: cellId)
        self.tableView.register(UINib.init(nibName: "FavouritesHistoryTableViewCell", bundle: nil), forCellReuseIdentifier: cellIdHistory)
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
        self.arrayTypes.removeAll()
        
        let array = OTSingleton.sharedInstance().common.retrieveAll("favourite == true")
        for object : Common in array {
            self.arrayRows.append("\(object.reference)")
            
            let type : ObjectType = OTSingleton.sharedInstance().common.objectType(from: object.type!)
            self.arrayTypes.append(type)
        }
        
        DispatchQueue.main.async { 
            self.tableView.reloadData()
        }
        
        self.activityIndicator.stop()
    }
    
    @IBAction func pressedRefresh() {
        
        OTSingleton.sharedInstance().requestData() {response, error in
                        
            self.dataRefreshed()
        }
        
        self.barButtonRefresh.isEnabled = false
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(30 * Int64(NSEC_PER_SEC)) / Double(NSEC_PER_SEC)) {
            self.barButtonRefresh.isEnabled = true
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "History" {
            
            if let vc = segue.destination as? FavouritesDetailViewController {
                vc.common = sender as? Common
            }
        }
    }
}

extension FavouritesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrayRows.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let reference = self.arrayRows[(indexPath as NSIndexPath).row]
        let type = self.arrayTypes[(indexPath as NSIndexPath).row]
        
        if type == .bitCarrier {
            let cell : FavouritesHistoryTableViewCell = tableView.dequeueReusableCell(withIdentifier: cellIdHistory, for: indexPath) as! FavouritesHistoryTableViewCell
            cell.configure(reference, type: type)
            return cell
        } else {
            let cell : FavouritesTableViewCell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! FavouritesTableViewCell
            cell.configure(reference, type: type)
            return cell
        }
    }
}

extension FavouritesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView .deselectRow(at: indexPath, animated: false)
        
        let type = self.arrayTypes[(indexPath as NSIndexPath).row]
        if type == .bitCarrier {
            let reference = self.arrayRows[(indexPath as NSIndexPath).row]
            
            let common = OTSingleton.sharedInstance().common.retrieve(reference, type: type)
            self.performSegue(withIdentifier: "History", sender: common)
        } else {
            
        }
    }
    
}

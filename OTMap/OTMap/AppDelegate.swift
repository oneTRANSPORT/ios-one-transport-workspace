//
//  AppDelegate.swift
//  OTMap
//
//  Created by Dominic Frazer Imregh on 12/08/2016.
//
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

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        let APP_ID       = "C-Y249V2hpdGVMYWJlbENsaWVudCxvdT1yb290"
        let ACCCESS_KEY  = "01rccVdqtnS1Ayss"
        let ORIGIN       = "C-Y249V2hpdGVMYWJlbENsaWVudCxvdT1yb290"
        OTSingleton.sharedInstance().configureOneTransport(APP_ID, auth: ACCCESS_KEY, origin: ORIGIN)
        UserDefaults.standard.set(CommsTest.live.rawValue, forKey: kUserDefaultsCommsMode)
        
        self.checkFirstTimeFilter()
        if UserDefaults.standard.bool(forKey: kUserDefaultsActiveLocation) { //App has restarted while location active
            let _ = LocationManager.sharedInstance.start()
        }

        return true
    }

    func checkFirstTimeFilter() {
        if (UserDefaults.standard.string(forKey: kUserDefaultsRefreshInterval) == nil) {
            UserDefaults.standard.set(10.0, forKey: kUserDefaultsRefreshInterval)
            
            //For central Birmingham
//            UserDefaults.standard.set(52.5021, forKey: kUserDefaultsMinLat)
//            UserDefaults.standard.set(-1.9197, forKey: kUserDefaultsMinLon)
//            UserDefaults.standard.set(52.4625, forKey: kUserDefaultsMaxLat)
//            UserDefaults.standard.set(-1.8793, forKey: kUserDefaultsMaxLon)
//            UserDefaults.standard.set(false, forKey: kUserDefaultsLA_Bucks)
//            UserDefaults.standard.set(true, forKey: kUserDefaultsLA_Birmingham)
        }
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}


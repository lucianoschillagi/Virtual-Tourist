//
//  AppDelegate.swift
//  Virtual Tourist
//
//  Created by Luciano Schillagi on 12/5/17.
//  Copyright © 2017 luko. All rights reserved.
//

/* App */

import UIKit

/* Abstract:
---
*/

//*****************************************************************
// MARK: - AppDelegate: UIResponder, UIApplicationDelegate
//*****************************************************************

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
	
	//*****************************************************************
	// MARK: - Properties
	//*****************************************************************
	
	var window: UIWindow?

	//*****************************************************************
	// MARK: - Preload Data
	//*****************************************************************
	
	func preloadData() {
		
	}
	
	//*****************************************************************
	// MARK: - UIApplication Delegate
	//*****************************************************************
	
	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

		return true
	}
	
	func applicationWillResignActive(_ application: UIApplication) {

	}
	
	func applicationDidEnterBackground(_ application: UIApplication) {

	}
}


//
//  AppDelegate.swift
//  Virtual Tourist
//
//  Created by Luciano Schillagi on 12/5/17.
//  Copyright © 2017 luko. All rights reserved.
//

/* App */

import UIKit

//*****************************************************************
// MARK: - AppDelegate: UIResponder, UIApplicationDelegate
//*****************************************************************

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
	
	//*****************************************************************
	// MARK: - Properties
	//*****************************************************************
	
	var window: UIWindow?
	
	// core data
	let dataController = DataController(modelName: "VirtualTourist")
	
	//*****************************************************************
	// MARK: - UIApplication Delegate
	//*****************************************************************
	
	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
		
		// Override point for customization after application launch.
		
		// carga el almacen persistente
		dataController.load()
		
		// apenas arranca la aplicación...
		/// inyecta el 'dataController' en el 'TravelLocationsMapViewController'
		let navigationController = window?.rootViewController as! UINavigationController
		let travelLocationsViewController = navigationController.topViewController as! TravelLocationsMapViewController
		travelLocationsViewController.dataController = dataController
		
		return true
	}
	
	func applicationDidEnterBackground(_ application: UIApplication) {
		saveViewContext()
	}
	
	func applicationWillTerminate(_ application: UIApplication) {
		saveViewContext()
	}
	
	// save view context
	func saveViewContext() {
		// intenta guardar el contexto
		try? dataController.viewContext.save()
	}
	
} // end class


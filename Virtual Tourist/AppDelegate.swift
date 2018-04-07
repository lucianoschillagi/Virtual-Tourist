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
	
	// configura cual es el Modelo de esta aplicación
	let dataController = DataController(modelName: "VirtualTourist")
	
	//*****************************************************************
	// MARK: - UIApplication Delegate
	//*****************************************************************
	
	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
		
		// Override point for customization after application launch.
		
		// carga el almacen persistente
		dataController.load()
		
		// apenas arranca la aplicación...
		// inyecta el 'dataController' en el 'TravelLocationsMapViewController'
		let navigationController = window?.rootViewController as! UINavigationController
		let travelLocationsViewController = navigationController.topViewController as! TravelLocationsMapViewController
		travelLocationsViewController.dataController = dataController
		
		return true
	}
	
	func applicationDidEnterBackground(_ application: UIApplication) {
		// cuando la aplicación entró en segundo plano se guarda el estado del contexto 💿
		saveViewContext()
	}
	
	func applicationWillTerminate(_ application: UIApplication) {
		// cuando la aplicación está por morir guarda el estado del contexto 💿
		saveViewContext()
	}
	
	//*****************************************************************
	// MARK: - Core Data - Save View Context
	//*****************************************************************
	
	// en este punto, si hay cambios en el modelo no guardados, los guarda
	func saveViewContext() {
		try? dataController.viewContext.save() // 💿
	}
	
} // end class


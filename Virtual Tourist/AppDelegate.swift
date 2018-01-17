//
//  AppDelegate.swift
//  Virtual Tourist
//
//  Created by Luciano Schillagi on 12/5/17.
//  Copyright © 2017 luko. All rights reserved.
//

import UIKit

// MARK: - AppDelegate: UIResponder, UIApplicationDelegate

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
	
	// MARK: Properties
	
	var window: UIWindow?
	
	// Core Data
	
	let stack = CoreDataStack(modelName: "Model")!
	
	// MARK: UIApplicationDelegate
	
	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]? = nil) -> Bool {
		return true
	}
}


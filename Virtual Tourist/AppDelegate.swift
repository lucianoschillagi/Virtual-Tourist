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
	let stack = CoreDataStack(modelName: "Model")!
	
	//*****************************************************************
	// MARK: - Preload Data
	//*****************************************************************
	
	func preloadData() {
		
		// Remove previous stuff (if any)
		
		do {
			try stack.dropAllData()
		} catch {
			print("Error droping all objects in DB")
		}
		
		
		// TODO: cómo precargar los pins persistidos? (preguntar Udacity)
		
//		let codeNotes = Notebook(name: "Coding Notes", context: stack.context)
		
		
		
		
	}
	
	//*****************************************************************
	// MARK: - UIApplication Delegate
	//*****************************************************************
	
	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
		// Load some notebooks and notes.
		preloadData()
		// Start Autosaving
		stack.autoSave(60)
		return true
	}
	
	func applicationWillResignActive(_ application: UIApplication) {
		// Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
		// Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
		do {
			try stack.saveContext()
			print("🐽 guarda el contexto porque la aplicación deja de estar activa")
		} catch {
			print("Error while saving.")
		}
	}
	
	func applicationDidEnterBackground(_ application: UIApplication) {
		// Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
		// If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
		do {
			try stack.saveContext()
			print("🐽 guarda el contexto porque la aplicación está en segundo plano")

		} catch {
			print("Error while saving.")
		}
	}
}


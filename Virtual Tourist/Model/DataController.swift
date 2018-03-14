//
//  DataController.swift
//  Virtual Tourist
//
//  Created by Luciano Schillagi on 3/14/18.
//  Copyright © 2018 luko. All rights reserved.
//

import Foundation
import CoreData

// TODO: estudiar bien esta clase!

// Core Data Stack

// crea una clase para encapsular las configuraciones de la pila
// y su funcionalidad

class DataController {
	
	let persistentContainer: NSPersistentContainer
	
	// computed property
	var viewContext: NSManagedObjectContext {
		return persistentContainer.viewContext
	}
	
	init(modelName: String) {
		persistentContainer = NSPersistentContainer(name: modelName)
	}
	
	/// carga los almacenes persistentes
	func load(completion: (() -> Void)? = nil) {
		persistentContainer.loadPersistentStores { storeDescription, error in
			
			guard error == nil else {
				fatalError(error!.localizedDescription)
			}
			completion?()
		}
	}
	
}

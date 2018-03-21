//
//  DataController.swift
//  Virtual Tourist
//
//  Created by Luciano Schillagi on 3/14/18.
//  Copyright © 2018 luko. All rights reserved.
//

import Foundation
import CoreData

// Core Data Stack

// crea una clase para encapsular las configuraciones de la pila y su funcionalidad
class DataController {
	
	let persistentContainer: NSPersistentContainer
	
	var viewContext: NSManagedObjectContext {
		return persistentContainer.viewContext
	}
	
	/// inicializa el contenedor persistente de un modelo dado
	init(modelName: String) {
		persistentContainer = NSPersistentContainer(name: modelName)
	}
	
	/// carga los almacenes persistentes
	func load(completion: (() -> Void)? = nil) {
		persistentContainer.loadPersistentStores { storeDescription, error in
			
			guard error == nil else {
				fatalError(error!.localizedDescription)
			}
			self.autoSaveViewContext()
			completion?()
		}
	}
}

extension DataController {
	
	func autoSaveViewContext(interval: TimeInterval = 30) {
		
		// test
		print("autosaving")
		
		// guard
		guard interval > 0 else {
			print("cannot set negative autosave interval")
			return
		}
		
		// si es que hay cambios en el contexto, guardar
		if viewContext.hasChanges {
			try? viewContext.save()
		}
		
		// dispatch
		DispatchQueue.main.asyncAfter(deadline: .now() + interval) {
			
			self.autoSaveViewContext(interval: interval)
		}
	}
}

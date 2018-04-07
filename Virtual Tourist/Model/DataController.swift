//
//  DataController.swift
//  Virtual Tourist
//
//  Created by Luciano Schillagi on 3/14/18.
//  Copyright © 2018 luko. All rights reserved.
//

/* Controller */

import Foundation
import CoreData

/* Abstract:
Una clase para encapsular las configuraciones de la pila y su funcionalidad.
*/

//*****************************************************************
// MARK: - Core Data Stack
//*****************************************************************

// crea una clase para encapsular las configuraciones de la pila y su funcionalidad
class DataController {
	
		/// el contenedor persistente
    let persistentContainer: NSPersistentContainer
	
		/// el contexto revisa si hay datos persistidos (en el contenedor persistente)
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

//*****************************************************************
// MARK: - Autosave
//*****************************************************************

extension DataController {
	
		/// cada 30 segundos se fija si hay cambios en el contexto, y de ser así, los guarda
    func autoSaveViewContext(interval: TimeInterval = 30) {
        
        // guard
        guard interval > 0 else {
            print("cannot set negative autosave interval")
            return
        }
        
        // si es que hay cambios en el contexto, guardar..
        if viewContext.hasChanges {
            try? viewContext.save()
        }
        
        // dispatch
        DispatchQueue.main.asyncAfter(deadline: .now() + interval) {
            
            self.autoSaveViewContext(interval: interval)
        }
			
			// test
			print("autosaving")
    }
}

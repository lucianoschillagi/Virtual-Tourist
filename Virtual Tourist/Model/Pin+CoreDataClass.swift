//
//  Pin+CoreDataClass.swift
//  Virtual Tourist
//
//  Created by Luciano Schillagi on 1/21/18.
//  Copyright © 2018 luko. All rights reserved.
//
//

/* Model */

import Foundation
import CoreData

//*****************************************************************
// MARK: - Pin (Managed Object)
//*****************************************************************
public class Pin: NSManagedObject {
	
// lo que tenemos que hacer es añadir un método ´init´ para que esta clase puede crear INSTANCIAS usables de sí misma
	
	// inicializador de conveniencia para crear las instancias usables
	convenience init(latitude: Double, longitude: Double, context: NSManagedObjectContext ) {
		
		if let ent = NSEntityDescription.entity(forEntityName: "Pin", in: context) {
			// inicializador designado de Pin (NSManagedObject)
			self.init(entity: ent, insertInto: context)
			self.latitude = latitude
			self.longitude = longitude
		
		} else {
			fatalError("Unable To Find Entity Name!")
		}
	}
}


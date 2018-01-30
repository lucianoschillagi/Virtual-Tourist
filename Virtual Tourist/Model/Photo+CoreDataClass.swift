//
//  Photo+CoreDataClass.swift
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
// MARK: - Photo - Properties and Methods
//*****************************************************************

public class Photo: NSManagedObject {
// lo que tenemos que hacer es añadir un método ´init´ para que esta clase puede crear INSTANCIAS usables de sí misma
	// inicializador de conveniencia para crear las instancias usables
	convenience init(index:Int, imageURL: String, imageData: NSData?, context: NSManagedObjectContext) {
		
		if let ent = NSEntityDescription.entity(forEntityName: "Photo", in: context) {
			// inicializador designado de Photo (NSManagedObject)
			self.init(entity: ent, insertInto: context)
			self.index = Int16(index)
			self.imageURL = imageURL
			self.imageData = imageData
		
		} else {
			fatalError("Unable To Find Entity Name!")
		}
	}
	
} // end class



//
//  Pin+CoreDataClass.swift
//  Virtual Tourist
//
//  Created by Luciano Schillagi on 3/14/18.
//  Copyright © 2018 luko. All rights reserved.
//
//

/* Model */

import Foundation
import CoreData

/* Abstract:
Una clase que representa el objeto ´Pin´, con un inicializador de conveniencia.
*/

public class Pin: NSManagedObject {
	
	// task: crear un inicializador para generar las instancias de 'Pin'
	// este inicializador tomará los datos de las coordenadas del pin puesto
	convenience init(latitude: Double, longitude: Double, context: NSManagedObjectContext) {
		
		if let ent = NSEntityDescription.entity(forEntityName: "Pin", in: context) {
			
			self.init(entity: ent, insertInto: context)
			self.latitude = latitude
			self.longitude = longitude 
			
		} else {
			
			fatalError("Unable To Find Entity Name!")
		}
	}
	
}

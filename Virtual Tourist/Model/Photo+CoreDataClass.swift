//
//  Photo+CoreDataClass.swift
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
Una clase que representa el objeto ´Photo´, con un inicializador de conveniencia.
*/

public class Photo: NSManagedObject {
	
	// task: crear un inicializador para generar las instancias de 'Photo'
	// este inicializador tomará como dato la url de la imagen
	convenience init(imageURL: String?, context: NSManagedObjectContext) {
		
		if let ent = NSEntityDescription.entity(forEntityName: "Photo", in: context) {
			
			self.init(entity: ent, insertInto: context)
			self.imageURL = imageURL
			
		} else {
			
			fatalError("Unable To Find Entity Name!")
		}
	}
	

}





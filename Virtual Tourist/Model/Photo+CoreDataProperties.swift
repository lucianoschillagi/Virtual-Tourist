//
//  Photo+CoreDataProperties.swift
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
Extensión de la clase ´Photo´. Contiene sus propiedades, un método para buscar las instancias de este objeto.
*/

extension Photo {
	
		// busca si hay instancias persistidas del objeto 'Photo'
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Photo> {
        return NSFetchRequest<Photo>(entityName: "Photo")
    }

    @NSManaged public var imageData: NSData? // attribute
    @NSManaged public var imageURL: String? // attribute
    @NSManaged public var pin: Pin? // relationship

}

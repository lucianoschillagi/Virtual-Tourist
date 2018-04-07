//
//  Pin+CoreDataProperties.swift
//  Virtual Tourist
//
//  Created by Luciano Schillagi on 3/19/18.
//  Copyright © 2018 luko. All rights reserved.
//
//

/* Model */

import Foundation
import CoreData

/* Abstract:
Extensión de la clase ´Pin´. Contiene sus propiedades, un método para buscar las instancias de este objeto y métodos accesorios.
*/

//*****************************************************************
// MARK: - Pin extension
//*****************************************************************

extension Pin {
	
		// busca si hay instancias persistidas del objeto 'Pin'
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Pin> {
        return NSFetchRequest<Pin>(entityName: "Pin")
    }

    @NSManaged public var latitude: Double // attribute
    @NSManaged public var longitude: Double // attribute
    @NSManaged public var photos: NSSet? // relationship

}

//*****************************************************************
// MARK: - Pin accesors
//*****************************************************************

extension Pin {

    @objc(addPhotosObject:)
    @NSManaged public func addToPhotos(_ value: Photo)

    @objc(removePhotosObject:)
    @NSManaged public func removeFromPhotos(_ value: Photo)

    @objc(addPhotos:)
    @NSManaged public func addToPhotos(_ values: NSSet)

    @objc(removePhotos:)
    @NSManaged public func removeFromPhotos(_ values: NSSet)

}

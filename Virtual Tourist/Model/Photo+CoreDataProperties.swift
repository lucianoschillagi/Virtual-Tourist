//
//  Photo+CoreDataProperties.swift
//  Virtual Tourist
//
//  Created by Luciano Schillagi on 1/21/18.
//  Copyright © 2018 luko. All rights reserved.
//
//

import Foundation
import CoreData

// Managed Object: Photo
// NO ESCRIBIR ESTE ARCHIVO!
extension Photo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Photo> {
        return NSFetchRequest<Photo>(entityName: "Photo")
    }

    @NSManaged public var index: Int16
    @NSManaged public var imageURL: String?
    @NSManaged public var imageData: NSData?
    @NSManaged public var photoToPin: Pin?

}

//
//  Photo+CoreDataProperties.swift
//  Virtual Tourist
//
//  Created by Luciano Schillagi on 1/22/18.
//  Copyright © 2018 luko. All rights reserved.
//
//

/* Model */

import Foundation
import CoreData

//*****************************************************************
// MARK: - Photo - Properties and Methods
//*****************************************************************

extension Photo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Photo> {
        return NSFetchRequest<Photo>(entityName: "Photo")
    }

    @NSManaged public var imageData: NSData? // attribute
    @NSManaged public var imageURL: String? // attribute
    @NSManaged public var index: Int16 // attribute
    @NSManaged public var photoToPin: Pin? // relationship

}

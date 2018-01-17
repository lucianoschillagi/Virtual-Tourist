//
//  Photo+CoreDataProperties.swift
//  Virtual Tourist
//
//  Created by Luciano Schillagi on 1/17/18.
//  Copyright © 2018 luko. All rights reserved.
//
//

import Foundation
import CoreData


extension Photo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Photo> {
        return NSFetchRequest<Photo>(entityName: "Photo")
    }

    @NSManaged public var imageData: NSObject?
    @NSManaged public var imageURL: String?
    @NSManaged public var index: Int16
    @NSManaged public var pin: Pin?

}

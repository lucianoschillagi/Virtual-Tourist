//
//  Pin+CoreDataProperties.swift
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
// MARK: - Pin - Properties and Methods
//*****************************************************************

extension Pin {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Pin> {
        return NSFetchRequest<Pin>(entityName: "Pin")
    }

    @NSManaged public var latitude: Double // attribute
    @NSManaged public var longitude: Double // attribute
    @NSManaged public var pinToPhoto: NSSet? // relationship

}

// MARK: Generated accessors for pinToPhoto
extension Pin {

    @objc(addPinToPhotoObject:)
    @NSManaged public func addToPinToPhoto(_ value: Photo)

    @objc(removePinToPhotoObject:)
    @NSManaged public func removeFromPinToPhoto(_ value: Photo)

    @objc(addPinToPhoto:)
    @NSManaged public func addToPinToPhoto(_ values: NSSet)

    @objc(removePinToPhoto:)
    @NSManaged public func removeFromPinToPhoto(_ values: NSSet)

}

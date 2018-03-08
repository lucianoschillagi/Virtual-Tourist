//
//  Photo+CoreDataProperties.swift
//  Virtual Tourist
//
//  Created by Luciano Schillagi on 3/2/18.
//  Copyright © 2018 luko. All rights reserved.
//
//

import CoreData


extension Photo {

    @NSManaged public var imageURL: String?
    @NSManaged public var imageData: NSData?
    @NSManaged public var photoToPin: Pin?

}

//
//  Pin+CoreDataProperties.swift
//  Virtual Tourist
//
//  Created by Luciano Schillagi on 3/2/18.
//  Copyright © 2018 luko. All rights reserved.
//
//

import Foundation
import CoreData


extension Pin {

    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double
    @NSManaged public var pinToPhoto: NSSet?

}


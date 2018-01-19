//
//  Pin+CoreDataClass.swift
//  Virtual Tourist
//
//  Created by Luciano Schillagi on 1/17/18.
//  Copyright © 2018 luko. All rights reserved.
//
//

import Foundation
import CoreData

@objc(Pin)
public class Pin: NSManagedObject {
	
	convenience init(latitude: Double, longitude: Double, context: NSManagedObjectContext) {
		
		if let entity = NSEntityDescription.entity(forEntityName: "Pin", in: context) {
			
			self.init(entity: entity, insertInto: context)
			self.latitude = latitude
			self.longitude = longitude
		} else {
			
			fatalError("Unable to find entity name")
		} // end optional binding
	} // end init
} // end class

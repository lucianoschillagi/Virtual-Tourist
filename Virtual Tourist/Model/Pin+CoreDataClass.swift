//
//  Pin+CoreDataClass.swift
//  Virtual Tourist
//
//  Created by Luciano Schillagi on 3/14/18.
//  Copyright © 2018 luko. All rights reserved.
//
//

import Foundation
import CoreData

//Pin Class
public class Pin: NSManagedObject {
	
	convenience init(latitude: Double, longitude: Double, context: NSManagedObjectContext) {
		
		if let ent = NSEntityDescription.entity(forEntityName: "Pin", in: context) {
			
			self.init(entity: ent, insertInto: context)
			self.latitude = latitude as NSNumber
			self.longitude = longitude as NSNumber
			
		} else {
			
			fatalError("Unable To Find Entity Name!")
		}
	}
}

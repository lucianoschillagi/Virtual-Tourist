//
//  Pin.swift
//  Virtual Tourist
//
//  Created by Luciano Schillagi on 3/2/18.
//  Copyright © 2018 luko. All rights reserved.
//
//

import CoreData

//Pin Class
public class Pin: NSManagedObject {

	convenience init(latitude: Double, longitude: Double, context: NSManagedObjectContext) {

		if let ent = NSEntityDescription.entity(forEntityName: "Pin", in: context) {

			self.init(entity: ent, insertInto: context)
			self.latitude = latitude
			self.longitude = longitude

		} else {

			fatalError("Unable To Find Entity Name!")
		}
	}
}
	



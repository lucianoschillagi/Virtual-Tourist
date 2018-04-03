//
//  Photo+CoreDataClass.swift
//  Virtual Tourist
//
//  Created by Luciano Schillagi on 3/14/18.
//  Copyright © 2018 luko. All rights reserved.
//
//

import Foundation
import CoreData


public class Photo: NSManagedObject {
	
	convenience init(imageURL: String?, context: NSManagedObjectContext) {
		
		if let ent = NSEntityDescription.entity(forEntityName: "Photo", in: context) {
			
			self.init(entity: ent, insertInto: context)
			self.imageURL = imageURL
			
		} else {
			
			fatalError("Unable To Find Entity Name!")
		}
	}
	

}





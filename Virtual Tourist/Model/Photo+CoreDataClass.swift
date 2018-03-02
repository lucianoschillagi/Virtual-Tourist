//
//  Photo+CoreDataClass.swift
//  Virtual Tourist
//
//  Created by Luciano Schillagi on 3/2/18.
//  Copyright © 2018 luko. All rights reserved.
//
//

import Foundation
import CoreData

//Photo Class
public class Photo: NSManagedObject {
	
	convenience init(imageURL: String?, imageData: NSData?, context: NSManagedObjectContext) {
		
		if let ent = NSEntityDescription.entity(forEntityName: "Photo", in: context) {
			
			self.init(entity: ent, insertInto: context)
//			self.index = Int16(index)
			self.imageURL = imageURL
			self.imageData = imageData
			
		} else {
			
			fatalError("Unable To Find Entity Name!")
		}
	}
	
}

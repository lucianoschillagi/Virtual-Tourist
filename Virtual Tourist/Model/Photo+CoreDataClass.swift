//
//  Photo+CoreDataClass.swift
//  Virtual Tourist
//
//  Created by Luciano Schillagi on 1/17/18.
//  Copyright © 2018 luko. All rights reserved.
//
//

import Foundation
import CoreData

@objc(Photo)
public class Photo: NSManagedObject {

	convenience init(index: Int, imageURL: String, imageData: NSData?, context: NSManagedObjectContext) {
		
		if let entity = NSEntityDescription.entity(forEntityName: "Photo", in: context) {
			
			self.init(entity: entity, insertInto: context)
			self.index = Int16(index)
			self.imageURL = imageURL
			self.imageData = imageData
		
		} else {
			fatalError("Unable to find entity name")
			
		} // end optional binding
	} // end init
} // end class

//
//  File.swift
//  Virtual Tourist
//
//  Created by Luciano Schillagi on 3/4/18.
//  Copyright © 2018 luko. All rights reserved.
//


import Foundation
import MapKit
import Contacts

/* Model */

class CoordenadasPrueba: NSObject, MKAnnotation {
	
	// MARK: - Stored Properties
	var coordinate: CLLocationCoordinate2D
	
	// MARK: - Initializers
	init(coordinate: CLLocationCoordinate2D) {

		self.coordinate = coordinate
		
		super.init()
	}
	
	
} // end class


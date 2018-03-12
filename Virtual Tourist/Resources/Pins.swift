//
//  Pins.swift
//  Virtual Tourist
//
//  Created by Luciano Schillagi on 3/8/18.
//  Copyright © 2018 luko. All rights reserved.
//

import Foundation
import MapKit

class Pins: NSObject, MKAnnotation {
	
	var coordinate: CLLocationCoordinate2D
	
	// MARK: - Initializers
	init(coordinate: CLLocationCoordinate2D) {

		self.coordinate = coordinate
		
		super.init()
	}
	
}



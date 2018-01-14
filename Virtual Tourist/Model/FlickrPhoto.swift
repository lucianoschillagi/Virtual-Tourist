//
//  FlickrPhoto.swift
//  Virtual Tourist
//
//  Created by Luciano Schillagi on 12/20/17.
//  Copyright © 2017 luko. All rights reserved.
//

/* Model */

// MARK: - Flickr Photo

import Foundation

class FlickrPhoto { // named type
	
	let mediumURL : String // la url para construir la foto!
	
	init(mediumURL:String) {
		self.mediumURL = mediumURL
	}
	
	func photoURLString() -> String {
		
		return mediumURL
	}
	
} // end struct



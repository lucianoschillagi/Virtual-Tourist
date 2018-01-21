//
//  FlickrImage.swift
//  Virtual Tourist
//
//  Created by Luciano Schillagi on 12/20/17.
//  Copyright © 2017 luko. All rights reserved.
//

/* Model */

/* Abstract:
Un objeto que representa una imagen obtenida desde Flickr.
*/

import Foundation

class FlickrImage {
	// stored property
	let mediumURL : String // la url para construir la foto!
	// init
	init(mediumURL:String) { // inicializa el objeto
		self.mediumURL = mediumURL
	}
	// method: devuelve el string de la url de la imagen
	func imageURLString() -> String {
		return mediumURL
	}
	
} // end class



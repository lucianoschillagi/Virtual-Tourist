//
//  FlickrImage.swift
//  Virtual Tourist
//
//  Created by Luciano Schillagi on 12/20/17.
//  Copyright © 2017 luko. All rights reserved.
//

/* Model */

import Foundation

/* Abstract:
Un objeto que representa una imagen obtenida desde Flickr.
*/

struct FlickrImage {
	
	//*****************************************************************
	// MARK: - Properties 
	//*****************************************************************
	
	let imageURL : String // la url para construir la foto!
	
	//*****************************************************************
	// MARK: - Initializers
	//*****************************************************************
	
	// prepara el objeto para recibir una secuencia de URLs (direcciones para obtener los datos de las imágenes)
	init(dictionary: [String:AnyObject]) {
		
		imageURL = dictionary[FlickrConstants.JSONResponseKeys.MediumURL]
			as! String
		
	}
	
	//*****************************************************************
	// MARK: - Results
	//*****************************************************************
	// method: devuelve el string de la url de la imagen
	func imageURLString() -> String {
		return imageURL
	}
	
} // end struct



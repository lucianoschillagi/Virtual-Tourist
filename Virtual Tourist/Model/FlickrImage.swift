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
Un objeto que contiene las URLs para obtener los datos para crear las fotos.
*/

struct FlickrImage {
	
	//*****************************************************************
	// MARK: - Properties 
	//*****************************************************************
	
	let photoPath: String? // la url para construir la foto!

	//*****************************************************************
	// MARK: - Initializers
	//*****************************************************************
	
	// construye un FlickrImage desde un diccionario
	init(dictionary: [String:AnyObject]) {
		photoPath = dictionary["url_m"] as? String // FlickrClient.JSONResponseKeys.MediumURL
	}
	
	//*****************************************************************
	// MARK: - Results
	//*****************************************************************
	
	// de los resultados de la solicitud devuelve un array que contiene las urls para construir las imagenes (las fotos)
	static func photosPathFromResults(_ results: [[String:AnyObject]]) -> [FlickrImage] {
		
		var photosPath = [FlickrImage]()
		
		// itera a través de un array de diccionarios, cada 'FlickrImage' es un diccionario
		for result in results {
			photosPath.append(FlickrImage(dictionary: result))
		}
		
		return photosPath
	}
	
} // end struct



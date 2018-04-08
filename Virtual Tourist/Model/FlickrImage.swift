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
	
	let photoPath: String? // la url para construir la foto 📷

	//*****************************************************************
	// MARK: - Initializers
	//*****************************************************************

	// task: crear un inicializador que tome un diccionario y de ese diccionario leer el valor de la clave 'url_m'
	init(dictionary: [String:AnyObject]) {
		photoPath = dictionary[FlickrClient.JSONResponseKeys.MediumURL] as? String
	}
	
	//*****************************************************************
	// MARK: - Results
	//*****************************************************************
	
	// task: de los resultados de la solicitud devolver un array que contenga las urls para construir las imagenes (las fotos)
	static func photosPathFromResults(_ results: [[String:AnyObject]]) -> [FlickrImage] {
		
		// guarda las fotos obtenidas en un array de 'FlickrImage'
		var photosPath = [FlickrImage]()
		
		// itera a través de un array de diccionarios, cada 'FlickrImage' es un diccionario 👈
		for result in results {
			photosPath.append(FlickrImage(dictionary: result))
		}
		
		return photosPath
		
		// [photoPath: https://farm5.staticflickr.com/4377/35538507233_1e1e1cfc06.jpg]
	}
	
	
} // end struct



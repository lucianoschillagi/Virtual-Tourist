//
//  FlickrImage.swift
//  Virtual Tourist
//
//  Created by Luciano Schillagi on 12/20/17.
//  Copyright © 2017 luko. All rights reserved.
//

/* Model */

import Foundation
//import CoreData

/* Abstract:
Un objeto que contiene las URLs para obtener los datos para crear las fotos.
*/

struct FlickrImage {
	
	//*****************************************************************
	// MARK: - Properties 
	//*****************************************************************
	
	let photoPath: String? // la url para construir la foto!
	
	// para persistir las fotos recibidas en un objeto gestionado (core data)
	var savePhotos: [Photo] = []
	
//	// core data
//	var dataController: DataController! // inyecta el data controller en esta clase

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
		
		// guarda las fotos obtenidas en un array de 'FlickrImage'
		var photosPath = [FlickrImage]()
		// guarda las fotos obtenidas en el objeto del modelo 'Photo'
		
		
		
		// itera a través de un array de diccionarios, cada 'FlickrImage' es un diccionario
		for result in results {
			photosPath.append(FlickrImage(dictionary: result))
			
			//Aquí, usted está haciendo todo lo correcto, excepto por una cosa, que le falta guardar las fotos en los datos centrales después de descargarlas.
			
			//Te recomendaría que lo hicieras aquí, pero también puedes hacerlo en tu controlador, una vez que hayas recibido las fotos.

			
			print("🎩 \(result)")
			
			
			
			
//			savePhotos.append(Photo(dictionary: result, context: dataController.viewContext))
			// le pide al contexto que guarde los cambios
			//try? dataController.viewContext.save()
			

		}
		
		return photosPath
	}
	
	
	
} // end struct



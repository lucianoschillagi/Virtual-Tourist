//
//  FlickrPhoto.swift
//  Virtual Tourist
//
//  Created by Luciano Schillagi on 12/20/17.
//  Copyright © 2017 luko. All rights reserved.
//

/* Model */

// MARK: - FlickrPhoto

import Foundation
/*
Creo un objeto que representa una foto de Flickr (obtenida a través del método 'flickr.photos.search'). Lo 'preparo' para recibir el array de fotos de la solicitud.
*/
struct FlickrPhoto { // named type
	
	// MARK: Properties
	// de los key-values obtenidos del objeto JSON extraigo los siguientes:
	let id: String
	let title: String
	let secret: String
	let server: String
	let farm: Int
	
	// MARK: Initializers
	
	// construyo un objeto 'FlickrImage' del resultado de la petición
	// en formato JSON (JSON Object) de tipo diccionario [String:AnyObject]
	init(dictionary: [String:AnyObject]) {
		id = dictionary[FlickrClient.ResponseKeys.Id] as! String // extraigo el valor del JSON y lo almaceno en esta propiedad de un objeto Foundation
		title = dictionary[FlickrClient.ResponseKeys.Title] as! String
		secret = dictionary[FlickrClient.ResponseKeys.Secret] as! String
		server = dictionary[FlickrClient.ResponseKeys.Server] as! String
		farm = dictionary[FlickrClient.ResponseKeys.Farm] as! Int
	}
	
	/**
	Convierte un array de diccionarios en un array de estructuras.
	
	- parameter results: obtenidos de la petición (un array de fotos) representadas en formato [[String:AnyObject]]
	
	- returns: el array de fotos convertidos en un array de estructuras.
	*/
	static func flickrPhotosFromResults(_ results: [[String:AnyObject]]) -> [FlickrPhoto] {
		// pone en la variable 'photos' un array de la estructura 'FlickrPhoto'
		var photos = [FlickrPhoto]()
		// itera a través de un array de diccionarios, cada 'foto' es un diccionario
		for result in results {
			// al array de fotos (vacío) le va agregando las fotos
			photos.append(FlickrPhoto(dictionary: result))
		}
		// devuelve un array de fotos en formato struct '[FlickrPhoto]'
		return photos
	}
}


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
Un objeto que contiene la URL para obtener los datos para crear las fotos.
*/

struct FlickrImage {
	
	//*****************************************************************
	// MARK: - Properties 
	//*****************************************************************
	
	let imageURL: String // la url para construir la foto!

	//*****************************************************************
	// MARK: - Initializers
	//*****************************************************************
	
	// init
//	init(imageURL:String) { // inicializa el objeto
//		self.imageURL = imageURL
//	}
	
	// construct a FlickrImage from a dictionary
	init(dictionary: [String:AnyObject]) {
		imageURL = dictionary[FlickrClient.JSONResponseKeys.MediumURL] as! String
	}
	
	//*****************************************************************
	// MARK: - Results
	//*****************************************************************
	
	static func urlPhotosFromResults(_ results: [[String:AnyObject]]) -> [FlickrImage] {
		
		var urlPhotos = [FlickrImage]()
		
		// iterate through array of dictionaries, each Movie is a dictionary
		for result in results {
			urlPhotos.append(FlickrImage(dictionary: result))
		}
		
		return urlPhotos
	}
	
} // end struct



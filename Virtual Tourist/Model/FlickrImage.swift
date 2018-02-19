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
	
	// construct a FlickrImage from a dictionary
	init(dictionary: [String:AnyObject]) {
		photoPath = dictionary["url_m"] as? String // FlickrClient.JSONResponseKeys.MediumURL
	}
	
	//*****************************************************************
	// MARK: - Results
	//*****************************************************************
	
	static func photosPathFromResults(_ results: [[String:AnyObject]]) -> [FlickrImage] {
		
		var photosPath = [FlickrImage]()
		
		// iterate through array of dictionaries, each 'FlickrImage' is a dictionary
		for result in results {
			photosPath.append(FlickrImage(dictionary: result))
		}
		
		return photosPath
	}
	
} // end struct



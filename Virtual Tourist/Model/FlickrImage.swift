//
//  FlickrImage.swift
//  Virtual Tourist
//
//  Created by Luciano Schillagi on 12/20/17.
//  Copyright © 2017 luko. All rights reserved.
//

/* Model */

// MARK: - FlickrImage

struct FlickrImage {
	
	// MARK: Properties
	
	let id: String
	let title: String
	let secret: String
	let server: String
	let farm: Int
	
	// MARK: Initializers
	
	// construct a FlickrImage from a dictionary
	init(dictionary: [String:AnyObject]) {
		id = dictionary[FlickrClient.ResponseKeys.Id] as! String
		title = dictionary[FlickrClient.ResponseKeys.Title] as! String
		secret = dictionary[FlickrClient.ResponseKeys.Secret] as! String
		server = dictionary[FlickrClient.ResponseKeys.Server] as! String
		farm = dictionary[FlickrClient.ResponseKeys.Farm] as! Int
		
	}
	
	static func flickrImagesFromResults(_ results: [[String:AnyObject]]) -> [FlickrImage] {
		
		var movies = [FlickrImage]()
		
		// iterate through array of dictionaries, each Movie is a dictionary
		for result in results {
			movies.append(FlickrImage(dictionary: result))
		}
		
		return movies
	}
}


//
//  FlickrConstants.swift
//  Virtual Tourist
//
//  Created by Luciano Schillagi on 12/7/17.
//  Copyright © 2017 luko. All rights reserved.
//

import Foundation

/* Networking */

//	https://api.flickr.com/services/rest/?
//	method=flickr.photos.search&
//	api_key=cfc2e1656f2fe02c4c7ada0a635b9813&
//	user_id=146417271%40N05&
//	lat=40.741895&
//	lon=-73.989308&
//	format=json&
//	nojsoncallback=1


// MARK: - Constants

struct Constants {

	// MARK: Flickr
	struct Flickr {
		static let endpoint = "https://api.flickr.com/services/rest/"
	}

	// MARK: Flickr Parameter Keys
	struct FlickrParameterKeys {
		static let method = "method"
		static let apiKey = "api_key"
		static let userID = "user_id"
		static let lat = "lat"
		static let lon = "lon"
		static let format = "format"
		static let noJsonCallback = "nojsoncallback"
	}

	// MARK: Flickr Parameter Values
	struct FlickrParameterValues {
		static let searchMethod = "flickr.photos.search"
		static let apiKey = "cfc2e1656f2fe02c4c7ada0a635b9813"
		static let userID = "146417271%40N05&"
		static let lat = "1" /* 1 means "yes" */ // CORREGIR ESTE VALOR
		static let lon = "flickr.galleries.getPhotos" // CORREGIR ESTE VALOR
		static let format = "json"
		static let noJsonCallback = "1"
	}

	// MARK: Flickr Response Keys
	struct FlickrResponseKeys {
		static let Status = "stat"
		static let Photos = "photos"
		static let Photo = "photo"
		static let Title = "title"
		static let MediumURL = "url_m"
		static let Total = "total"
	}

	// MARK: Flickr Response Values
	struct FlickrResponseValues {
		static let OKStatus = "ok"
	}

}

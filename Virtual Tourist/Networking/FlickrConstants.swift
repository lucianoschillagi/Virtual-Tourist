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

/* Abstract:
Un objeto que contiene los datos constantes requeridos para confeccionar la solicitud web.
*/

// MARK: - Constants

struct FlickrConstants {
	
	// MARK: Flickr
		static let ApiScheme = "https"
		static let ApiHost = "api.flickr.com"
		static let ApiPath = "/services/rest"

	
	// MARK: Flickr Parameter Keys
	struct ParameterKeys {
		static let Method = "method"
		static let ApiKey = "api_key"
		static let Format = "format"
		static let Lat = "lat"
		static let Lon = "lon"
		static let NoJSONCallback = "nojsoncallback"
		static let SafeSearch = "safe_search"
		static let Extras = "extras"
		static let Radius = "radius"
	}
	
	// MARK: Flickr Parameter Values
	struct ParameterValues {
		static let SearchMethod = "flickr.photos.search"
		static let ApiKey = "f27a220c68cac0df96cdf65e89085dee"
		static let ResponseFormat = "json"
		static let DisableJSONCallback = "1" /* 1 means "yes" */
		static let MediumURL = "url_m"
		static let UseSafeSearch = "1"
		static let SearchRangeKm = 10
	}
		
	// MARK: Flickr Response Keys
	struct ResponseKeys {
		static let Status = "stat"
		static let Photos = "photos"
		static let Title = "title"
		static let Photo = "photo"
		static let MediumURL = "url_m"
	}
	
	// MARK: Flickr Response Values
	struct ResponseValues {
		static let OKStatus = "ok"
	}
}


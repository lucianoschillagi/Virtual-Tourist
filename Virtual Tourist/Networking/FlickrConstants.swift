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


import UIKit

// MARK: - Constants

struct Flickr {
	
	// MARK: Flickr
	struct Constants {
		static let ApiBaseUrl = "https://api.flickr.com/services/rest/"
		static let ApiScheme = "https"
		static let ApiHost = "api.flickr.com"
		static let ApiPath = "/services/rest"
	}
	
	// MARK: Flickr Parameter Keys
	struct ParameterKeys {
		static let Method = "method"
		static let ApiKey = "api_key"
		static let Lat = "lat"
		static let Lon = "lon"
		static let Format = "format"
		static let NoJSONCallback = "nojsoncallback"
		static let SafeSearch = "safe_search"
		static let Text = "text"
		static let BoundingBox = "bbox"
		static let Page = "page"
		static let Extras = "extras"
	}
	
	// MARK: Flickr Parameter Values
	struct ParameterValues {
		static let SearchMethod = "flickr.photos.search"
		static let ApiKey = "a0a4dea38c341f52543ef6be07d85281"
		static let ResponseFormat = "json"
		static let DisableJSONCallback = "1" /* 1 means "yes" */
		static let GalleryPhotosMethod = "flickr.galleries.getPhotos"
		static let GalleryID = "5704-72157622566655097"
		static let MediumURL = "url_m"
		static let UseSafeSearch = "1"
	}
		
	// MARK: Flickr Response Keys
	struct ResponseKeys {
		static let Status = "stat"
		static let Photos = "photos"
		static let Photo = "photo"
		static let Id = "id"
		static let Secret = "secret"
		static let Server = "server"
		static let Farm = "farm"
		static let Title = "title"
		static let MediumURL = "url_m"
		static let Pages = "pages"
		static let Total = "total"
	}
	
	// MARK: Flickr Response Values
	struct ResponseValues {
		static let OKStatus = "ok"
	}
}


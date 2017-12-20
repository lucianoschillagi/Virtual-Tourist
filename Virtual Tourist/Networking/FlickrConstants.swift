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

struct Constants {
	
	// MARK: Flickr
	struct Flickr {
		static let APIScheme = "https"
		static let APIHost = "api.flickr.com"
		static let APIPath = "/services/rest"
	}
	
	// MARK: Flickr Parameter Keys
	struct FlickrParameterKeys {
		static let Method = "method"
		static let APIKey = "api_key"
		static let GalleryID = "gallery_id"
		static let Extras = "extras"
		static let Format = "format"
		static let NoJSONCallback = "nojsoncallback"
		static let SafeSearch = "safe_search"
		static let Text = "text"
		static let BoundingBox = "bbox"
		static let Page = "page"
	}
	
	// MARK: Flickr Parameter Values
	struct FlickrParameterValues {
		static let SearchMethod = "flickr.photos.search"
		static let APIKey = "200778b8a74284c35e9cf41905e84d39"
		static let ResponseFormat = "json"
		static let DisableJSONCallback = "1" /* 1 means "yes" */
		static let GalleryPhotosMethod = "flickr.galleries.getPhotos"
		static let GalleryID = "5704-72157622566655097"
		static let MediumURL = "url_m"
		static let UseSafeSearch = "1"
	}
	
	// MARK: Flickr Response Keys
	struct FlickrResponseKeys {
		static let Status = "stat"
		static let Photos = "photos"
		static let Photo = "photo"
		static let Title = "title"
		static let MediumURL = "url_m"
		static let Pages = "pages"
		static let Total = "total"
	}
	
	// MARK: Flickr Response Values
	struct FlickrResponseValues {
		static let OKStatus = "ok"
	}
	
	// FIX: As of Swift 2.2, using strings for selectors has been deprecated. Instead, #selector(methodName) should be used.
	/*
	// MARK: Selectors
	struct Selectors {
	static let KeyboardWillShow: Selector = "keyboardWillShow:"
	static let KeyboardWillHide: Selector = "keyboardWillHide:"
	static let KeyboardDidShow: Selector = "keyboardDidShow:"
	static let KeyboardDidHide: Selector = "keyboardDidHide:"
	}
	*/
}

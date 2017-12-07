//
//  FlickrNetwork.swift
//  Virtual Tourist
//
//  Created by Luciano Schillagi on 12/7/17.
//  Copyright © 2017 luko. All rights reserved.
//

import Foundation

/* Networking */

/* example request
https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=cfc2e1656f2fe02c4c7ada0a635b9813&lat=40.741895&lon=-73.989308&format=json&nojsoncallback=1&auth_token=72157689310044851-cfc4e7723cf18bcb&api_sig=752162bca40e25ed3d6675b6429150d
*/

// get images
//static func getFlickrImages(lat: Double, lng: Double, completion: @escaping (_ success: Bool, _ flickrImages:[FlickrImage]?) -> Void) {
//	let request = NSMutableURLRequest(url: URL(string: "\(flickrEndpoint)?method=\(flickrSearch)&format=\(format)&api_key=\(flickrAPIKey)&lat=\(lat)&lon=\(lng)&radius=\(searchRangeKM)")!)
//
//	let session = URLSession.shared
//
//	let task = session.dataTask(with: request as URLRequest) { data, response, error in
//
//		if error != nil {
//
//			completion(false, nil)
//			return
//		}
//
//		let range = Range(uncheckedBounds: (14, data!.count - 1))
//		let newData = data?.subdata(in: range)
//
//		if let json = try? JSONSerialization.jsonObject(with: newData!) as? [String:Any],
//			let photosMeta = json?["photos"] as? [String:Any],
//			let photos = photosMeta["photo"] as? [Any] {
//
//			var flickrImages:[FlickrImage] = []
//
//			for photo in photos {
//
//				if let flickrImage = photo as? [String:Any],
//					let id = flickrImage["id"] as? String,
//					let secret = flickrImage["secret"] as? String,
//					let server = flickrImage["server"] as? String,
//					let farm = flickrImage["farm"] as? Int {
//					flickrImages.append(FlickrImage(id: id, secret: secret, server: server, farm: farm))
//				}
//			}
//
//			completion(true, flickrImages)
//
//		} else {
//
//			completion(false, nil)
//		}
//	}
//
//	task.resume()
//}


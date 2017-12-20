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

private func displayImageFromFlickrBySearch(_ methodParameters: [String: AnyObject], withPageNumber: Int) {
	
	// add the page to the method's parameters
//	var methodParametersWithPageNumber = methodParameters
//	methodParametersWithPageNumber[Constants.FlickrParameterKeys.Page] = withPageNumber as AnyObject?
	
	// create session and request
	let session = URLSession.shared
	let request = URLRequest(url: flickrURLFromParameters(methodParameters))
	
	// create network request
	let task = session.dataTask(with: request) { (data, response, error) in
		
		// if an error occurs, print it and re-enable the UI
		func displayError(_ error: String) {
			print(error)
			performUIUpdatesOnMain {
//				self.setUIEnabled(true)
//				self.photoTitleLabel.text = "No photo returned. Try again."
//				self.photoImageView.image = nil
			}
		}
		
		/* GUARD: Was there an error? */
		guard (error == nil) else {
			displayError("There was an error with your request: \(String(describing: error))")
			return
		}
		
		/* GUARD: Did we get a successful 2XX response? */
		guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
			displayError("Your request returned a status code other than 2xx!")
			return
		}
		
		/* GUARD: Was there any data returned? */
		guard let data = data else {
			displayError("No data was returned by the request!")
			return
		}
		
		// parse the data
		let parsedResult: [String:AnyObject]!
		do {
			parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String:AnyObject]
		} catch {
			displayError("Could not parse the data as JSON: '\(data)'")
			return
		}
		
		/* GUARD: Did Flickr return an error (stat != ok)? */
		guard let stat = parsedResult[Constants.FlickrResponseKeys.Status] as? String, stat == Constants.FlickrResponseValues.OKStatus else {
			displayError("Flickr API returned an error. See error code and message in \(parsedResult)")
			return
		}
		
		/* GUARD: Is the "photos" key in our result? */
		guard let photosDictionary = parsedResult[Constants.FlickrResponseKeys.Photos] as? [String:AnyObject] else {
			displayError("Cannot find key '\(Constants.FlickrResponseKeys.Photos)' in \(parsedResult)")
			return
		}
		
		/* GUARD: Is the "photo" key in photosDictionary? */
		guard let photosArray = photosDictionary[Constants.FlickrResponseKeys.Photo] as? [[String: AnyObject]] else {
			displayError("Cannot find key '\(Constants.FlickrResponseKeys.Photo)' in \(photosDictionary)")
			return
		}
		
		if photosArray.count == 0 {
			displayError("No Photos Found. Search Again.")
			return
		} else {
			let randomPhotoIndex = Int(arc4random_uniform(UInt32(photosArray.count)))
			let photoDictionary = photosArray[randomPhotoIndex] as [String: AnyObject]
			let photoTitle = photoDictionary[Constants.FlickrResponseKeys.Title] as? String
			
			/* GUARD: Does our photo have a key for 'url_m'? */
			guard let imageUrlString = photoDictionary[Constants.FlickrResponseKeys.MediumURL] as? String else {
				displayError("Cannot find key '\(Constants.FlickrResponseKeys.MediumURL)' in \(photoDictionary)")
				return
			}
			
			// if an image exists at the url, set the image and title
			let imageURL = URL(string: imageUrlString)
			if let imageData = try? Data(contentsOf: imageURL!) {
				performUIUpdatesOnMain {
//					self.setUIEnabled(true)
//					self.photoImageView.image = UIImage(data: imageData)
//					self.photoTitleLabel.text = photoTitle ?? "(Untitled)"
				}
			} else {
				displayError("Image does not exist at \(imageURL)")
			}
		}
	}
	
	// start the task!
	task.resume()
}

// MARK: Helper for Creating a URL from Parameters

private func flickrURLFromParameters(_ parameters: [String:AnyObject]) -> URL {
	
	var components = URLComponents()
	components.scheme = Constants.Flickr.APIScheme
	components.host = Constants.Flickr.APIHost
	components.path = Constants.Flickr.APIPath
	components.queryItems = [URLQueryItem]()
	
	for (key, value) in parameters {
		let queryItem = URLQueryItem(name: key, value: "\(value)")
		components.queryItems!.append(queryItem)
	}
	
	return components.url!
}

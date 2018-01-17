////
////  FlickrClient.swift
////  Virtual Tourist
////
////  Created by Luciano Schillagi on 12/20/17.
////  Copyright © 2017 luko. All rights reserved.

/* Networking */

import Foundation

/* Abstract:
Un objeto que solicita fotos a Flickr tomando como parámetros las coordenadas del pin seleccionado.
*/

class FlickrClient: NSObject {
	
	// MARK: - Properties
	var session = URLSession.shared
	
	// MARK: - Initializers
	override init() {
		super.init()
	}
	
	// MARK: - Networking
	
	func getPhotosFromFlickr(lat: Double, lon: Double, completion: @escaping (_ success: Bool, _ flickrPhotos: [FlickrImage]?) -> Void) {
		
		/* 1. Set the parameters */
		let methodParameters: [String : Any] = [
			FlickrConstants.ParameterKeys.Method: FlickrConstants.ParameterValues.SearchMethod,
			FlickrConstants.ParameterKeys.ApiKey: FlickrConstants.ParameterValues.ApiKey,
			FlickrConstants.ParameterKeys.Format: FlickrConstants.ParameterValues.ResponseFormat,
			FlickrConstants.ParameterKeys.Lat: "35.689487", // lat
			FlickrConstants.ParameterKeys.Lon: "139.691706", // lon
			FlickrConstants.ParameterKeys.NoJSONCallback:FlickrConstants.ParameterValues.DisableJSONCallback,
			FlickrConstants.ParameterKeys.SafeSearch: FlickrConstants.ParameterValues.UseSafeSearch,
			FlickrConstants.ParameterKeys.Extras: FlickrConstants.ParameterValues.MediumURL,
			FlickrConstants.ParameterKeys.Radius: FlickrConstants.ParameterValues.SearchRangeKm
			]
		/* 2/3. Build the URL, Configure the request */
		let request = URLRequest(url: flickrURLFromParameters(methodParameters as [String:AnyObject]))
		
		/* 4. Make the request */
		let task = session.dataTask(with: request) { (data, response, error) in
			
			// Handling errors
			
			// if an error occurs, print it and re-enable the UI
			func displayError(_ error: String) {
				print(error)
				completion(false, nil)
			}
			print(response ?? "")
			
			/* GUARD: Was there an error? */
			guard (error == nil) else {
				displayError("There was an error with your request: \(error!)")
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
			print(data)
			
			/* 5. Parse the data */
			if let json = try? JSONSerialization.jsonObject(with:data) as? [String:Any],
				let photosMeta = json?[FlickrConstants.ResponseKeys.Photos] as? [String:Any],
				let photos = photosMeta[FlickrConstants.ResponseKeys.Photo] as? [Any] {
				
				print(photos)
				
				var flickrPhotos: [FlickrImage] = [] // un array fotos de flickr
				
				for photo in photos {
					
					if let flickrPhoto = photo as? [String:Any],
						let photoURL = flickrPhoto[FlickrConstants.ResponseKeys.MediumURL] as? String {
						
						flickrPhotos.append(FlickrImage(mediumURL: photoURL))
						print(photoURL)
					}
					
				}
				
				completion(true, flickrPhotos)
				
			} else {
				
				completion(false, nil)
			}
		}
		

		task.resume()
	}
	
	// create a URL from parameters
	/**
	Crea una URL con los parámetros necesarios para obtener los datos buscados.
	
	- parameter parameters: los parámetros necesarios para realizar la petición.
	
	- returns: la URL completa para realizar la petición.
	*/
	private func flickrURLFromParameters(_ parameters: [String:AnyObject]) -> URL {

		var components = URLComponents()
		components.scheme = FlickrConstants.ApiScheme
		components.host = FlickrConstants.ApiHost
		components.path = FlickrConstants.ApiPath
		components.queryItems = [URLQueryItem]()
		for (key, value) in parameters {
			let queryItem = URLQueryItem(name: key, value: "\(value)")
			components.queryItems!.append(queryItem)
		}
		return components.url!
	}
	
	// MARK: - Shared Instance
	
	class func sharedInstance() -> FlickrClient {
		struct Singleton {
			static var sharedInstance = FlickrClient()
		}
		return Singleton.sharedInstance
	}

} // end class




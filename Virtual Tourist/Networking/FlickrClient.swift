//
//  FlickrClient.swift
//  Virtual Tourist
//
//  Created by Luciano Schillagi on 12/20/17.
//  Copyright © 2017 luko. All rights reserved.

/* Networking */

import Foundation

/* Abstract:
Un objeto que solicita fotos a Flickr tomando como parámetros las coordenadas del pin seleccionado.
*/

//*****************************************************************
// MARK: - FlickrClient (NSObject)
//*****************************************************************

class FlickrClient: NSObject {
	
	//*****************************************************************
	// MARK: - Properties
	//*****************************************************************
	
	var session = URLSession.shared // shared session
	
	// modelo en 'FlickrImage'
	var photos: [FlickrImage] = [FlickrImage]()

	//*****************************************************************
	// MARK: - Initializers
	//*****************************************************************
	
	override init() {
		super.init()
	}
	
	//*****************************************************************
	// MARK: - Networking
	//*****************************************************************
	
	// obtiene las urls de las fotos
	func getPhotosPath(lat: Double,lon: Double, _ completionHandlerForGetPhotosPath: @escaping (_ result: [FlickrImage]?, _ error: NSError?) -> Void) {
		
		/* 1. Set the parameters */
		let methodParameters: [String : Any] = [
			FlickrClient.ParameterKeys.Method: FlickrClient.ParameterValues.SearchMethod,
			FlickrClient.ParameterKeys.ApiKey: FlickrClient.ParameterValues.ApiKey,
			FlickrClient.ParameterKeys.Format: FlickrClient.ParameterValues.ResponseFormat,
			FlickrClient.ParameterKeys.Lat: lat,
			FlickrClient.ParameterKeys.Lon: lon,
			FlickrClient.ParameterKeys.NoJSONCallback:FlickrClient.ParameterValues.DisableJSONCallback,
			FlickrClient.ParameterKeys.SafeSearch: FlickrClient.ParameterValues.UseSafeSearch,
			FlickrClient.ParameterKeys.Extras: FlickrClient.ParameterValues.MediumURL,
			FlickrClient.ParameterKeys.Radius: FlickrClient.ParameterValues.SearchRangeKm,
			FlickrClient.ParameterKeys.PerPage: FlickrClient.ParameterValues.PerPageAmount,
			FlickrClient.ParameterKeys.Page: Int(arc4random_uniform(6))

		]

		/* 2. Make the request 🚀 */
		let _ = taskForGetMethod(methodParameters: methodParameters as [String : AnyObject]) { (results, error) in
			
			/* 3. Send the desired value(s) to completion handler */
			if let error = error {
				
				completionHandlerForGetPhotosPath(nil, error)
			
			} else {
				
				if let photos = results?[FlickrClient.JSONResponseKeys.Photos] as? [String:AnyObject],
					 let photo = photos [FlickrClient.JSONResponseKeys.Photo] as? [[String:AnyObject]] {
					
					let flickrImages = FlickrImage.photosPathFromResults(photo) // llena el objeto 'FlickrImage' con un array de diccionarios
					completionHandlerForGetPhotosPath(flickrImages, nil)
					
				} else {
					
					completionHandlerForGetPhotosPath(nil, NSError(domain: "getPhotosPath parsing", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not parse getPhotosPath"]))
					
				}
				
			}

		}
			
	} // end method
	

	func taskForGetMethod(methodParameters: [String : AnyObject],completionHandlerForGet: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void) -> URLSessionDataTask {
		
		/* 1. Set the parameters */
		let parametersReceived = methodParameters
		
		/* 2/3. Build the URL and configure the request */
		let request = NSMutableURLRequest(url: flickrURLsFromParameters(parametersReceived) )
		
		/* 4. Make the request 🚀 */
		let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
			
			func sendError(_ error: String) {
				print(error)
				let userInfo = [NSLocalizedDescriptionKey : error]
				completionHandlerForGet(nil, NSError(domain: "taskForGETMethod", code: 1, userInfo: userInfo))
			}
			
			/* GUARD: Was there an error? */
			guard (error == nil) else {
				sendError("There was an error with your request: \(error!)")
				return
			}
			
			/* GUARD: Did we get a successful 2XX response? */
			guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
				sendError("Your request returned a status code other than 2xx!")
				return
			}
			
			/* GUARD: Was there any data returned? */
			guard let data = data else {
				sendError("No data was returned by the request!")
				return
			}
			
			/* 5/6. Parse the data and use the data (happens in completion handler) */
			self.convertDataWithCompletionHandler(data, completionHandlerForConvertData: completionHandlerForGet)
		}
		
		/* 7. Start the request */
		task.resume()
		
		return task
	}
	
	func taskForGetImage(photoPath: String, completionHandlerForImage: @escaping (_ imageData: Data?, _ error: NSError?) -> Void) -> URLSessionTask {

		/* 1. Set the parameters */
		// There are none...
		
		/* 2/3. Build the URL and configure the request */
		let url = URL(string:photoPath)! // DE PRUEBA!!!!!
		//let url = baseURL.appendingPathComponent(size).appendingPathComponent(filePath)
		let request = URLRequest(url: url)
		
		/* 4. Make the request */
		let task = session.dataTask(with: request) { (data, response, error) in
			
			func sendError(_ error: String) {
				print(error)
				let userInfo = [NSLocalizedDescriptionKey : error]
				completionHandlerForImage(nil, NSError(domain: "taskForGetMethod", code: 1, userInfo: userInfo))
			}
			
			/* GUARD: Was there an error? */
			guard (error == nil) else {
				sendError("There was an error with your request: \(error!)")
				return
			}
			
			/* GUARD: Did we get a successful 2XX response? */
			guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
				sendError("Your request returned a status code other than 2xx!")
				return
			}
			
			/* GUARD: Was there any data returned? */
			guard let data = data else {
				sendError("No data was returned by the request!")
				return
			}
			
			/* 5/6. Parse the data and use the data (happens in completion handler) */
			completionHandlerForImage(data, nil)
			
//			self.photo.imageData = data as NSData
		}
		
		/* 7. Start the request */
		task.resume()
		
		return task
	}
	
	
	//*****************************************************************
	// MARK: - Helpers
	//*****************************************************************
	
	// given raw JSON, return a usable Foundation object
	private func convertDataWithCompletionHandler(_ data: Data, completionHandlerForConvertData: (_ result: AnyObject?, _ error: NSError?) -> Void) {
		
		var parsedResult: AnyObject! = nil
		do {
			parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as AnyObject
		} catch {
			let userInfo = [NSLocalizedDescriptionKey : "Could not parse the data as JSON: '\(data)'"]
			completionHandlerForConvertData(nil, NSError(domain: "convertDataWithCompletionHandler", code: 1, userInfo: userInfo))
		}

		completionHandlerForConvertData(parsedResult, nil)
	}
	
	// crea una URL con los parámetros necesarios para obtener los datos buscados
	 private func flickrURLsFromParameters(_ parameters: [String:AnyObject]) -> URL {

		var components = URLComponents()
		components.scheme = FlickrClient.Constants.ApiScheme
		components.host = FlickrClient.Constants.ApiHost
		components.path = FlickrClient.Constants.ApiPath
		components.queryItems = [URLQueryItem]()
		
		for (key, value) in parameters {
			let queryItem = URLQueryItem(name: key, value: "\(value)")
			components.queryItems!.append(queryItem)
		}
		
		return components.url!
	}
	
	//*****************************************************************
	// MARK: - Shared Instance
	//*****************************************************************
	
	class func sharedInstance() -> FlickrClient {
		struct Singleton {
			static var sharedInstance = FlickrClient()
		}
		return Singleton.sharedInstance
	}

} // end class




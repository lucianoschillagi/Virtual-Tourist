//
//  FlickrClient.swift
//  Virtual Tourist
//
//  Created by Luciano Schillagi on 12/20/17.
//  Copyright © 2017 luko. All rights reserved.
//

import Foundation

/* Networking */

// MARK: - FlickrClient: NSObject

class FlickrClient : NSObject {
	
	// MARK: Properties
	
	// shared session
	var session = URLSession.shared
	
	// MARK: Initializers
	
	override init() {
		super.init()
	}
	
	// MARK: Make Network Request
	
	func getImageFromFlickr() {
		
		let urlOriginal = "https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=200778b8a74284c35e9cf41905e84d39&lat=-32.944243&lon=-60.650539&format=json&nojsoncallback=1"
		
		// create url and request
		let session = URLSession.shared
		let urlString = urlOriginal
		let url = URL(string: urlString)!
		let request = URLRequest(url: url)
		
		// create network request
		let task = session.dataTask(with: request) { (data, response, error) in
			
			// if an error occurs, print it and re-enable the UI
			func displayError(_ error: String) {
				print(error)
				print("URL at time of error: \(url)")
				performUIUpdatesOnMain {
					//self.setUIEnabled(true)
				}
			}
			
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
			
			// parse the data
			let parsedResult: [String:AnyObject]!
			do {
				parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String:AnyObject]
			} catch {
				displayError("Could not parse the data as JSON: '\(data)'")
				return
			}
			
			/* GUARD: Did Flickr return an error (stat != ok)? */
			guard let stat = parsedResult[FlickrClient.ResponseKeys.Status] as? String, stat == FlickrClient.ResponseValues.OKStatus else {
				displayError("Flickr API returned an error. See error code and message in \(parsedResult)")
				return
			}
			
			/* GUARD: Are the "photos" and "photo" keys in our result? */
			guard let photosDictionary = parsedResult[FlickrClient.ResponseKeys.Photos] as? [String:AnyObject] else {
				displayError("Cannot find keys '\(FlickrClient.ResponseKeys.Photos)' and '\(FlickrClient.ResponseKeys.Photo)' in \(parsedResult)")
				return
			}
			print(photosDictionary)
			
			
			// select a random photo
			//			let randomPhotoIndex = Int(arc4random_uniform(UInt32(photoArray.count)))
			//			let photoDictionary = photoArray[randomPhotoIndex] as [String:AnyObject]
			//			let photoTitle = photoDictionary[FlickrClient.ResponseKeys.Title] as? String
			
			/* GUARD: Does our photo have a key for 'url_m'? */
			//			guard let imageUrlString = photoDictionary[FlickrClient.ResponseKeys.MediumURL] as? String else {
			//				displayError("Cannot find key '\(FlickrClient.ResponseKeys.MediumURL)' in \(photoDictionary)")
			//				return
			//			}
			
			
			// if an image exists at the url, set the image and title
			//			let imageURL = URL(string: imageUrlString)
			//			if let imageData = try? Data(contentsOf: imageURL!) {
			//				performUIUpdatesOnMain {
			////					self.setUIEnabled(true)
			////					self.photoImageView.image = UIImage(data: imageData)
			////					self.photoTitleLabel.text = photoTitle ?? "(Untitled)"
			//				}
			//			} else {
			//				displayError("Image does not exist at \(imageURL!)")
			//			}
		}
		
		// start the task!
		task.resume()
	}
	
	// MARK: GET
	func taskForGETMethod(_ method: String, parameters: [String:AnyObject], completionHandlerForGET: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void) -> URLSessionDataTask {
		
		/* example request
		https://api.flickr.com/services/rest/?
		method=flickr.photos.search&
		api_key=2dbcf4eb0d7538fa7e9a1a332e84e8dc&
		lat=-32.944243&
		lon=-60.650539&
		format=json&
		nojsoncallback=1
		*/
		
		/* 1. Set the parameters */
		var parameters = parameters
		parameters[ParameterKeys.Method] = ParameterValues.SearchMethod as AnyObject?
		parameters[ParameterKeys.ApiKey] = ParameterValues.ApiKey as AnyObject?
//		parameters[ParameterKeys.Lat] = Constants.ApiKey as AnyObject? // CAMBIAR!
//		parameters[ParameterKeys.Lon] = Constants.ApiKey as AnyObject? // CAMBIAR!
		parameters[ParameterKeys.Format] = ParameterValues.ResponseFormat as AnyObject?
		parameters[ParameterKeys.NoJSONCallback] = ParameterValues.DisableJSONCallback as AnyObject?
		
		/* 2/3. Build the URL, Configure the request */
		let request = NSMutableURLRequest(url: flickrURLFromParameters(parameters))
		
		/* 4. Make the request */
		let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
			
			func sendError(_ error: String) {
				print(error)
				let userInfo = [NSLocalizedDescriptionKey : error]
				completionHandlerForGET(nil, NSError(domain: "taskForGETMethod", code: 1, userInfo: userInfo))
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
			self.convertDataWithCompletionHandler(data, completionHandlerForConvertData: completionHandlerForGET)
		}
		
		/* 7. Start the request */
		task.resume()
		
		return task
	}
	
//	func taskForGETImage(_ size: String, filePath: String, completionHandlerForImage: @escaping (_ imageData: Data?, _ error: NSError?) -> Void) -> URLSessionTask {
//
//		/* 1. Set the parameters */
//		// There are none...
//
//		/* 2/3. Build the URL and configure the request */
//		let baseURL = URL(string: config.baseImageURLString)!
//		let url = baseURL.appendingPathComponent(size).appendingPathComponent(filePath)
//		let request = URLRequest(url: url)
//
//		/* 4. Make the request */
//		let task = session.dataTask(with: request) { (data, response, error) in
//
//			func sendError(_ error: String) {
//				print(error)
//				let userInfo = [NSLocalizedDescriptionKey : error]
//				completionHandlerForImage(nil, NSError(domain: "taskForGETMethod", code: 1, userInfo: userInfo))
//			}
//
//			/* GUARD: Was there an error? */
//			guard (error == nil) else {
//				sendError("There was an error with your request: \(error!)")
//				return
//			}
//
//			/* GUARD: Did we get a successful 2XX response? */
//			guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
//				sendError("Your request returned a status code other than 2xx!")
//				return
//			}
//
//			/* GUARD: Was there any data returned? */
//			guard let data = data else {
//				sendError("No data was returned by the request!")
//				return
//			}
//
//			/* 5/6. Parse the data and use the data (happens in completion handler) */
//			completionHandlerForImage(data, nil)
//		}
//
//		/* 7. Start the request */
//		task.resume()
//
//		return task
//	}
	
	
	
	// MARK: Helpers
	/**
	Toma el objeto JSON sin procesar y lo convierte en un objeto Foundation utilizable.
	
	- parameter data: los datos crudos obtenidos de la solicitud (bytes).
	- parameter completionHandlerForConvertData: maneja la respuesta de la solicitud, si llegaron los datos los almacena como resultados, sino envía un error.
	*/

	private func convertDataWithCompletionHandler(_ data: Data, completionHandlerForConvertData: (_ result: AnyObject?, _ error: NSError?) -> Void) {
		// los valores obtenidos del resultado
		var parsedResult: AnyObject! = nil
		// convierte los datos en un objeto JSON
		do {
			parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as AnyObject
		} catch {
			// sino lanza un error
			let userInfo = [NSLocalizedDescriptionKey : "Could not parse the data as JSON: '\(data)'"]
			completionHandlerForConvertData(nil, NSError(domain: "convertDataWithCompletionHandler", code: 1, userInfo: userInfo))
		}
		// el resultado de los objetos procesados (convertidos un objeto Foundation)
		completionHandlerForConvertData(parsedResult, nil)
	}
	
	/**
	Crea una URL con los parámetros necesarios para obtener los datos buscados.
	
	- parameter parameters: los parámetros necesarios para realizar la petición.
	
	- returns: la URL completa para realizar la petición.
	*/
	private func flickrURLFromParameters(_ parameters: [String:AnyObject]) -> URL {
		// los componentes (piezas) de la URL
		var components = URLComponents()
		components.scheme = FlickrClient.Constants.ApiScheme
		components.host = FlickrClient.Constants.ApiHost
		components.path = FlickrClient.Constants.ApiPath
		components.queryItems = [URLQueryItem]()
		// itera los parámetros de la solicitud
		for (key, value) in parameters {
			let queryItem = URLQueryItem(name: key, value: "\(value)")
			components.queryItems!.append(queryItem)
		}
		
		return components.url!
	}
	
	// MARK: Shared Instance
	
	class func sharedInstance() -> FlickrClient {
		struct Singleton {
			static var sharedInstance = FlickrClient()
		}
		return Singleton.sharedInstance
	}
}

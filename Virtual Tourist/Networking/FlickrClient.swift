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

class FlickrClient: NSObject {
	
	//*****************************************************************
	// MARK: - Properties
	//*****************************************************************
	
	static var session = URLSession.shared
	
	//*****************************************************************
	// MARK: - Initializers
	//*****************************************************************
	
	override init() {
		super.init()
	}
	
	//*****************************************************************
	// MARK: - Networking
	//*****************************************************************
	
//	func taskForGETMethod(_ method: String, parameters: [String:AnyObject], completionHandlerForGET: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void) -> URLSessionDataTask
	
//	func taskForGetPhotos(lat: Double,
//												lon: Double,
//												completion: @escaping (_ success: Bool, _ results: [FlickrImage]?) -> Void) {
	
	func taskForGetPhotos(lat: Double,
												lon: Double,
												completion: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void) -> URLSessionDataTask {
		
		/* 1. Set the parameters ****************************************/
		let methodParameters: [String : Any] = [
			FlickrConstants.ParameterKeys.Method: FlickrConstants.ParameterValues.SearchMethod,
			FlickrConstants.ParameterKeys.ApiKey: FlickrConstants.ParameterValues.ApiKey,
			FlickrConstants.ParameterKeys.Format: FlickrConstants.ParameterValues.ResponseFormat,
			FlickrConstants.ParameterKeys.Lat: lat,
			FlickrConstants.ParameterKeys.Lon: lon,
			FlickrConstants.ParameterKeys.NoJSONCallback:FlickrConstants.ParameterValues.DisableJSONCallback,
			FlickrConstants.ParameterKeys.SafeSearch: FlickrConstants.ParameterValues.UseSafeSearch,
			FlickrConstants.ParameterKeys.Extras: FlickrConstants.ParameterValues.MediumURL,
			FlickrConstants.ParameterKeys.Radius: FlickrConstants.ParameterValues.SearchRangeKm
		]
		
		/* 2/3. Build the URL, Configure the request *********************/
		let request = URLRequest(url: flickrURLsFromParameters(methodParameters as [String:AnyObject]))
		
		/* 4. Make the request *******************************************/
		let task = FlickrClient.session.dataTask(with: request) { (data, response, error) in
			
			// Handling errors ----------------------------------------------
			
			// if an error occurs, print it and re-enable the UI
			func sendError(_ error: String) {
				print(error)
				let userInfo = [NSLocalizedDescriptionKey : error]
				completion(nil, NSError(domain: "taskForGETMethod", code: 1, userInfo: userInfo))
			}
			
			// test
			print(response ?? "")
			
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
			
			// test
			print(data)
			
			/* 5/6. Parse the data and use the data (happens in completion handler) ********************/
			self.convertDataWithCompletionHandler(data, completionHandlerForConvertData: completion)
		}
		
		/* 7. Start the request */
		task.resume()
		
		return task
	}
	
	
	//	// given raw JSON, return a usable Foundation object
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
	
	
	
			
//			// convierte los datos recibidos (bytes) a un objeto json y luego a un objeto foundation
//			if let json = try? JSONSerialization.jsonObject(with:data) as? [String:Any], // !!!!!!!!!
//
//				// mediante la palabra clave 'photos' a todos los miembros contenidos dentro de la palabra clave 'photos'
//				let photosMeta = json?[FlickrConstants.JSONResponseKeys.Photos] as? [String:Any],
//				// mediante la palabra clave 'photo' accede a un array con todos los objetos json
//				// contenidos dentro de la palabra clave 'photo'
//				let photoArray = photosMeta[FlickrConstants.JSONResponseKeys.Photo] as? [Any] {
//
//				// test
//				print("El objeto json recibido! \(String(describing: json))")
//				print("El array de diccionarios contenidos en la palabra clave 'photo' \(photoArray)")
//
//				// crea una variable que almacena un array, por ahora vacío, de URLs para obtener los datos que luego se convertirán en imágenes
//				// esta variable 'flickrPhotos' es una instancia de la struct 'FlickrImage'
//				var flickrPhotos: [FlickrImage] = []
//
//				//TOOD: seguir desde aca, tomar como referencia de movie mananger
//
//				if let result = result?[FlickrConstants.JSONResponseKeys.MediumURL] as? String {
//
//					let photoURL = FlickrImage.urlPhotosFromResults(result)
//					completion(photoURL, nil)
//				} else {
//					completion (nil, NSError(domain: "getFavoriteMovies parsing", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not parse getFavoriteMovies"]))
//				}
//
//			}
//
//		}
//
//		task.resume()
//
//	}
	
	

	
	
	// THE MOVIE MANANGER METHOD!!!!!
	
	// 1.taskForGETMethod
	// 2.convertDataWithCompletionHandler
	// 3.getMediumURLs (getSessionID)
	// 4.taskForGETImage
	// 5.flickrURLFromParameters
	// 6.sharedInstance
	
	
//	func taskForGETMethod(_ method: String, parameters: [String:AnyObject], completionHandlerForGET: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void) -> URLSessionDataTask {
//
//		/* 1. Set the parameters */
//		var parametersWithApiKey = parameters
//		parametersWithApiKey[ParameterKeys.ApiKey] = Constants.ApiKey as AnyObject?
//
//		/* 2/3. Build the URL, Configure the request */
//		let request = NSMutableURLRequest(url: tmdbURLFromParameters(parametersWithApiKey, withPathExtension: method))
//
//		/* 4. Make the request */
//		let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
//
//			func sendError(_ error: String) {
//				print(error)
//				let userInfo = [NSLocalizedDescriptionKey : error]
//				completionHandlerForGET(nil, NSError(domain: "taskForGETMethod", code: 1, userInfo: userInfo))
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
//			self.convertDataWithCompletionHandler(data, completionHandlerForConvertData: completionHandlerForGET)
//		}
//
//		/* 7. Start the request */
//		task.resume()
//
//		return task
//	}
	
	
//	private func getMediumURLs(_ requestToken: String?, completionHandlerForSession: @escaping (_ success: Bool, _ sessionID: String?, _ errorString: String?) -> Void) {
//
//		/* 1. Specify parameters, method (if has {key}), and HTTP body (if POST) */
//		let parameters = [TMDBClient.ParameterKeys.RequestToken: requestToken!]
//
//		/* 2. Make the request */
//		let _ = taskForGETMethod(Methods.AuthenticationSessionNew, parameters: parameters as [String:AnyObject]) { (results, error) in
//
//			/* 3. Send the desired value(s) to completion handler */
//			if let error = error {
//				print(error)
//				completionHandlerForSession(false, nil, "Login Failed (Session ID).")
//			} else {
//				if let sessionID = results?[TMDBClient.JSONResponseKeys.SessionID] as? String {
//					completionHandlerForSession(true, sessionID, nil)
//				} else {
//					print("Could not find \(TMDBClient.JSONResponseKeys.SessionID) in \(results!)")
//					completionHandlerForSession(false, nil, "Login Failed (Session ID).")
//				}
//			}
//		}
//	}
	


	
	
	

//	func taskForGETImage(_ completionHandlerForImage: @escaping (_ imageData: Data?,
//																															 _ error: NSError?) -> Void) -> URLSessionTask {
//
//		/* 1. Set the parameters */
//		// There are none...
//
//		/* 2/3. Build the URL and configure the request */
//		let url = URL(string: "https://upload.wikimedia.org/wikipedia/commons/4/4d/Cat_November_2010-1a.jpg")!
//		let request = URLRequest(url: url)
//
//		/* 4. Make the request */
//		let task = FlickrClient.session.dataTask(with: request) { (data, response, error) in
//
//			func sendError(_ error: String) {
//				print(error)
//				let userInfo = [NSLocalizedDescriptionKey : error]
//
//				// la solicitud no se pudo completar exitosamente
//				// no se obtuvieron los datos de la imágen
//				completionHandlerForImage(nil, NSError(domain: "taskForGETImage", code: 1, userInfo: userInfo))
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
//			// solicitud exitosa, se obtuvieron los datos de la imágen
//			completionHandlerForImage(data, nil)
//		}
//
//		/* 7. Start the request */
//		task.resume()
//
//		return task
//	}

	
	//*****************************************************************
	// MARK: - Helpers
	//*****************************************************************
	
	// crea una URL con los parámetros necesarios para obtener los datos buscados
	 private func flickrURLsFromParameters(_ parameters: [String:AnyObject]) -> URL {

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




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
	
	//*****************************************************************
	// MARK: - Initializers
	//*****************************************************************
	
	override init() {
		super.init()
	}
	
	//*****************************************************************
	// MARK: - Networking
	//*****************************************************************
	
	func taskForGetMethod(lat: Double,
												lon: Double,
												completion: @escaping (_ success: Bool, _ flickrPhotos: [FlickrImage]?) -> Void) {
		
		/* TASK:
		
			- Obtener los datos crudos de la soliciud (bytes) ☑️
			- Obtener el objeto json (padre) de flickr  (convertir los bytes a un objeto json) ☑️
			- Extraer los valores a utilizar ('url_m') [array de strings para luego solicitar los datos de las fotos]
			-
		
		*/
		
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
			FlickrClient.ParameterKeys.Radius: FlickrClient.ParameterValues.SearchRangeKm
		]
		/* 2/3. Build the URL, Configure the request */
		let request = URLRequest(url: flickrURLsFromParameters(methodParameters as [String:AnyObject]))
		
		/* 4. Make the request 🚀*/
		let task = session.dataTask(with: request) { (data, response, error) in
			
			// Handling errors
			
			// if an error occurs, print it and re-enable the UI
			func displayError(_ error: String) {
				print(error)
				completion(false, nil)
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
			
			// test
			print("datos crudos -> \(data)")
			
			/* 5. Parse the data */
			if let json = try? JSONSerialization.jsonObject(with:data) as? [String:Any],
				let photosMeta = json?[FlickrClient.JSONResponseKeys.Photos] as? [String:Any],
				let photos = photosMeta[FlickrClient.JSONResponseKeys.Photo] as? [Any] {
				
				// test
				print("😈 objeto json -> \(String(describing: json))")
				
				// test
				print("🤠 array de fotos. Cantidad \(photos.count) \(photos)")
				
				// crea una variable que almacena un array, por ahora vacío, de URLs para obtener los datos que luego se convertirán en imágenes
				var flickrPhotos: [FlickrImage] = []
				
				// itera sobre el array de URLs
//				for photo in photos {
//
//					// comprueba que los objetos obtenidos (flickrPhoto) sean de tipo
//					// diccionario [String:Any]...
//					if let flickrPhoto = photo as? [String:Any],
//						// ...y que las 'medium_url' sean de tipo 'String'
//						let photoURL = flickrPhoto[FlickrConstants.JSONResponseKeys.MediumURL] as? String {
//						// si es así, invoca a la instancia del array de ´FlickrJSONPhotos´
//						// (recordar que está vacío) y le empieza a agregar URLs
//						flickrPhotos.append(FlickrImage(imageURL: photoURL))
//
//						// test
//						//print(photoURL) // obtiene la secuencia de URLs para obtener los datos (mediante una solicitud web) requeridos para luego convertirlos en imagenes
//					}
//
//				}
				
				completion(true, flickrPhotos)
				
			} else {
				
				completion(false, nil)
			}
		}
		
		task.resume()
	}
	
	// TODO: implementar
	func taskForGetImage(filePath: String, completionHandlerForImage: @escaping (_ imageData: Data?, _ error: NSError?) -> Void) -> URLSessionTask {

		/* 1. Set the parameters */
		// There are none...
		
		/* 2/3. Build the URL and configure the request */
		let baseURL = URL(string: "")!
		//let url = baseURL.appendingPathComponent(size).appendingPathComponent(filePath)
		let request = URLRequest(url: baseURL)
		
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
		}
		
		/* 7. Start the request */
		task.resume()
		
		return task
	}
	
	// TODO: implementar
	func getImageUrl(_ completionHandlerForImageUrl: @escaping (_ result: [FlickrImage]?, _ error: NSError?) -> Void) {
		
//		/* 1. Specify parameters, method (if has {key}), and HTTP body (if POST) */
//		let parameters = [TMDBClient.ParameterKeys.SessionID: TMDBClient.sharedInstance().sessionID!]
//		var mutableMethod: String = Methods.AccountIDFavoriteMovies
//		mutableMethod = substituteKeyInMethod(mutableMethod, key: TMDBClient.URLKeys.UserID, value: String(TMDBClient.sharedInstance().userID!))!
//
//		/* 2. Make the request */
//		let _ = taskForGETMethod(mutableMethod, parameters: parameters as [String:AnyObject]) { (results, error) in
//
//			/* 3. Send the desired value(s) to completion handler */
//			if let error = error {
//				completionHandlerForFavMovies(nil, error)
//			} else {
//
//				if let results = results?[TMDBClient.JSONResponseKeys.MovieResults] as? [[String:AnyObject]] {
//
//					let movies = TMDBMovie.moviesFromResults(results)
//					completionHandlerForFavMovies(movies, nil)
//				} else {
//					completionHandlerForFavMovies(nil, NSError(domain: "getFavoriteMovies parsing", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not parse getFavoriteMovies"]))
//				}
//			}
//		}
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




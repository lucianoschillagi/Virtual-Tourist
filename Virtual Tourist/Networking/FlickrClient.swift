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

class FlickrClient {
	
	//*****************************************************************
	// MARK: - Properties
	//*****************************************************************
	
	var session = URLSession.shared
	
	//*****************************************************************
	// MARK: - Networking
	//*****************************************************************
	
	func taskForGetPhotos(lat: Double,
												lon: Double,
												completion: @escaping (_ success: Bool,
																									_ flickrPhotos: [FlickrImage]?) -> Void) {
		
		/* 1. Set the parameters */
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
				let photosMeta = json?[FlickrConstants.JSONResponseKeys.Photos] as? [String:Any],
				// mediante la palabra clave 'photo' accede a un array de cualquier tipo [Any]
				
//			"photo": [
//			{
//			"id": "40000561792",
//			"owner": "40976883@N04",
//			"secret": "5c54bf8bce",
//			"server": "4629",
//			"farm": 5,
//			"title": "2018-02-01_11-00-18",
//			"ispublic": 1,
//			"isfriend": 0,
//			"isfamily": 0,
//			"url_m": "https://farm5.staticflickr.com/4629/40000561792_5c54bf8bce.jpg",
//			"height_m": "500",
//			"width_m": "375"
//			},
//			{
//			"id": "25150714897",
//			"owner": "145538853@N02",
//			"secret": "2a4bea8e71",
//			"server": "4632",
//			"farm": 5,
//			"title": "#libertad de #movimiento (ppr un rato)",
//			"ispublic": 1,
//			"isfriend": 0,
//			"isfamily": 0,
//			"url_m": "https://farm5.staticflickr.com/4632/25150714897_2a4bea8e71.jpg",
//			"height_m": "438",
//			"width_m": "500"
//			},
				
				let photos = photosMeta[FlickrConstants.JSONResponseKeys.Photo] as? [Any] {
				// debug
				print(photos)
				
				// crea una variable que almacena un array, por ahora vacío, de URLs para obtener los datos que luego se convertirán en imágenes
				var flickrPhotos: [FlickrImage] = []
				
//				for photo in photos {
//
//					if let flickrPhoto = photo as? [String:Any],
//						let photoURL = flickrPhoto[FlickrConstants.JSONResponseKeys.MediumURL] as? String {
//
//						flickrPhotos.append(FlickrImage(dictionary: photoURL))
//						print(photoURL)
//					}
//
//				}
				
				// itera sobre el array de URLs
				for photo in photos {
					
					// comprueba que los objetos obtenidos (flickrPhoto) sean de tipo
					// diccionario [String:Any]...
					if let flickrPhoto = photo as? [String:Any],
						// ...y que las 'medium_url' sean de tipo 'String'
						let photoURL = flickrPhoto[FlickrConstants.JSONResponseKeys.MediumURL] as? String {
						// si es así, invoca a la instancia del array de ´FlickrJSONPhotos´
						// (recordar que está vacío) y le empieza a agregar URLs
						flickrPhotos.append(FlickrImage(imageURL: photoURL))
						// debug
						print(photoURL) // obtiene la secuencia de URLs para obtener los datos (mediante una solicitud web) requeridos para luego convertirlos en imagenes
					}
					
				}
				
				completion(true, flickrPhotos)
				
			} else {
				
				completion(false, nil)
			}
		}
		
		task.resume()
	}
	
	// NOTE: copiado de Movie Mananger, editar!
	func taskForGETImage(_ completionHandlerForImage: @escaping (_ imageData: Data?,
																															 _ error: NSError?) -> Void) -> URLSessionTask {
		
		/* 1. Set the parameters */
		// There are none...
		
		/* 2/3. Build the URL and configure the request */
		let url = URL(string: "https://upload.wikimedia.org/wikipedia/commons/4/4d/Cat_November_2010-1a.jpg")!
		let request = URLRequest(url: url)
		
		/* 4. Make the request */
		let task = session.dataTask(with: request) { (data, response, error) in
			
			func sendError(_ error: String) {
				print(error)
				let userInfo = [NSLocalizedDescriptionKey : error]
				
				// la solicitud no se pudo completar exitosamente
				// no se obtuvieron los datos de la imágen
				completionHandlerForImage(nil, NSError(domain: "taskForGETImage", code: 1, userInfo: userInfo))
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
			// solicitud exitosa, se obtuvieron los datos de la imágen
			completionHandlerForImage(data, nil)
		}
		
		/* 7. Start the request */
		task.resume()
		
		return task
	}

	
	//*****************************************************************
	// MARK: - Helpers
	//*****************************************************************
	
	// crea una URL con los parámetros necesarios para obtener los datos buscados
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




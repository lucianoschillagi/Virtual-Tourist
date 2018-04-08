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
	
	// un array que almacena las urls de las fotos descargadas desde flickr [📷]
	var photosPath: [FlickrImage] = [FlickrImage]()

	//*****************************************************************
	// MARK: - Initializers
	//*****************************************************************
	
	override init() {
		super.init()
	}
	
	//*****************************************************************
	// MARK: - Networking
	//*****************************************************************
	
	/**
	Si la solicitud es exitosa obtiene un array de diccionarios [FlickrImage]
	Cada valor del diccionario del array contiene una url para construir una foto
	Cada una de estas fotos está ASOCIADA al pin tapeado 👈
	
	- parameter lat: la latitud de la coordenada tapeada por el usuario.
	- parameter lon: la longitud de la coordenada tapeada por el usuario.
	- parameter completionHandlerForGetPhotosPath: maneja el resultado de la solicitud, si es exitosa lo almacena, sino muestra un error.
	*/
	
	func getPhotosPath(lat: Double, lon: Double, _ completionHandlerForGetPhotosPath: @escaping (_ result: [FlickrImage]?, _ error: NSError?) -> Void) {
		
		/* 1. Pone los parámetros de la solicitud web */
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

		/* 2. Le pasa las parámetros puestos a ´taskForGetMethod´ */
		let _ = taskForGetMethod(methodParameters: methodParameters as [String : AnyObject]) { (results, error) in
			
			/* 3. Envía las valores extraídos al completion handler. En este caso el valor deseado es 'un array de urls de fotos'. Representado por [FlickrImage] */
			if let error = error {
				
				completionHandlerForGetPhotosPath(nil, error)
			
			} else {
				
				if let photos = results?[FlickrClient.JSONResponseKeys.Photos] as? [String:AnyObject],
					 let photo = photos [FlickrClient.JSONResponseKeys.Photo] as? [[String:AnyObject]] {
					
					let flickrImages = FlickrImage.photosPathFromResults(photo)
					completionHandlerForGetPhotosPath(flickrImages, nil) // llena el objeto 'FlickrImage' con un array de diccionarios 👈
					
				} else {
					
					completionHandlerForGetPhotosPath(nil, NSError(domain: "getPhotosPath parsing", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not parse getPhotosPath"]))
					
				}
				
			}

		}
			
	}
	
	/**
	Realiza una solicitud ´GET´ con los datos correspondientes a la tarea.
	
	- parameter methodParameters: recibe los parámetros de la solicitud (declarados en ´getPhotosPath´)
	- parameter completionHandlerForGet: maneja el resultado de la solicitud, si es exitosa lo almacena, sino muestra un error.
	*/
	
	func taskForGetMethod(methodParameters: [String : AnyObject],completionHandlerForGet: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void) -> URLSessionDataTask {
		
		/* 1. Almacena los parámetros puestos anteriormente */
		let parametersReceived = methodParameters
		
		/* 2/3. Construye las URL y configura la solicitud */
		let request = NSMutableURLRequest(url: flickrURLsFromParameters(parametersReceived) )
		
		/* 4. La tarea a realizar con la solicitud ya configurada ✔︎ */
		let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
			
			// envía un mensaje de error si la solicitud falló
			func sendError(_ error: String) {
				print(error)
				let userInfo = [NSLocalizedDescriptionKey : error]
				completionHandlerForGet(nil, NSError(domain: "taskForGETMethod", code: 1, userInfo: userInfo))
			}
			
			/* GUARD: Hay un error? */
			guard (error == nil) else {
				sendError("There was an error with your request: \(error!)")
				return
			}
			
			/* GUARD: Se obtuvo una respuesta 2XX ? */
			guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
				sendError("Your request returned a status code other than 2xx!")
				return
			}
			
			/* GUARD: Hay datos devueltos? */
			guard let data = data else {
				sendError("No data was returned by the request!")
				return
			}
			
			/* 5/6. Parsea los datos y usa esos datos (ocurre en el completion handler) */
			self.convertDataWithCompletionHandler(data, completionHandlerForConvertData: completionHandlerForGet)
		}
		
		/* 7. Inicia la solicitud 🚀 */
		task.resume()
		
		return task
	}
	
	/**
	Realiza una solicitud ´GET´ para obtener, medienta las urls, los DATOS de las imágenes.
	
	- parameter photoPath: la url para obtener los datos de la imagen.
	- parameter completionHandlerForImage: maneja el resultado de la solicitud, si obtiene los datos de la imagen los almacena, sino muestra un error.
	*/
	
	func taskForGetImage(photoPath: String, completionHandlerForImage: @escaping (_ imageData: Data?, _ error: NSError?) -> Void) -> URLSessionTask {

		/* 1. Pone los parámetros */
		// no hay nada...
		
		/* 2/3. Construye la URL y configura la solicitud con las urls */
		let url = URL(string:photoPath)!
		let request = URLRequest(url: url)
		
		/* 4. La tarea a realizar con la solicitud ya configurada ✔︎ */
		let task = session.dataTask(with: request) { (data, response, error) in
			
			// envía un mensaje de error si la solicitud falló
			func sendError(_ error: String) {
				print(error)
				let userInfo = [NSLocalizedDescriptionKey : error]
				completionHandlerForImage(nil, NSError(domain: "taskForGetMethod", code: 1, userInfo: userInfo))
			}
			
			/* GUARD: Hay un error? */
			guard (error == nil) else {
				sendError("There was an error with your request: \(error!)")
				return
			}
			
			/* GUARD: Se obtuvo una respuesta 2XX ? */
			guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
				sendError("Your request returned a status code other than 2xx!")
				return
			}
			
			/* GUARD: Hay datos devueltos? */
			guard let data = data else {
				sendError("No data was returned by the request!")
				return
			}
			
			/* 5/6. Parsea los datos y usa esos datos (ocurre en el completion handler) */
			completionHandlerForImage(data, nil)
		}
		
		/* 7. Inicia la solicitud 🚀 */
		task.resume()
		
		return task
	}
	
	
	//*****************************************************************
	// MARK: - Helpers
	//*****************************************************************
	
	/**
	Del objeto crudo JSON recibido devuelve un objeto usable Foundation.
	
	- parameter data: los datos recibidos.
	- parameter completionHandlerForConvertData: maneja el resultado del proceso de deserialización, si el resultado es exitoso (si los datos son convertidos a un objeto ´Foundation´), los almacena, sino muestra un error.
	*/
	
	private func convertDataWithCompletionHandler(_ data: Data, completionHandlerForConvertData: (_ result: AnyObject?, _ error: NSError?) -> Void) {
		
		// el resutado parseado
		var parsedResult: AnyObject! = nil
		// comprueba que no hay errores al deserializar el objeto json
		do {
			parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as AnyObject
		} catch {
			let userInfo = [NSLocalizedDescriptionKey : "Could not parse the data as JSON: '\(data)'"]
			completionHandlerForConvertData(nil, NSError(domain: "convertDataWithCompletionHandler", code: 1, userInfo: userInfo))
		}
		
		// finalmente le pasa los datos convertidos a objetos ´Foundation´ al completion handler
		completionHandlerForConvertData(parsedResult, nil)
	}
	
	/**
	Crea una URL con los parámetros necesarios para obtener los datos buscados.
	
	- parameter parameters: los parámetros de la solicitud.
	
	- returns: la URL lista para ser usada.
	*/
	
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




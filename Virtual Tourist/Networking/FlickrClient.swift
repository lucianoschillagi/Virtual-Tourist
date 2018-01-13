////
////  FlickrClient.swift
////  Virtual Tourist
////
////  Created by Luciano Schillagi on 12/20/17.
////  Copyright © 2017 luko. All rights reserved.

import Foundation

// MARK: - FlickrClient: NSObject

class FlickrClient: NSObject {
	
	// MARK: - Properties
	
	// shared session
	var session = URLSession.shared
	
	// configuration object
	//var config = TMDBConfig()
	
	// MARK: - Initializers
	
	override init() {
		super.init()
	}
	
	// MARK: - Networking
	/**
	Mediante este método (obtener una imagen desde Flickr) creo una solicitud web conectándome con la API de Flickr. Le voy a solicitar datos. Un recurso específico que en este caso serán imágenes de galerías alojadas en Flickr. Este es un método que no toma ni devuelve nada, sólo ejecuta, al ser llamado, lo que contiene su cuerpo.
	*/
	func getImagesFromFlickr() {
		
		/* 1. Set the parameters */
		let methodParameters = [
			Flickr.ParameterKeys.Method: Flickr.ParameterValues.SearchMethod,
			Flickr.ParameterKeys.ApiKey: Flickr.ParameterValues.ApiKey,
			Flickr.ParameterKeys.Lat: "-32.944243",
			Flickr.ParameterKeys.Lon: "-60.650539",
			Flickr.ParameterKeys.Format: Flickr.ParameterValues.ResponseFormat,
			Flickr.ParameterKeys.NoJSONCallback: Flickr.ParameterValues.DisableJSONCallback,
			Flickr.ParameterKeys.Extras: Flickr.ParameterValues.MediumURL
		]
		
		/* 2/3. Build the URL, Configure the request */
		let request = URLRequest(url: flickrURLFromParameters(methodParameters as [String:AnyObject]))
		
		/* 4. Make the request */
		let task = session.dataTask(with: request) { (data, response, error) in
			
			// if an error occurs, print it and re-enable the UI
			func displayError(_ error: String) {
				print(error)
				//print("URL at time of error: \(url)")
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
			
			/* 5. Parse the data */
			let parsedResult: [String:AnyObject]!
			// do-try-catch
			do {
				parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String:AnyObject]
			} catch {
				displayError("Could not parse the data as JSON: '\(data)'")
				return
			}
			print(parsedResult)
			
			/* GUARD: Did Flickr return an error (stat != ok)? */
			guard let stat = parsedResult[Flickr.ResponseKeys.Status] as? String, stat == Flickr.ResponseValues.OKStatus else {
				displayError("Flickr API returned an error. See error code and message in \(parsedResult)")
				return
			}
			
			/* GUARD: Are the "photos" and "photo" keys in our result? */
			guard let photosDictionary = parsedResult[Flickr.ResponseKeys.Photos] as? [String:AnyObject], let photoArray = photosDictionary[Flickr.ResponseKeys.Photo] as? [[String:AnyObject]] else {
				displayError("Cannot find keys '\(Flickr.ResponseKeys.Photos)' and '\(Flickr.ResponseKeys.Photo)' in \(parsedResult)")
				return
			}
			
			/* 6. Use the data! */
			
			// select a random photo
			//let randomPhotoIndex = Int(arc4random_uniform(UInt32(photoArray.count)))
			let photoDictionary = photoArray[10] as [String:AnyObject]
			let photoTitle = photosDictionary[Flickr.ResponseKeys.Title] as? String
			
			
			/* GUARD: Does our photo have a key for 'url_m'? */
			guard let imageUrlString = photoDictionary[Flickr.ResponseKeys.MediumURL] as? String else {
				displayError("Cannot find key '\(Flickr.ResponseKeys.MediumURL)' in \(photoDictionary)")
				return
			}
			print(imageUrlString)
			
			// if an image exists at the url, set the image and title
			let imageURL = URL(string: imageUrlString)
			if let imageData = try? Data(contentsOf: imageURL!) {
				performUIUpdatesOnMain {
					//self.setUIEnabled(true)
					//self.photoImageView.image = UIImage(data: imageData)
					//self.photoTitleLabel.text = photoTitle ?? "(Untitled)"
				}
			} else {
				displayError("Image does not exist at \(imageURL!)")
			}
		}
		
		// start the task!
		task.resume()
	}
	
	// MARK: GET
	
//	func taskForGETMethod(_ method: String, parameters: [String:AnyObject], completionHandlerForGET: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void) -> URLSessionDataTask {
//
//		/* 1. Set the parameters */
//		let methodParameters = [
//			Flickr.ParameterKeys.Method: Flickr.ParameterValues.SearchMethod,
//			Flickr.ParameterKeys.ApiKey: Flickr.ParameterValues.ApiKey,
//			Flickr.ParameterKeys.Lat: "-32.944243",
//			Flickr.ParameterKeys.Lon: "-60.650539",
//			Flickr.ParameterKeys.Format: Flickr.ParameterValues.ResponseFormat,
//			Flickr.ParameterKeys.NoJSONCallback: Flickr.ParameterValues.DisableJSONCallback,
//			Flickr.ParameterKeys.Extras: Flickr.ParameterValues.MediumURL
//		]
//
//		/* 2/3. Build the URL, Configure the request */
//		let request = NSMutableURLRequest(url: flickrURLFromParameters(methodParameters as [String : AnyObject]))
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
	
	
	// MARK: - Helpers
	
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
	
	// create a URL from parameters
	/**
	Crea una URL con los parámetros necesarios para obtener los datos buscados.
	
	- parameter parameters: los parámetros necesarios para realizar la petición.
	
	- returns: la URL completa para realizar la petición.
	*/
	private func flickrURLFromParameters(_ parameters: [String:AnyObject]) -> URL {
		// los componentes (piezas) de la URL
		var components = URLComponents()
		components.scheme = Flickr.Constants.ApiScheme
		components.host = Flickr.Constants.ApiHost
		components.path = Flickr.Constants.ApiPath
		components.queryItems = [URLQueryItem]()
		// itera los parámetros de la solicitud
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
}


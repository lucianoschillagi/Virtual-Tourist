//
//  FlickrClient.swift
//  Virtual Tourist
//
//  Created by Luciano Schillagi on 12/20/17.
//  Copyright © 2017 luko. All rights reserved.
//

import Foundation

/* Networking */

/* example request
https://api.flickr.com/services/rest/?
method=flickr.photos.search&
api_key=cfc2e1656f2fe02c4c7ada0a635b9813&
lat=40.741895&lon=-73.989308&
format=json&
nojsoncallback=1&
auth_token=72157689310044851-cfc4e7723cf18bcb&
api_sig=752162bca40e25ed3d6675b6429150d
*/

// MARK: - FlickrClient: NSObject

class FlickrClient : NSObject {
	
	// MARK: Properties
	
	// shared session
	var session = URLSession.shared
	
	// MARK: Initializers
	
	override init() {
		super.init()
	}
	
	// MARK: GET
	func taskForGETMethod(_ method: String, parameters: [String:AnyObject], completionHandlerForGET: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void) -> URLSessionDataTask {
		
		/* 1. Set the parameters */
		var parametersWithApiKey = parameters
		parametersWithApiKey[ParameterKeys.ApiKey] = Constants.ApiKey as AnyObject?
		
		/* 2/3. Build the URL, Configure the request */
		let request = NSMutableURLRequest(url: tmdbURLFromParameters(parametersWithApiKey, withPathExtension: method))
		
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
	
	func taskForGETImage(_ size: String, filePath: String, completionHandlerForImage: @escaping (_ imageData: Data?, _ error: NSError?) -> Void) -> URLSessionTask {
		
		/* 1. Set the parameters */
		// There are none...
		
		/* 2/3. Build the URL and configure the request */
		let baseURL = URL(string: config.baseImageURLString)!
		let url = baseURL.appendingPathComponent(size).appendingPathComponent(filePath)
		let request = URLRequest(url: url)
		
		/* 4. Make the request */
		let task = session.dataTask(with: request) { (data, response, error) in
			
			func sendError(_ error: String) {
				print(error)
				let userInfo = [NSLocalizedDescriptionKey : error]
				completionHandlerForImage(nil, NSError(domain: "taskForGETMethod", code: 1, userInfo: userInfo))
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
	
	
	
	// MARK: Helpers
	
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
	private func flickrURLFromParameters(_ parameters: [String:AnyObject], withPathExtension: String? = nil) -> URL {
		
		var components = URLComponents()
		components.scheme = FlickrClient.Constants.APIScheme
		components.host = FlickrClient.Constants.ApiHost
		components.path = FlickrClient.Constants.ApiPath + (withPathExtension ?? "")
		components.queryItems = [URLQueryItem]()
		
		for (key, value) in parameters {
			let queryItem = URLQueryItem(name: key, value: "\(value)")
			components.queryItems!.append(queryItem)
		}
		
		return components.url!
	}
	
	// MARK: Shared Instance
	
	class func sharedInstance() -> TMDBClient {
		struct Singleton {
			static var sharedInstance = TMDBClient()
		}
		return Singleton.sharedInstance
	}
}

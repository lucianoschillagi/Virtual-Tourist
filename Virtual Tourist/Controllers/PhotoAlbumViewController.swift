//
//  PhotoAlbumViewController.swift
//  Virtual Tourist
//
//  Created by Luciano Schillagi on 12/5/17.
//  Copyright © 2017 luko. All rights reserved.
//

/* Controller */

import UIKit // interfaz de usuario
import MapKit // mapa
import CoreData // persistir datos

class PhotoAlbumViewController: UIViewController {
	
	// Properties
	@IBOutlet weak var mapFragment: MKMapView!
	@IBOutlet weak var filckrPhoto: UIImageView!
	
	// Life Cycle
	override func viewDidLoad() {
		super.viewDidLoad()
		getImageFromFlickr()
	}
	
	// MARK: Make Network Request
	
	private func getImageFromFlickr() {
		
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
	
		
} // end VC
	

	
	


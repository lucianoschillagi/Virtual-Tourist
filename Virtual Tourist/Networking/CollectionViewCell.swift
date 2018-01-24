//
//  CollectionViewCell.swift
//  Virtual Tourist
//
//  Created by Luciano Schillagi on 1/17/18.
//  Copyright © 2018 luko. All rights reserved.
//

/* Abstract:
Un objeto que representa la celda de una colección de vistas.
*/

//import UIKit
//
//class CollectionViewCell: UICollectionViewCell {
//
//	// MARK: - Outlets
//@IBOutlet weak var activityIndicator: UIActivityIndicatorView!
//@IBOutlet weak var imageViewCell: UIImageView!
//
//	// Get Photos
//	func initWithPhoto(_ photo: Photo){
//
//		if photo.imageData != nil {
//
//			DispatchQueue.main.async {
//
//				self.imageViewCell.image = UIImage(data: photo.imageData! as Data)
//				self.activityIndicator.stopAnimating()
//			}
//		} else {
//			downloadImage(photo)
//		}
//	}
//
//
//	// Downloads Images
//	func downloadImage(_ photo: Photo){
//
//
//		URLSession.shared.dataTask(with: URL(string: photo.imageURL!)!) { (data, response, error) in
//
//			if error == nil {
//				DispatchQueue.main.async {
//
//					self.imageViewCell.image = UIImage(data: data! as Data)
//					self.activityIndicator.stopAnimating()
//					self.saveImageDataToCoreData(photo, imageData: data as! NSData)
//				}
//			}
//		}
//		.resume()
//	}
//
//
//	// Save Images
//	func saveImageDataToCoreData(_ photo: Photo, imageData: NSData){
//
//		do {
//			photo.imageData = imageData
//			let delegate = UIApplication.shared.delegate as! AppDelegate
//			let stack = delegate.stack
//
//			try stack.saveContext()
//
//		} catch {
//			print("Saving Photo imageData Failed")
//		}
//	}
//
//
//	
//} // end class


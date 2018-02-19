//
//  CollectionViewCell.swift
//  Virtual Tourist
//
//  Created by Luciano Schillagi on 1/17/18.
//  Copyright © 2018 luko. All rights reserved.
//

/* View */

import UIKit

/* Abstract:
Un objeto que representa la celda de una colección de vistas.
*/

class CollectionViewCell: UICollectionViewCell {

//*****************************************************************
// MARK: - Outlets
//*****************************************************************


	//*****************************************************************
// MARK: - Methods
//*****************************************************************
	
//	//Get Photos
//	func initWithPhoto(_ photo: Photo) {
//
//		if photo.imageData != nil { // si están los datos de las fotos...
//
//			DispatchQueue.main.async {
//
//				self.imageViewCell.image = UIImage(data: photo.imageData! as Data)
//				self.activityIndicator.stopAnimating()
//			}
//			// debug
//			print("Los datos de las imágenes son los siguientes: \(String(describing: photo.imageData))")
//
//		} else {
//
//			downloadImage(photo)
//		}
//	}
//
//	// download images
//	func downloadImage(_ photo: Photo) {
//
//		URLSession.shared.dataTask(with: URL(string: photo.imageURL!)!) { (data, response, error) in
//
//			if error == nil {
//
//				DispatchQueue.main.async {
//
//					// crea la imagen
//					self.imageViewCell.image = UIImage(data: data! as Data)
//					// detiene el indicador de actividad
//					self.activityIndicator.stopAnimating()
//					// guarda los datos de la imagen en core data
//					self.saveImageDataToCoreData(photo: photo, imageData: data! as NSData)
//				}
//
//			} // end if statement
//
//			// debug
//			print("Los datos de las imágenes son los siguientes: \(String(describing: photo.imageData))")
//
//		} // end closure
//
//			.resume()
//	}
//
//	// save images
//	func saveImageDataToCoreData(photo: Photo, imageData: NSData) {
//
//		do {
//
//			photo.imageData = imageData
//			let delegate = UIApplication.shared.delegate as! AppDelegate
//			let stack = delegate.stack
//			try stack.saveContext()
//
//		} catch {
//
//			print("Saving Photo imageData Failed")
//
//		} // end do-try-catch
//
//	}

} // end class


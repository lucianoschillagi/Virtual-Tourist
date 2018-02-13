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

import UIKit

class CollectionViewCell: UICollectionViewCell {

//*****************************************************************
// MARK: - Outlets
//*****************************************************************
	
@IBOutlet weak var activityIndicator: UIActivityIndicatorView!
@IBOutlet weak var imageViewCell: UIImageView!

//*****************************************************************
// MARK: - Methods
//*****************************************************************
	
	//Get Photos
	func initWithPhoto(_ photo: Photo) {
		
		if photo.imageData != nil {
			
			DispatchQueue.main.async {
				
				self.imageViewCell.image = UIImage(data: photo.imageData! as Data)
				self.activityIndicator.stopAnimating()
			}
			
		} else {
			
			downloadImage(photo)
		}
	}
	
	// download images
	func downloadImage(_ photo: Photo) {
		
		URLSession.shared.dataTask(with: URL(string: photo.imageURL!)!) { (data, response, error) in
			if error == nil {
				
				DispatchQueue.main.async {
					
					self.imageViewCell.image = UIImage(data: data! as Data)
					self.activityIndicator.stopAnimating()
					//self.saveImageDataToCoreData(photo: photo, imageData: data! as NSData)
				}
			}
			
			}
			
			.resume()
	}

} // end class


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

	// MARK: - Outlets
@IBOutlet weak var activityIndicator: UIActivityIndicatorView!
@IBOutlet weak var imageViewCell: UIImageView!
	
	// Get Photos
	func initWithPhoto(_ photo: Photo){}
	
	
	// Downloads Images
	func downloadImage(_ photo: Photo){}
	
	
	// Save Images
	func saveImageDataToCoreData(_ photo: Photo, imageData: NSData){}

	
	
} // end class

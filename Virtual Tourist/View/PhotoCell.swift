//
//  PhotoCell.swift
//  Virtual Tourist
//
//  Created by Luciano Schillagi on 2/19/18.
//  Copyright © 2018 luko. All rights reserved.
//

import UIKit

// seguir desde : hay un problema con la celda!!!!!


class PhotoCell: UICollectionViewCell {
	
	@IBOutlet weak var photoImageView: UIImageView!
	
	override func prepareForReuse() {
		photoImageView.image = nil
	}
	
	// computed property
	
	// INCOMPLETO, LUEGO VER SI IMPLEMENTO
//	var flickrImage: FlickrImage? {
//
//		didSet {
//			if let nationalPark = park {
//				parkImageView.image = UIImage(named: nationalPark.photo)
//			}
//		}
//	}
	
//	var park: Park? {
//
//		didSet {
//			if let nationalPark = park {
//				parkImageView.image = UIImage(named: nationalPark.photo)
//			}
//		}
//	}
	
} // end class

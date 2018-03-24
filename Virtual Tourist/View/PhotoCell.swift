//
//  PhotoCell.swift
//  Virtual Tourist
//
//  Created by Luciano Schillagi on 2/19/18.
//  Copyright © 2018 luko. All rights reserved.
//

/* View */

import UIKit

/* Abstract:
Una celda personalizada de la colección de vistas.
*/

//*****************************************************************
// MARK: - Photo Cell
//*****************************************************************

class PhotoCell: UICollectionViewCell {
	
	@IBOutlet weak var photoImageView: UIImageView!
	@IBOutlet weak var activityIndicator: UIActivityIndicatorView!
	
}

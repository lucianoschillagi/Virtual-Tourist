//
//  PhotoAlbumViewController.swift
//  Virtual Tourist
//
//  Created by Luciano Schillagi on 12/5/17.
//  Copyright © 2017 luko. All rights reserved.
//

import UIKit

import UIKit // interfaz de usuario
import MapKit // mapa
import CoreData // persistir datos

/* Controller */

class PhotoAlbumViewController: UIViewController {
	
	// Properties
	@IBOutlet weak var mapFragment: MKMapView!
	@IBOutlet weak var filckrPhoto: UIImageView!
	
	// Life Cycle
	override func viewDidLoad() {
		super.viewDidLoad()
		self.navigationItem.backBarButtonItem?.title = "OK"
	}
	
	// Actions
	@IBAction func newCollection(_ sender: UIButton) {
		// TODO: recargar las fotos de las celdas de la colección
	}
	
	
} // end VC

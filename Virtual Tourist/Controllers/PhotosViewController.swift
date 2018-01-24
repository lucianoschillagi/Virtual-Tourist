//
//  PhotosViewController.swift
//  Virtual Tourist
//
//  Created by Luciano Schillagi on 1/17/18.
//  Copyright © 2018 luko. All rights reserved.
//

/* Controller */

import UIKit // interfaz de usuario
import MapKit // mapa
import CoreData // persistir datos

/* Abstract:
Un objeto que contiene:
-un fragmento de mapa con un zoom a la ubicación seleccionada
-una colección de vistas con imágenes relacionadas con esa ubicación
-un botón para actualizar la colección de imágenes
*/

class PhotosViewController: CoreDataMapAndCollectionViewController {
	
	// MARK: - Outlets
	@IBOutlet weak var mapFragment: MKMapView!
	@IBOutlet weak var collectionView: UICollectionView!
	@IBOutlet weak var newCollectionButton: UIButton!

	// MARK: - Properties
	var coordinateSelected: CLLocationCoordinate2D! // la coordenada seleccionada
	
	var savedImages:[Photo] = [] // las imágenes guardadas (core data)
	var coreDataPin: Pin! = nil
	let totalCellCount = 25
	
	//var flickrImage: [FlickrImage] = [FlickrImage]()
	let regionRadius: CLLocationDistance = 1000
	
	var selectedToDelete:[Int] = [] {
		didSet {
			if selectedToDelete.count > 0 {
				newCollectionButton.setTitle("Remove Selected Pictures", for: .normal)
			} else {
				newCollectionButton.setTitle("New Collection", for: .normal)
			}
		}
	} // end computed property
	
	
	// MARK: - Core Data
	
	
	// MARK: - View Life Cycle
	override func viewDidLoad() {
		super.viewDidLoad()
		
		// el diseño de la colección de vista, en 3 columnas separadas por 20pts
		let width = (view.frame.size.width - 20) / 3
		let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
		// el tamaño de cada item
		layout.itemSize = CGSize(width: width, height: width)
	
		// map view
		// set initial location in Honolulu, LUEGO BORRAR
		let initialLocation = CLLocation(latitude: 21.282778, longitude: -157.829444)
		centerMapOnLocation(location: initialLocation)
		
		collectionView.isHidden = false
		
		collectionView.allowsMultipleSelection = true
	
		addAnnotationToMap()
		
	} // end view did load
	
	
	override func viewWillAppear(_ animated: Bool) {
		// networking
		FlickrClient.sharedInstance().getPhotosFromFlickr(lat: 21.282778, lon:-157.829444) { (success, errorString) in
			performUIUpdatesOnMain {
				if success {
					//self.completeLogin()
				} else {
					print(errorString ?? "")
				}
			}
		}
	}
	
	// MARK: - Map View
	func centerMapOnLocation(location: CLLocation) {
		let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,regionRadius, regionRadius)
		mapFragment.setRegion(coordinateRegion, animated: true)
	}
	
	func addAnnotationToMap() {
		
		let annotation = MKPointAnnotation()
		annotation.coordinate = coordinateSelected
		mapFragment.addAnnotation(annotation)
		mapFragment.showAnnotations([annotation], animated: true)
	}
	
	func selectedToDeleteFromIndexPath(_ indexPathArray: [IndexPath]) -> [Int] {
		
		var selected: [Int] = []
		
		for indexPath in indexPathArray {
			selected.append(indexPath.row)
		}
		print(selected)
		return selected
	}
	
	
} // end VC


extension PhotosViewController {

	
	/**
	Pide el objeto de fuente de datos para la celda que corresponde al elemento especificado en la vista de colección.
	
	- parameter collectionView: la vista de colección que solicita esta información.
	- parameter indexPath: La ruta de índice que especifica la ubicación del elemento
	
	- returns: El número de filas en la sección.
	*/
	func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
		
		selectedToDelete = selectedToDeleteFromIndexPath(collectionView.indexPathsForSelectedItems!)
		let cell = collectionView.cellForItem(at: indexPath)
		
		DispatchQueue.main.async {
			cell?.contentView.alpha = 0.5
		}
	}
	
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		
		selectedToDelete = selectedToDeleteFromIndexPath(collectionView.indexPathsForSelectedItems!)
		let cell = collectionView.cellForItem(at: indexPath)
		
		DispatchQueue.main.async {
			cell?.contentView.alpha = 0.3
			cell?.contentView.backgroundColor = UIColor.cyan
		}
	}
	
} // end extension
	
	


//
//  PhotosViewController.swift
//  Virtual Tourist
//
//  Created by Luciano Schillagi on 1/29/18.
//  Copyright © 2018 luko. All rights reserved.
//

/* Controller */

import UIKit
import MapKit
import CoreData

/* Abstract:
Un objeto que contiene:
-un fragmento de mapa con un zoom a la ubicación seleccionada
-una colección de vistas con imágenes relacionadas con esa ubicación
-un botón para actualizar la colección de imágenes
*/

class PhotosViewController: CoreDataMapAndCollectionViewController {
	
	//*****************************************************************
	// MARK: - IBOutlets
	//*****************************************************************
	
	@IBOutlet weak var mapFragment: MKMapView!
	@IBOutlet weak var collectionView: UICollectionView!
	@IBOutlet weak var newCollectionButton: UIButton!
	
	//*****************************************************************
	// MARK: - Properties
	//*****************************************************************
	
	var coordinateSelected: CLLocationCoordinate2D! // la coordenada seleccionada
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
	
	// model
	var collectionData = ["1 🏆", "2 🐸", "3 🍩", "4 😸", "5 🤡", "6 👾", "7 👻", "8 👩‍🎤", "9 🎸", "10 🍖", "11 🐯", "12 🌋"]
	
	//*****************************************************************
	// MARK: - View Life Cycle
	//*****************************************************************
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		// Map View
		// set initial location in Honolulu, LUEGO BORRAR
		let initialLocation = CLLocation(latitude: 21.282778, longitude: -157.829444)
		centerMapOnLocation(location: initialLocation)
		addAnnotationToMap()
		
		// Collection View
		// el diseño de la colección de vista, en 3 columnas separadas por 20pts
		let width = (view.frame.size.width - 20) / 3
		let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
		// el tamaño de cada item
		layout.itemSize = CGSize(width: width, height: width)

		collectionView.isHidden = false
		collectionView.allowsMultipleSelection = true
	}
	
	//*****************************************************************
	// MARK: - MapView
	//*****************************************************************
	
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
	
	



//*****************************************************************
// MARK: - CollectionView Methods
//*****************************************************************

func selectedToDeleteFromIndexPath(_ indexPathArray: [IndexPath]) -> [Int] {
	
	var selected: [Int] = []
	
	for indexPath in indexPathArray {
		selected.append(indexPath.row)
	}
	print(selected)
	return selected
	}
	
} // end vc

extension PhotosViewController: UICollectionViewDataSource {
	
	// pregunta a su objeto fuente de datos por la cantidad de elementos en la sección especificada
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		
		return collectionData.count // FIX: luego cambiar
	}
	
	// pregunta al objeto de datos por la celda que corresponde al elemento especificado en la vista de colección
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath)
		
		return cell
	}
		
}

extension PhotosViewController: UICollectionViewDelegate {
	
	// le dice al delegado que el ítem en la ruta especificada fue deseleccionado.
		func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
	
			selectedToDelete = selectedToDeleteFromIndexPath(collectionView.indexPathsForSelectedItems!)
			let cell = collectionView.cellForItem(at: indexPath)
			
			// debug
			print(indexPath)
			
			// Dispatch
			DispatchQueue.main.async {
				cell?.backgroundColor = .red
				cell?.contentView.alpha = 0.2
			}
		}
	
} // end ext


//	func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
//
////		selectedToDelete = selectedToDeleteFromIndexPath(collectionView.indexPathsForSelectedItems!)
////		let cell = collectionView.cellForItem(at: indexPath)
////
////		DispatchQueue.main.async {
////			cell?.contentView.alpha = 0.5
////		}
//	}
//
//	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//
////		selectedToDelete = selectedToDeleteFromIndexPath(collectionView.indexPathsForSelectedItems!)
////		let cell = collectionView.cellForItem(at: indexPath)
////
////		DispatchQueue.main.async {
////			cell?.contentView.alpha = 0.3
////			cell?.contentView.backgroundColor = UIColor.cyan
////		}
//	}




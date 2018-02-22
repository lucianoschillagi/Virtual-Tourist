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
//	@IBOutlet weak var activityIndicator: UIActivityIndicatorView!

	//*****************************************************************
	// MARK: - Properties
	//*****************************************************************
	
	// modelo de prueba
	var collectionData: [String] = ["1 🏆", "2 🐸", "3 🍩", "4 😸", "5 🤡", "6 👾", "7 👻", "8 👩‍🎤", "9 🎸", "10 🍖", "11 🐯", "12 🌋"]
	
	// modelo en 'FlickrImage'
	var photos: [FlickrImage] = [FlickrImage]()


	// map view
	var coordinateSelected: CLLocationCoordinate2D! // la coordenada seleccionada
	let regionRadius: CLLocationDistance = 1000
	
	// collection view cell
	let totalCellCount = 25
	
	var selectedToDelete:[Int] = [] {
		
		didSet {
			
			if selectedToDelete.count > 0 {
				
				newCollectionButton.setTitle("Remove Selected Pictures", for: .normal)
				
			} else {
				
				newCollectionButton.setTitle("New Collection", for: .normal)
			}
		}
	}
	
		// core data (todavía no implementado)
//		var coreDataPin: Pin!
//		var savedPhotos:[Photo] = []
	
	//*****************************************************************
	// MARK: - IBActions
	//*****************************************************************
	
	// Borra los items de la colección seleccionados
	@IBAction func deleteSelected(_ sender: Any) {
		
		if let selected = collectionView.indexPathsForSelectedItems {
			
			let items = selected.map{$0.item}.sorted().reversed()
			
			for item in items {
				
				collectionData.remove(at: item)
			}
			
			collectionView.deleteItems(at: selected)
		}
		// test
		print("El modelo actualmente tiene \(collectionData.count) elementos")

	}
	
//	@IBAction func newCollectionPhotos(_ sender: UIButton) {
//		
//	}
//
	
	//*****************************************************************
	// MARK: - View Life Cycle
	//*****************************************************************
	
	// View Did Load
	override func viewDidLoad() {
		super.viewDidLoad()


		// UI Elements ***************************************************
		newCollectionButton.isHidden =  false
		//noPhotos.isHidden = true
		

		// Map View ****************************************************
		addAnnotationToMap()
		
		// Collection View *********************************************
		
		// el diseño de la colección de vista, en 3 columnas separadas por 20pts
		let width = (view.frame.size.width - 20) / 3
		let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
		// el tamaño de cada item
		layout.itemSize = CGSize(width: width, height: width)

		collectionView.isHidden = false
		collectionView.allowsMultipleSelection = true
		
		print("😎 \(photos.count)")
		
		}
	

	// View Will Appear
	override func viewWillAppear(_ animated: Bool) {
		
		super.viewWillAppear(animated)
		
//		{ (movies, error) in
//
//
//			// optional binding
//			if let movies = movies {
//
//				self.movies = movies
//
//				performUIUpdatesOnMain {
//
//					self.moviesTableView.reloadData()
//				}
//
//			} else {
//
//				print(error ?? "empty error")
//
//			} // end optional binding
//
//		} // end closure
		
		FlickrClient.sharedInstance().getPhotosPath(lat: coordinateSelected.latitude,
																								lon: coordinateSelected.longitude) { (photos, error) in
			
			// optional binding
			if let photos = photos {
				
				self.photos = photos
				
				// dispatch
				performUIUpdatesOnMain {
					
//					print("🏈 \(photos)") // TEST
//					print("😅 Las 'photos' obtenidas son: \(photos.count)") // TEST
					
					self.collectionView.reloadData()
					
				}
				
			} else {
				
				print(error ?? "empty error")
				
			} // end optional binding
			
			// test
			self.contarFotos()
																									
		} // end closure
		
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
	
	// test
	func contarFotos() {
		
		print("🥅 Las fotos obtenidas y almacendas son \(photos.count)")

	}
	
	
	
} // end vc

//*****************************************************************
// MARK: - Collection View Methods (Data Source)
//*****************************************************************

extension PhotosViewController: UICollectionViewDataSource, UICollectionViewDelegate {
	
//	var collectionData = ["1 🏆", "2 🐸", "3 🍩", "4 😸", "5 🤡", "6 👾", "7 👻", "8 👩‍🎤", "9 🎸", "10 🍖", "11 🐯", "12 🌋"]
//	var photos: [FlickrImage] = [FlickrImage]()
	
	// cantidad de celdas
	func collectionView(_ collectionView: UICollectionView,
											numberOfItemsInSection section: Int) -> Int {
		
//	return collectionData.count // este cuenta...
		return photos.count // porqué este no? // AHORA SÍ!!

	}
	
	// pregunta al objeto de datos por la celda que corresponde al elemento especificado en la vista de colección
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		
		let cellReuseIdentifier = "PhotoCell"
		
		// no funciona
		let photo = photos[(indexPath as NSIndexPath).row] // LEE del Modelo!
		print("🏓 \(photos.count)")

//		// FUNCIONA! // TEST
//		let cData = collectionData[(indexPath as NSIndexPath).row]
//		print("🏓 \(cData)")
		
		// get cell type
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellReuseIdentifier, for: indexPath) as! PhotoCell
		
		/* Set cell defaults */
//		cell.photoImageView.backgroundColor = .red

		
		// optional binding
		if let photoPath = photo.photoPath {

			//test
			print("🏄🏼‍♀️ \(photos.count)")
			print("🐸 \(photoPath)" )

			let _ = FlickrClient.sharedInstance().taskForGetImage(photoPath: photoPath, completionHandlerForImage: { (imageData, error) in

				if let image = UIImage(data: imageData!) {

					// dispatch
					performUIUpdatesOnMain {

						cell.photoImageView.image = image

					}

				} else {
					print(error ?? "empty error")
				}
			})

		} // end optional binding
		
		return cell
		
	} // end func
	
		// seleccionado para borrar desde los index paths de los items seleccionados
		func selectedToDeleteFromIndexPath(_ indexPathArray: [IndexPath]) -> [Int] {
	
			var selected: [Int] = []
	
			for indexPath in indexPathArray {
				selected.append(indexPath.item)
			}
			print(selected)
			return selected
		}
	
		// le dice al delegado que el ítem en la ruta especificada fue SELECCIONADO
		func collectionView(_ collectionView: UICollectionView,
												didSelectItemAt indexPath: IndexPath) {
	
			// asigna a la propiedad 'selectedToDelete' los items seleccionados en la colección de vistas
			selectedToDelete = selectedToDeleteFromIndexPath(collectionView.indexPathsForSelectedItems!)
	
			// la ´dirección´ de la celda seleccionada
			let cell = collectionView.cellForItem(at: indexPath)
	
			// Dispatch
			DispatchQueue.main.async {
				cell?.contentView.backgroundColor = .red
			}
				// debug
				print("Soy una celda y fui seleccionada. Mi dirección es \(indexPath)")
				print("Items actualmente seleccionados: \(selectedToDelete.count). \(selectedToDelete)")
	
		}
	
	
	
		// le dice al delegado que el ítem en la ruta especificada fue DESELECCIONADO
			func collectionView(_ collectionView: UICollectionView,
							 didDeselectItemAt indexPath: IndexPath) {
	
				// asigna a la propiedad 'selectedToDelete' los items seleccionados en la colección de vistas
				selectedToDelete = selectedToDeleteFromIndexPath(collectionView.indexPathsForSelectedItems!)
	
				// la ´dirección´ de la celda seleccionada
				let cell = collectionView.cellForItem(at: indexPath)
	
				// Dispatch
				DispatchQueue.main.async {
					cell?.contentView.backgroundColor = .blue
				}
	
				// debug
				print("Soy una celda y fui DESeleccionada. Mi dirección es \(indexPath)")
				print("Items actualmente seleccionados: \(selectedToDelete.count). \(selectedToDelete)")
			}
	
	
	
	
} // end ext

//*****************************************************************
// MARK: - Collection View Methods (Delegate)
//*****************************************************************

//extension PhotosViewController: UICollectionViewDelegate {
//
//	// seleccionado para borrar desde los index paths de los items seleccionados
//	func selectedToDeleteFromIndexPath(_ indexPathArray: [IndexPath]) -> [Int] {
//
//		var selected: [Int] = []
//
//		for indexPath in indexPathArray {
//			selected.append(indexPath.item)
//		}
//		print(selected)
//		return selected
//	}
//
//	// le dice al delegado que el ítem en la ruta especificada fue SELECCIONADO
//	func collectionView(_ collectionView: UICollectionView,
//											didSelectItemAt indexPath: IndexPath) {
//
//		// asigna a la propiedad 'selectedToDelete' los items seleccionados en la colección de vistas
//		selectedToDelete = selectedToDeleteFromIndexPath(collectionView.indexPathsForSelectedItems!)
//
//		// la ´dirección´ de la celda seleccionada
//		let cell = collectionView.cellForItem(at: indexPath)
//
//		// Dispatch
//		DispatchQueue.main.async {
//			cell?.contentView.backgroundColor = .red
//		}
//			// debug
//			print("Soy una celda y fui seleccionada. Mi dirección es \(indexPath)")
//			print("Items actualmente seleccionados: \(selectedToDelete.count). \(selectedToDelete)")
//
//	}
//
//
//
//	// le dice al delegado que el ítem en la ruta especificada fue DESELECCIONADO
//		func collectionView(_ collectionView: UICollectionView,
//						 didDeselectItemAt indexPath: IndexPath) {
//
//			// asigna a la propiedad 'selectedToDelete' los items seleccionados en la colección de vistas
//			selectedToDelete = selectedToDeleteFromIndexPath(collectionView.indexPathsForSelectedItems!)
//
//			// la ´dirección´ de la celda seleccionada
//			let cell = collectionView.cellForItem(at: indexPath)
//
//			// Dispatch
//			DispatchQueue.main.async {
//				cell?.contentView.backgroundColor = .blue
//			}
//
//			// debug
//			print("Soy una celda y fui DESeleccionada. Mi dirección es \(indexPath)")
//			print("Items actualmente seleccionados: \(selectedToDelete.count). \(selectedToDelete)")
//		}
//
//} // end ext





//
//  PhotoAlbumViewController.swift
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

class PhotoAlbumViewController: CoreDataViewController {
	
	//*****************************************************************
	// MARK: - IBOutlets
	//*****************************************************************
	
	@IBOutlet weak var mapFragment: MKMapView!
	@IBOutlet weak var collectionView: UICollectionView!
	@IBOutlet weak var newCollectionButton: UIButton!

	
	//*****************************************************************
	// MARK: - Properties
	//*****************************************************************
	
	// modelo de prueba
//	var collectionData: [String] = ["1 🏆", "2 🐸", "3 🍩", "4 😸", "5 🤡", "6 👾", "7 👻", "8 👩‍🎤", "9 🎸", "10 🍖", "11 🐯", "12 🌋"]
	
	// modelo en 'FlickrImage'
	var photos: [FlickrImage] = [FlickrImage]()
	
	// las fotos guardadas
	var savedImages: [Photo] = []

	// map view
	var coordinateSelected: CLLocationCoordinate2D! // la coordenada seleccionada
	let regionRadius: CLLocationDistance = 1000
	
	// collection view cell
	let photoCell = PhotoCell()
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
				
//			collectionData.remove(at: item)
				photos.remove(at: item)
				
			}
			
			collectionView.deleteItems(at: selected)
		
		}
		// test
		print("😈 El modelo actualmente tiene \(photos.count) elementos")

	}
	
	@IBAction func newCollectionPhotos(_ sender: UIButton) {
		
		// The Photo Album view has a button that initiates the download of a new album, replacing the images in the photo album with a new set from Flickr.
		
		// 1-nueva solicitud web
		
		// network request
		FlickrClient.sharedInstance().getPhotosPath(lat: coordinateSelected.latitude,
																								lon: coordinateSelected.longitude) { (photos, error) in
																									
																									// NOTE: recibe los valores desde 'FlickrClient' y los procesa acá (photos y error)
																									
				// optional binding
				if let photos = photos {
																										
				self.photos = photos
					
						} else {
																										
						print(error ?? "empty error")
																										
						} // end optional binding
																									
				// test
					self.contarFotos()
																									
		} // end closure
		
		print("👨🏽‍🔬 new collection photos!")
		
	}

	/* pregunta:
	
	cómo limitar de un modelo de elementos indeterminados (fotos) las celdas de una colección a sólo 21?

	
	
	*/
	
	
	
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
		
		
		/* Core Data */
		
		// get the stack
		let delegate = UIApplication.shared.delegate as! AppDelegate
		let stack = delegate.stack
		
		// create a fetch request
		let fr = NSFetchRequest<NSFetchRequestResult>(entityName: "Photo")
		fr.sortDescriptors = []
		
		// create the fetched results controller
		fetchedResultsController = NSFetchedResultsController(fetchRequest: fr,
																													managedObjectContext: stack.context,
																													sectionNameKeyPath: nil,
																													cacheName: nil)
		
		
		}
	

	// View Will Appear
	override func viewWillAppear(_ animated: Bool) {
		
		super.viewWillAppear(animated)
		
		// network request
		FlickrClient.sharedInstance().getPhotosPath(lat: coordinateSelected.latitude,
																								lon: coordinateSelected.longitude) { (photos, error) in

																									// NOTE: recibe los valores desde 'FlickrClient' y los procesa acá (photos y error)

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

extension PhotoAlbumViewController: UICollectionViewDataSource {
	
	// cantidad de celdas
	func collectionView(_ collectionView: UICollectionView,
											numberOfItemsInSection section: Int) -> Int {
		
		return photos.count // only 21

	}
	
	// pregunta al objeto de datos por la celda que corresponde al elemento especificado en la vista de colección
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		
		let cellReuseIdentifier = "PhotoCell"
		
		let photo = photos[(indexPath as NSIndexPath).row] // LEE del Modelo!
		print("👶🏼 \(photos.count)")
		
		// get cell type
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellReuseIdentifier, for: indexPath) as! PhotoCell
		
		// optional binding
		if let photoPath = photo.photoPath {

			//test
			print("🏄🏼‍♀️ \(photos.count)")
			print("🐸 \(photoPath)" )
			
			// network request
			let _ = FlickrClient.sharedInstance().taskForGetImage(photoPath: photoPath, completionHandlerForImage: { (imageData, error) in

				if let image = UIImage(data: imageData!) {

					// dispatch
					performUIUpdatesOnMain {
						
						cell.photoImageView.image = image
						cell.activityIndicator.stopAnimating()

					}

				} else {
					print(error ?? "empty error")
				}
			})

		} // end optional binding
		
		return cell
		
	} // end func
	
} // end ext

//*****************************************************************
// MARK: - Collection View Methods (Delegate)
//*****************************************************************

extension PhotoAlbumViewController: UICollectionViewDelegate {

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
			cell?.contentView.alpha = 0.5
		}
			// test
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
				cell?.contentView.alpha = 1.0
			}

			// debug
			print("Soy una celda y fui DESeleccionada. Mi dirección es \(indexPath)")
			print("Items actualmente seleccionados: \(selectedToDelete.count). \(selectedToDelete)")
		}

} // end ext





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
	
	// Model
	// todas las fotos recibidas
	var photos: [FlickrImage] = [FlickrImage]() // let photoPath: String?
	// contenedor con sólo 21 fotos
	var maxNumberOfCells = 21
	
	// core data
	var pin: Pin? // los pins persistidos
	var savedPhotos: [Photo] = [] // las fotos persistidas

	// map view
	var coordinateSelected: CLLocationCoordinate2D! // la coordenada seleccionada
	let regionRadius: CLLocationDistance = 1000
	
	// collection view cell
	let photoCell = PhotoCell()
	
	var selectedToDelete:[Int] = [] {
		
		didSet {
			
			if selectedToDelete.count > 0 {
				
				newCollectionButton.setTitle("Remove Selected Pictures", for: .normal)
				
			} else {
				
				newCollectionButton.setTitle("New Collection", for: .normal)
			}
		}
	}
	
	//*****************************************************************
	// MARK: - IBActions
	//*****************************************************************
	
	// Borra los items de la colección seleccionados
	@IBAction func deleteSelected(_ sender: Any) {
		
		
		if let selected = collectionView.indexPathsForSelectedItems { // las direcciones de los items seleccionados
			
			let items = selected.map{$0.item}.sorted().reversed()
			
			for item in items {
				
				photos.remove(at: item)
				
				print("\(item)")
				
			}
			
			collectionView.deleteItems(at: selected)
		
		}
		// test
		//print("😈 El modelo actualmente tiene \(photos.count) elementos")

	}
	
	@IBAction func newCollectionPhotos(_ sender: UIButton) {
		
		viewWillAppear(false)
		
	}

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
																								lon: coordinateSelected.longitude) { (photos, error) in // recibe los valores desde 'FlickrClient' y los procesa acá (photos y error)
			// optional binding
			if let photos = photos {
				
				// si se reciben fotos...
				// almacena en la propiedad 'photos' todas las fotos recibidas
				self.photos = photos
				
				// baraja las fotos recibidas (y almacenadas) para reordenarlas aleatoriemente
				let photosRandom: [FlickrImage] = photos.shuffled()
				
				// sobre las fotos ordenadas aleatoriamente...
				// si recibe más de 21 fotos ejecutar lo siguiente, sino (else) esto otro
				if photosRandom.count > self.maxNumberOfCells {
				
				// del array ya ordenado aletoriamente llenar otro array con sólo 21 fotos
				let extractFirstTwentyOne = photosRandom[0..<self.maxNumberOfCells]
				
				// prepara un array de fotos para contener las primeras 21
				var firstTwentyOne: [FlickrImage] = []
				
				// convierte la porción extraída (21) en un objeto de tipo Array
				firstTwentyOne = Array(extractFirstTwentyOne)
				
				// asigna a la propiedad 'photos' las 21 fotos seleccionadas
				self.photos = firstTwentyOne
					
				} else { // si recibe menos de 21 fotos
					
					// sino almacenar las fotos recibidas (las menos de 21) en 'photos'
					self.photos = photos
				}
				
				// dispatch
				performUIUpdatesOnMain {

					self.collectionView.reloadData()

				}

			} else {

				print(error ?? "empty error")

			} // end optional binding
																									
		} // end closure
		
	} // end viewWillAppear()
		
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
	
} // end vc

//*****************************************************************
// MARK: - Collection View Methods (Data Source)
//*****************************************************************

extension PhotoAlbumViewController: UICollectionViewDataSource {
	
	// cantidad de celdas
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		
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
	
	// seleccionado para borrar desde los index paths de los items seleccionados
	func selectedToDeleteFromIndexPath(_ indexPathArray: [IndexPath]) -> [Int] {
		
		// un array para almacenar los items seleccionados, por ahora vacío
		var selected: [Int] = []
		
		// iterar cada indexPath (dirección del item seleccionado)
		// del array de indexPath (indexPathArray)
		for indexPath in indexPathArray {
			// poner el el array 'selected' cada dirección del item seleccionado
			selected.append(indexPath.item)
			// el array ahora está llenado con los index path de los items seleccionados
		}
		print("🌈 \(selected)")
		return selected
	}
	
	
} // end ext

//*****************************************************************
// MARK: - Collection View Methods (Delegate)
//*****************************************************************

extension PhotoAlbumViewController: UICollectionViewDelegate {

	// le dice al delegado que el ítem en la ruta especificada fue SELECCIONADO
	func collectionView(_ collectionView: UICollectionView,didSelectItemAt indexPath: IndexPath) {

		// asigna a la propiedad 'selectedToDelete' los items seleccionados en la colección de vistas
		selectedToDelete = selectedToDeleteFromIndexPath(collectionView.indexPathsForSelectedItems!)

		// la ´dirección´ de la celda seleccionada
		let cell = collectionView.cellForItem(at: indexPath)

		// Dispatch
		DispatchQueue.main.async {
			cell?.contentView.alpha = 0.5
		}
			// test
//			print("Soy una celda y fui seleccionada. Mi dirección es \(indexPath)")
//			print("Items actualmente seleccionados: \(selectedToDelete.count). \(selectedToDelete)")

	}

	// le dice al delegado que el ítem en la ruta especificada fue DESELECCIONADO
		func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {

			// asigna a la propiedad 'selectedToDelete' los items seleccionados en la colección de vistas
			selectedToDelete = selectedToDeleteFromIndexPath(collectionView.indexPathsForSelectedItems!)

			// la ´dirección´ de la celda seleccionada n
			let cell = collectionView.cellForItem(at: indexPath)

			// Dispatch
			DispatchQueue.main.async {
				cell?.contentView.alpha = 1.0
			}

			// debug
//			print("Soy una celda y fui DESeleccionada. Mi dirección es \(indexPath)")
//			print("Items actualmente seleccionados: \(selectedToDelete.count). \(selectedToDelete)")
		}

} // end ext







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

class PhotoAlbumViewController: UIViewController {
	
	//*****************************************************************
	// MARK: - IBOutlets
	//*****************************************************************
	
	@IBOutlet weak var mapFragment: MKMapView!
	@IBOutlet weak var collectionView: UICollectionView!
	@IBOutlet weak var newCollectionButton: UIButton!
	
	//*****************************************************************
	// MARK: - Properties
	//*****************************************************************
	
	// model
	// un array de fotos descargadas desde flickr
	var flickrPhotos: [FlickrImage] = [FlickrImage]()
	
	// core data
	var dataController: DataController! // inyecta el data controller en este vc
	var pin: Pin! // el pin del cual son mostradas sus fotos
	var coreDataPhotos: [Photo] = [] // las fotos persistidas
	
	// map view
	var coordinateSelected: CLLocationCoordinate2D! // la coordenada seleccionada
	let regionRadius: CLLocationDistance = 1000 // el radio mostrado a partir de un punto
	
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
	// MARK: - Superview Life Cycle
	//*****************************************************************
	
	// View Did Load
	override func viewDidLoad() {
		super.viewDidLoad()
		
		// UI Elements ***************************************************
		newCollectionButton.isHidden =  false
		
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
		
		// Core Data *********************************************
		// TASK: solicita las fotos asociadas al pin tapeado y las intenta persistir
		// para tenerlas disponibles para obtenerlas luego directamente (sin tener que hacer una solicitud web)
		
		// fetch request
		let fetchRequest: NSFetchRequest<Photo> = Photo.fetchRequest()
		// predicate: las fotos asociadas al 'pin' actual
//		let predicate = NSPredicate(format: "pin == %@", pin)
//		// pone a la solicitud de búsqueda este predicado específico
//		fetchRequest.predicate = predicate
		
		// resultado de la búsqueda
		if let result = try? dataController.viewContext.fetch(fetchRequest) {
			// si el resultado de la solicitud es exitoso
			// lo guarda en el array de fotos
			coreDataPhotos = result
			// intenta guardar el contexto (para que los datos, las fotos asociadas, queden persistidas)
			try? dataController.viewContext.save()
			// y actualiza la interfaz
			collectionView.reloadData()
		}
		
		// test
		print("🤡\(coreDataPhotos.count)")
		
		
	} // end view did load
	
	// View Will Appear
	override func viewWillAppear(_ animated: Bool) {
		
		super.viewWillAppear(animated)
		
		// dispatch
		performUIUpdatesOnMain {
			
			self.collectionView.reloadData()
			
		}
		
	} // end viewWillAppear()
	
	
	//*****************************************************************
	// MARK: - IBActions
	//*****************************************************************
	
	// Borra los items de la colección seleccionados
	@IBAction func deleteSelected(_ sender: Any) {
		
		// comprueba si hay items seleccionados (array de elementos)
		if let selected: [IndexPath] = collectionView.indexPathsForSelectedItems { // las direcciones de los items seleccionados
			
			// ordena los elementos del array
			let items = selected.map{$0.item}.sorted().reversed()
			
			// itera los items del array
			for item in items {
				
				// borra los items seleccionados del array de photos (que son objetos gestionados)
				flickrPhotos.remove(at: item)
			}
			
			// y borrarlos de los datos de la 'collection view'
			collectionView.deleteItems(at: selected)
			
		}
		
	}
	
	@IBAction func newCollectionPhotos(_ sender: UIButton) {
		
		// si hay items seleccionados
		if selectedToDelete.count > 0 {
			
			print("hay más de un item seleccionado para borrar")
	
		} else {
			
			// solicitud web
			FlickrClient.sharedInstance().getPhotosPath(lat: coordinateSelected.latitude, lon: coordinateSelected.longitude) { (photos, error) in
				
				// comprueba si la solicitud de datos fue exitosa
				if let photos = photos {
					
					// si se reciben fotos...
					// almacena en la propiedad 'photos' todas las fotos recibidas (hay un límite para recibir no más de 21 fotos)
					self.flickrPhotos = photos
					
					// TODO: You can also save your photos to Core Data here, and then meet all the requirements for this project! :)
					
					// !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
					
							// dispatch
							performUIUpdatesOnMain {
					
								self.collectionView.reloadData()
					
							}
			
				} else {
					
					print(error ?? "empty error")
					
				}
				
			}
			
		}
		
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
	
	
} // end vc

//*****************************************************************
// MARK: - Collection View Methods (Data Source)
//*****************************************************************

extension PhotoAlbumViewController: UICollectionViewDataSource {
	
	// cantidad de celdas
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		
		return flickrPhotos.count

	}
	
	// pregunta al objeto de datos por la celda que corresponde al elemento especificado en la vista de colección
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		
		let photo = flickrPhotos[(indexPath as NSIndexPath).row] // LEE del Modelo!
		
		// obtiene la celda reusable
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath) as! PhotoCell
		
		// comprueba si hay fotos en el modelo
		if let photoPath = photo.photoPath {
			
			// solicitud web para obtener los DATOS de las imágenes para convertirlas a imágenes
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
				
			}) // end 'taskForGetImage' method
			
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
		
		// dispatch
		DispatchQueue.main.async {
			cell?.contentView.alpha = 0.4
		}
		
	}
	
	// le dice al delegado que el ítem en la ruta especificada fue DESELECCIONADO
	func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
		
		// asigna a la propiedad 'selectedToDelete' los items seleccionados en la colección de vistas
		selectedToDelete = selectedToDeleteFromIndexPath(collectionView.indexPathsForSelectedItems!)
		
		// la ´dirección´ de la celda seleccionada
		let cell = collectionView.cellForItem(at: indexPath)
		
		// dispatch
		DispatchQueue.main.async {
			cell?.contentView.alpha = 1.0
		}
		
	}
	
} // end ext


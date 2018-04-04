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
-una colección de vistas con las fotos asociadas a ese pin-ubicación
-un botón para actualizar la colección de fotos
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
	// un array con las fotos descargadas desde flickr
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
	
	// el estado del botón ´new collection´ depende de si hay fotos seleccionadas o no
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
		
		// New Collection Button ***************************************************
		newCollectionButton.isHidden =  false
		
		// Map View ****************************************************
		addAnnotationToMap()
		
		// Collection View *********************************************
		
		// el diseño de la colección de vista, en 3 columnas separadas por 20pts
		let width = (view.frame.size.width - 20) / 3
		let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
		layout.itemSize = CGSize(width: width, height: width) // el tamaño de cada item
		collectionView.isHidden = false
		collectionView.allowsMultipleSelection = true
		
		// Core Data *********************************************
		// TASK: solicita las fotos asociadas al pin tapeado y las intenta persistir
		// para tenerlas disponibles para obtenerlas luego directamente (sin tener que hacer una solicitud web)
		
		// solicitud de búsqueda
		let fetchRequest: NSFetchRequest<Photo> = Photo.fetchRequest()
		// predicate: filtrar ÚNICAMENTE las fotos asociadas al 'pin' actual
		let predicate = NSPredicate(format: "pin == %@", pin)
		// pone a la solicitud de búsqueda este predicado específico
		fetchRequest.predicate = predicate
		
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
	
	/// borra los items de la colección seleccionados
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
			
			// y los borra de los datos de la 'collection view'
			collectionView.deleteItems(at: selected)
			
		}
		
	}
	
	/// si no hay fotos selecciondas realizar una solicitud web para obtener un nuevo grupo de fotos
	@IBAction func newCollectionPhotos(_ sender: UIButton) {
		
		// si hay items seleccionados
		if selectedToDelete.count > 0 {
			
			print("hay más de un item seleccionado para borrar")
	
		} else {
			
			// solicitud web
			FlickrClient.sharedInstance().getPhotosPath(lat: coordinateSelected.latitude, lon: coordinateSelected.longitude) { (photos, error) in
				
				// si la solicitud fue exitosa..
				if let photos = photos {
				
					// almacena en la propiedad 'photos' todas las fotos recibidas (hay un límite para recibir no más de 21 fotos)
					self.flickrPhotos = photos
					
					// itera el array de urls (photoPath) recibidas
					for photo in self.flickrPhotos {
						// crea una constante para acceder a la propiedad de FlickImage 'photoPath'
						let photoPath = photo.photoPath
						// crea una instancia de 'Photo' para CADA item del array de fotos recibidas [FlickrImage]
						let photoCoreData = Photo(imageURL: photoPath, context: self.dataController.viewContext)
						// intenta guardar los cambios que registra el contexto (en este caso, cada vez que se agrega un nuevo objeto ´Photo´)
						try? self.dataController.viewContext.save()
						
						// test
						print("😎\(photoCoreData)")
						
					}
					
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
	
	/// hace un zoom hacia el pin mostrado
	func centerMapOnLocation(location: CLLocation) {
		let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,regionRadius, regionRadius)
		mapFragment.setRegion(coordinateRegion, animated: true)
	}
	
	/// agrega la anotación (pin) al fragmento del mapa
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
	
	/// la cantidad de items de la collección
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		
		return flickrPhotos.count

	}
	
	// la celda para item especificado
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		
		// pone las fotos descargadas de flickr en cada item de la 'collection view'
		let photo = flickrPhotos[(indexPath as NSIndexPath).row]
		
		// obtiene la celda reusable (personalizada)
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath) as! PhotoCell
		
		// comprueba si hay fotos en el modelo
		if let photoPath = photo.photoPath {
			
			// realiza la solicitud web para obtener los DATOS de las imágenes para convertirlas en imágenes
			let _ = FlickrClient.sharedInstance().taskForGetImage(photoPath: photoPath, completionHandlerForImage: { (imageData, error) in
				
				if let image = UIImage(data: imageData!) {
					
					// dispatch
					performUIUpdatesOnMain {
						
						// pone cada foto en una celda
						cell.photoImageView.image = image
						// y detiene el indicator de actividad
						cell.activityIndicator.stopAnimating()
						
					}
					
				} else {
					
					print(error ?? "empty error")
				}
				
			}) // end 'taskForGetImage' method
			
		} // end optional binding
		
		return cell
		
	} // end func
	
	// devuelve un array con las direcciones de los items seleccionados
	func selectedToDeleteFromIndexPath(_ indexPathArray: [IndexPath]) -> [Int] {
		
		// un array para almacenar los items seleccionados, por ahora vacío
		var selected: [Int] = []
		
		// itera cada indexPath (dirección del item seleccionado)
		// del array de indexPath (indexPathArray)
		for indexPath in indexPathArray {
			// pone en el array 'selected' cada dirección del item seleccionado
			selected.append(indexPath.item)
			// el array ahora está llenado con las 'direcciones' de los items seleccionados.
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


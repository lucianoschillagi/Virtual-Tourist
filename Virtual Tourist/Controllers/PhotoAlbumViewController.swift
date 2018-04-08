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
Un controlador de vista que contiene:
-un fragmento de mapa con un zoom a la ubicación seleccionada
-una colección de vistas con las fotos asociadas a ese pin-ubicación
-un botón para obtener una nueva colección de fotos
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
	
	// core data
	var dataController: DataController! // inyecta el controlador de datos (core data stack)
	
	// map view
	let regionRadius: CLLocationDistance = 1000 // el radio mostrado a partir del pin
	
	// collection view cell
	let photoCell = PhotoCell() // una celda personalizada
	
	
	// PHOTOS ---------------------------------------------------------
	// un array de fotos descargadas desde flickr (no persitidas)
	var flickrPhotos: [FlickrImage] = [FlickrImage]() // TODO: luego borrar?
	
	// un array de las fotos asociadas al pin persistidas!
	var coreDataPhotos: [Photo] = [] // las fotos persistidas
	
	
	// PIN -----------------------------------------------------------
	// el pin pasado por 'TravelLocationVC'
	var pin: Pin! = nil
	// y la coordenada de ese pin
	var coordinateSelected: CLLocationCoordinate2D! // la coordenada seleccionada
	
	
	// new collecion button -------------------------------------------
	// task: si hay fotos seleccionadas poner la leyenda "Remove Selected Pictures"
	// sino, dejarlo en "New Collection"
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
	
	// task: cuando la vista esté por aparecer, actualizar los el modelo que toma la ´collectionView´
	override func viewWillAppear(_ animated: Bool) {
		
		super.viewWillAppear(animated)
		
		// dispatch
		performUIUpdatesOnMain {
			
			self.collectionView.reloadData() // ACTUALIZA EL MODELO
			
		}
		
	}
	
	// task: cuando la vista se haya cargado, realizar las siguientes instrucciones:
	override func viewDidLoad() {
		super.viewDidLoad()
		
		// cuando la supervista se cargó...
		
		// muestra el ´new collection button´
		newCollectionButton.isHidden =  false
		
		// agrega un pin al mapa
		addAnnotationToMap()
		
		// le da diseño a la colección de vistas
		collectionViewLayout()

		// y busca si hay objetos 'Photo' persistidos
		fetchRequestForPhotos()

	}
	
	//*****************************************************************
	// MARK: - Collection View Layout
	//*****************************************************************
	
	// task: darle un diseño personalizado a la 'collectionView'
	func collectionViewLayout() {
		
		// el diseño de la colección de vista, en 3 columnas separadas por 20pts
		let width = (view.frame.size.width - 20) / 3
		let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
		layout.itemSize = CGSize(width: width, height: width) // el tamaño de cada item
		
		collectionView.isHidden = false
		collectionView.allowsMultipleSelection = true
		
	}
	
	//*****************************************************************
	// MARK: - Core Data (fetch request)
	//*****************************************************************
	
	/// task: buscar si hay objetos 'Photo' persistidos
	func fetchRequestForPhotos() {
		
		// hay objetos 'Photo' persistidos? 🔍
		let fetchRequest: NSFetchRequest<Photo> = Photo.fetchRequest()
		
		// predicate: filtrar ÚNICAMENTE las fotos asociadas al 'pin' actual 👈
		let predicate = NSPredicate(format: "pin == %@", pin)
		
		// pone a la solicitud de búsqueda este predicado específico
		fetchRequest.predicate = predicate
		
		// resultado de la búsqueda
		if let result = try? dataController.viewContext.fetch(fetchRequest) {
			
			// si el resultado de la solicitud es exitoso
			// lo guarda en el array de fotos
			coreDataPhotos = result // coreDataPhotos: [Photo] 🔌
			
			// intenta guardar el contexto (para que los datos, las fotos asociadas, queden persistidas)
			try? dataController.viewContext.save() // 💿
			
			// y actualiza la interfaz con los datos...
			
			// dispatch
			performUIUpdatesOnMain {
				
				self.collectionView.reloadData() // ACTUALIZA EL MODELO
				
			}
		}
		
	}
	
	//*****************************************************************
	// MARK: - IBActions
	//*****************************************************************
	
	/// task: borrar los items de la colección que han sido seleccionados
	@IBAction func deleteSelected(_ sender: Any) {
		
		// comprueba si hay items seleccionados (array de index paths)
		if let selected: [IndexPath] = collectionView.indexPathsForSelectedItems {
			
			// ordena los elementos del array
			let items = selected.map{$0.item}.sorted().reversed()
			
			// itera los items del array
			for item in items {
				
				// borra los items seleccionados del array de photos (que son objetos gestionados)
				coreDataPhotos.remove(at: item) // TODO: volver !!!!!!!!!!!!!!!
			}
			
			// y los borra de los datos de la 'collection view'
			collectionView.deleteItems(at: selected)
			
		}
		
	}
	
	/// task: devolver un array con las direcciones de los items seleccionados
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
	
	
	/// task: si no hay fotos seleccionadas realizar una solicitud web para obtener un nuevo set de fotos y guardar
	@IBAction func newCollectionPhotos(_ sender: UIButton) {
		
		// si hay items seleccionados
		if selectedToDelete.count > 0 {
			
			print("hay más de un item seleccionado para borrar")
	
		} else {
			
			// Flickr Client 👈 ///////////////////////////////////////////////////////////////////////////////////////
			
			/// task: obtener un nuevo set de fotos asociadas a un pin determinado y guardarlas
			FlickrClient.sharedInstance().getPhotosPath(lat: coordinateSelected.latitude, lon: coordinateSelected.longitude) { (photos, error) in
				
				// si la solicitud fue exitosa..
				if let photos = photos {
				
					// almacena en la propiedad 'flickrPhotos: [FlickrImage]' todas las fotos recibidas (hay un límite para recibir no más de 21 fotos)
					self.flickrPhotos = photos
					
					// itera el array de urls (photoPath) recibidas
					// [FlickrImage]
					for photo in self.flickrPhotos {
						
							// crea una constante para acceder a la propiedad de 'FlickImage.photoPath'
							let photoPath = photo.photoPath
						
						
						
						

							// Core Data CREATES and SAVE photos ////////////////////////////////////////////////////////////
						
							// 'FlickImage.photoPath' -> 'Photo.imageURL'
						
							// crea una instancia de 'Photo' para CADA item del array de fotos recibidas [FlickrImage]
							let photoCoreData = Photo(imageURL: photoPath, context: self.dataController.viewContext) // 👏
						
							// agrega la referencia del pin que 'agrupa' esas fotos
							photoCoreData.pin = self.pin
						
							// puebla [Photo] con las 'imageURL' iteradas de 'FlickImage.photoPath' // 👏
							self.coreDataPhotos.append(photoCoreData)
						
							// intenta guardar los cambios que registra el contexto (en este caso, cada vez que se agrega una nueva instancia de 'Photo')
							try? self.dataController.viewContext.save() // 💿
						
							// test
							print("😆\(self.coreDataPhotos)")
						
							////////////////////////////////////////////////////////////////////////////////////////////////
						
						
						
						
						
						
					} // end for-in loop
					
							// dispatch
							performUIUpdatesOnMain {
								
								// y actualiza los datos de la 'collection view'
								self.collectionView.reloadData()
					
							}
			
				} else {
					
					print(error ?? "empty error")
					
				}
				
			}
			
		}
		
		/////////////////////////////////////////////////////////////////////////////////////////////////////////////
		
	}
	
	//*****************************************************************
	// MARK: - MapView
	//*****************************************************************
	
	/// task: hacer un zoom hacia el pin mostrado
	func centerMapOnLocation(location: CLLocation) {
		let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,regionRadius, regionRadius)
		mapFragment.setRegion(coordinateRegion, animated: true)
	}
	
	/// task: agregar la anotación (pin) al mapa
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
	
	// collection view 🔌 model [Photo]
	
	/// task: poblar los items de la sección con la cantidad de elementos que tenga actualmente el modelo [Photo]
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		
		return coreDataPhotos.count // 👈 MODEL

	}
	
	/// task: poblar los items de la colección con los datos actuales del modelo
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		
		// pone las fotos persistidas en [Photo] en cada item de la 'collection view'
		let photo = coreDataPhotos[(indexPath as NSIndexPath).row] // 👈 MODEL [Photo]
		
		// obtiene la celda reusable (personalizada)
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath) as! PhotoCell
	
		// si hay datos de imagenes persitidos...
		if photo.imageData != nil {
			
			// mostrarlos!!!
			
			// test
			print("mostrar las imagenes persistidas")
			
			// comprueba si hay 'urls para crear la imágenes' en el modelo [Photo]
			if let photoPath = photo.imageURL {
				
				// Flickr Client 👈 ///////////////////////////////////////////////////////////////////////////imageData
				
				// realiza la solicitud web para obtener los DATOS de las imágenes para convertirlas luego en imágenes
				let _ = FlickrClient.sharedInstance().taskForGetImage(photoPath: photoPath, completionHandlerForImage: { (imageData, error) in
					
					// si están los datos de imagen...
					if let image = UIImage(data: imageData!) {
						
						// asigna los datos de la imagen a la propiedad del objeto gestionado 'Photo.imageData' 🔌
						// (ahora los datos de las imágenes están almacenadas en core data!)
						photo.imageData = NSData.init(data: imageData!)
						
						// dispatch
						performUIUpdatesOnMain {
							
							// y los muestra...
							
							// y pone la imagen creada en la vista de celda 👏
							cell.photoImageView.image = image
							
							// por último se detiene el indicator de actividad
							cell.activityIndicator.stopAnimating()
							
						}
						
					} else {
						
						print(error ?? "empty error")
					}
					
				}) // end 'taskForGetImage' method
				
			} // end optional binding
			
			
		} else  {
			
			// flickr request
			print("solicitar un set de fotos a flickr")
		}
		
		
		return cell
		
	} // end func
	
} // end ext

//*****************************************************************
// MARK: - Collection View Methods (Delegate)
//*****************************************************************

extension PhotoAlbumViewController: UICollectionViewDelegate {
	
	// task: decirle al delegado que el ítem en la ruta especificada ha sido SELECCIONADO
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
	
	// task: decirle al delegado que el ítem en la ruta especificada ha sido DESELECCIONADO
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


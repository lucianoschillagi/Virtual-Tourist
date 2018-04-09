//
//  TravelLocationsMapViewController.swift
//  Virtual Tourist
//
//  Created by Luciano Schillagi on 1/17/18.
//  Copyright © 2018 luko. All rights reserved.
//

/* Controller */

import UIKit
import MapKit
import CoreData

/* Abstract:
Un objeto que representa un mapa donde el usuario puede marcar ubicaciones a través de pins.
*/

class TravelLocationsMapViewController: UIViewController {
	
	//*****************************************************************
	// MARK: - IBOutlets
	//*****************************************************************
	
	@IBOutlet weak var editButton: UIBarButtonItem!
	@IBOutlet weak var mapView: MKMapView!
	@IBOutlet weak var deletePinsMessage: UIView!
	
	//*****************************************************************
	// MARK: - Properties
	//*****************************************************************
	
	// core data
	var dataController: DataController! // inyecta el controlador de datos (core data stack)
	
	// edit mode
	var editMode: Bool = false

	// PINS -----------------------------------------------------------
	// un array que contiene los objetos 'Pin' persistidos
	var pins: [Pin] = []
	
	// los pins persistidos que se convierten en vistas de anotaciones del mapa
	var pinsOnMap: [PinOnMap] = []
	
	// el pin a pasar al 'PhotosAlbumVC'
	var pinToPass: Pin? = nil
	
	// y la coordenada de ese pin
	var pinCoordinate: CLLocationCoordinate2D? = nil

	
	// PHOTOS ---------------------------------------------------------
	// un array de fotos descargadas desde flickr
	var flickrPhotos: [FlickrImage] = [FlickrImage]()
	
	//*****************************************************************
	// MARK: - Life Cycle
	//*****************************************************************
	
	// task: ejectuar las instrucciones de su cuerpo cuando la vista se haya cargado
	override func viewDidLoad() {
		super.viewDidLoad()
		
		// cuando la supervista se cargó...
		
		// pone el botón edit-done
		setEditDoneButton()
		
		// y busca si hay objetos 'Pin' persistidos
		fetchRequestForPins()
		
	}
	
	//*****************************************************************
	// MARK: - Core Data (fetch request)
	//*****************************************************************
	
	/// task: buscar si hay objetos 'Pin' persistidos
	func fetchRequestForPins() {
		
		// hay objetos 'Pin' persistidos?
		let fetchRequest: NSFetchRequest<Pin> = Pin.fetchRequest() // 🔍
	
		// comprueba si hay resultados en la búsqueda..
		if let result = try? dataController.viewContext.fetch(fetchRequest) {
			
			// .. si es así, asigna el resultado de la solicitud al array de pins persistidos
			pins = result // pins:[Pin] 🔌
		}
		
		// luego itera ese array pins
		for pin in pins { //
			// y a las coordenadas de los pins persistidos..
			let coordinate = CLLocationCoordinate2D(latitude: pin.latitude , longitude: pin.longitude )
			// las convierte en objetos que adoptan el protocolo 'MKAnnotation'
			let pins = PinOnMap(coordinate: coordinate)
			// y los agrega al array de objetos preparados para mostrarse en una vista de mapa
			pinsOnMap.append(pins)
		}
		
		// por último, actualiza la vista de mapa agregando los pins persistidos.
		mapView.addAnnotations(pinsOnMap)
		
	}
	
	
	//*****************************************************************
	// MARK: - Edit-Done Button
	//*****************************************************************
	
	/// task: poner el botón edit-done en la barra de navegación
	func setEditDoneButton() {
		self.navigationItem.rightBarButtonItem = self.editButtonItem
	}
	
	/// establece si el controlador de vista muestra una vista editable
	override func setEditing(_ editing: Bool, animated: Bool) {
		
		super.setEditing(editing, animated: animated)
		
		// si la vista 'tap pins to delete' está oculta el modo edición estará en false
		deletePinsMessage.isHidden = !editing
		// si el modo edición es habilitado, poner ´editMode´ a ´true´
		editMode = editing
		
}
	
	//*****************************************************************
	// MARK: - IBActions
	//*****************************************************************
	
	// task: cuando el usuario haga tap sobre el mapa
	// realizar estas 3 tareas:
	
	/* 1 - addPinToMap: poner un pin sobre el sitio tapeado */
	/* 2 - addPinToCoreData: persistir la ubicación de ese pin (latitud y longitud) */
	/* 3 - requestFlickrPhotosFromPin: efectuar una solicitud web a Flickr para obtener las fotos asociadas a esa ubicación (pin) */
	
	/* 1/3 Map View */
	@IBAction func addPinToMap(_ sender: UITapGestureRecognizer) {
		
		// test
		print("se agrega un nuevo pin")
		
		// Pin on map ----------------------------------------------------
		/* 1 - addPinToMap: aparece el pin sobre el sitio tapeado */
		
		// edit-mode: FALSE
		// se pueden agregar pines
		if !editMode {
			
			// las coordenadas del tapeo sobre el mapa
			let gestureTouchLocation: CGPoint = sender.location(in: mapView) 
			
			// convierte las coordenadas de un punto sobre la vista de un mapa (x, y) - CGPoint
			// en unas coordenadas de mapa (latitud y longitud) - CLLocationCoordinate2D
			let coordToAdd: CLLocationCoordinate2D = mapView.convert(gestureTouchLocation, toCoordinateFrom: mapView)
			
			// una determinada anotación (pin) sobre un punto del mapa
			let annotation: MKPointAnnotation = MKPointAnnotation()
			
			// ese pin ubicado en las coordenadas del mapa
			annotation.coordinate = coordToAdd // CLLocationCoordinate2D
			
			// agrega ese pin al mapa
			mapView.addAnnotation(annotation) // MKPointAnnotation
			
			// CoreData ----------------------------------------------------
			/* 2- que se persista la ubicación de ese pin (latitud y longitud) en core data */
			addPinToCoreData(coord: coordToAdd)

			// Networking ----------------------------------------------------
			/* 3 - que se efectúe la solicitud web a Flickr para obtener las fotos asociadas a la ubicación-pin en caso de que el pin no tenga ya un set de fotos persistidas */
			
			// realiza una solicitud web para obtener las fotos asociadas al pin
			requestFlickrPhotosFromPin(coord: coordToAdd)

		} // end if
	
	} // end func
	
	//*****************************************************************
	// MARK: - Core Data (creates and save Pin)
	//*****************************************************************
	
	/* 2/3 Core Data */
	/// persiste la coordenada tapeada
	func addPinToCoreData(coord: CLLocationCoordinate2D) {
		
		
		// Core Data CREATES and SAVE pin ///////////////////////////////
		
		// crea un objeto gestionado 'pin' para almacenar la coordenada tapeada
		let pin = Pin(latitude: coord.latitude, longitude: coord.longitude, context: dataController.viewContext)
		
		// agrega el pin (managed object) a un array que contiene los pins persistidos '[Pin]'
		pins.append(pin)
		
		// intenta guardar los cambios que registra el contexto (en este caso, que se agregó un nuevo objeto ´Pin´)
		try? dataController.viewContext.save() // 💿
		
		///////////////////////////////////////////////////
		
		
	}

	//*****************************************************************
	// MARK: - Networking (Photos for Pin)
	//*****************************************************************
	
	/* 3/3 Flickr (networking) */
	/// solicita a flickr las fotos asociadas a esa coordenada
	func requestFlickrPhotosFromPin(coord: CLLocationCoordinate2D) {
		
		// Flickr Client 👈 ///////////////////////////////////////////////////////////////////////////////////////
		
		// solicitud web
		FlickrClient.sharedInstance().getPhotosPath(lat: coord.latitude, lon: coord.longitude) { (photos, error) in

			// comprueba si la solicitud de datos fue exitosa
			if let photos = photos {

				// si se reciben fotos...
				// almacena en la propiedad 'photos' todas las fotos recibidas (hay un límite para recibir no más de 21 fotos)
				self.flickrPhotos = photos // flickrPhotos = [FlickrImage] 🔌

			} else {

				print(error ?? "empty error")

			} // end optional binding

		} // end closure
		
		// test
		print("\(flickrPhotos)")
		
		/////////////////////////////////////////////////////////////////////////////////////////////////////////////

	} // end func
	
} // end class


//*****************************************************************
// MARK: - Navigation (Segue)
//*****************************************************************

extension TravelLocationsMapViewController {
	
	// task: enviar a 'PhotoAlbumViewController' una serie de datos
	override func prepare(for segue: UIStoryboardSegue,sender: Any?) {
		
		if segue.identifier == "PinPhotos" {
			
			// el destino de la transición, el 'PhotosAlbumViewController'
			let photoAlbumVC = segue.destination as! PhotoAlbumViewController
			
			// el remitente será una coordenada (pin) puesto sobre el mapa
			let coord = sender as! CLLocationCoordinate2D
			
			
			// le pasa a 'PhotoAlbumViewController' los siguientes datos: ///////////////////////////////
			
			/*
			1- el controlador de datos (core data)
			2- el pin coincidente
			3- la coordenada de ese pin
			4- las fotos recibidas desde flickr 'flickrPhotos:[FlickrImage]'
			*/
			
			// el controlador de datos
			photoAlbumVC.dataController = dataController
			
			// el pin coincidente..
			photoAlbumVC.pin = pinToPass
			
			// ..y su coordenada
			photoAlbumVC.coordinateSelected = coord
			
			// y pasa las fotos recibidas desde flickr
			photoAlbumVC.flickrPhotos = flickrPhotos
			
			///////////////////////////////////////////////////////////////////////////////////////////////
			
			
		} // end if
		
	} // end func
	
} // end ext


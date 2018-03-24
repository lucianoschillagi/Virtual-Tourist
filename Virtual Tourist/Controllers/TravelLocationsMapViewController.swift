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
Un objeto que representa un mapa donde el usuario puede marcar localizaciones a través de pins.
*/

class TravelLocationsMapViewController: UIViewController {
	
	//*****************************************************************
	// MARK: - IBOutles
	//*****************************************************************
	
	@IBOutlet weak var mapView: MKMapView!
	@IBOutlet weak var deletePins: UIView!
	@IBOutlet weak var editButton: UIBarButtonItem!
	
	//*****************************************************************
	// MARK: - Properties
	//*****************************************************************
	
	/// inyecta el controlador de datos
	var dataController: DataController!
	
	// edit mode
	var editMode: Bool = false

	/// un array que contiene los objetos 'Pin' persistidos
	var pins: [Pin] = []
	
	// los pins persistidos que se convierten en vistas de anotaciones del mapa
	var pinsArray: [PinOnMap] = [] // esta clase adopta el protocolo 'MKAnnotation'
	
	// un array de fotos descargadas desde flickr
	var photos: [FlickrImage] = [FlickrImage]()
	
	//*****************************************************************
	// MARK: - View Life Cycle
	//*****************************************************************
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		// pone el botón edit-done
		setEditDoneButton()
		
		// busca los objetos 'Pin' persistidos
		let fetchRequest: NSFetchRequest<Pin> = Pin.fetchRequest() 
		
		// comprueba los resultados de la solicitud de búsqueda
		if let result = try? dataController.viewContext.fetch(fetchRequest) {
			
			// asigna el resultado de la solicitud al array de pins
			pins = result
		}
		// itera el array pins
				for pin in pins {
					// los convierte en objetos que adoptan el protocolo 'MKAnnotation'
					let coordinate = CLLocationCoordinate2D(latitude: pin.latitude , longitude: pin.longitude )
					let pins = PinOnMap(coordinate: coordinate)
					// y los agrega en el array de objetos preparados para mostrarse en una vista de mapa
					pinsArray.append(pins)
				}
		
		// actualiza la vista de mapa agregando los pins persistidos
		mapView.addAnnotations(pinsArray)
		
		// test
		print("⚗️ Los pins persistidos actualmente son: \(pins.count)")
		
		print("Modo edición inicial: \(editMode)")

	}
	
	//*****************************************************************
	// MARK: - Edit-Done Button
	//*****************************************************************
	
	func setEditDoneButton() {
		self.navigationItem.rightBarButtonItem = self.editButtonItem
	}
	
	// establece si el controlador de vista muestra una vista editable
	override func setEditing(_ editing: Bool, animated: Bool) {
		
		super.setEditing(editing, animated: animated)
		
		deletePins.isHidden = !editing // si la vista 'tap pins to delete' está oculta el modo edición estará en false
		editMode = editing // si el modo edición es habilitado, poner ´editMode´ a ´true´
		
		// test
		print("El modo edición está en: \(editMode)")
		
}
	
	//*****************************************************************
	// MARK: - IBActions
	//*****************************************************************
	
	// cuando el usuario hace una tap sobre el mapa, se crea un pin y se ejecutan 3 tareas
	@IBAction func addPinToMap(_ sender: UITapGestureRecognizer) {
		
		// MapView ----------------------------------------------------
		/* 1- que aparezca efectivamente el pin sobre el sitio tapeado */

		// edit-mode: FALSE
		// se pueden agregar pines
		if !editMode {
			
			// las coordenadas del tapeo sobre el mapa
			let gestureTouchLocation: CGPoint = sender.location(in: mapView) 
			
			// convierte las coordenadas de un punto sobre la vista de un mapa (x, y) - CGPoint
			// en unas coordenadas de mapa (latitud y longitud) - CLLocationCoordinate2D
			var coordToAdd: CLLocationCoordinate2D = mapView.convert(gestureTouchLocation, toCoordinateFrom: mapView)
			
			// una determinada anotación (pin) sobre un punto del mapa
			let annotation: MKPointAnnotation = MKPointAnnotation()
			
			// ese pin ubicado en las coordenadas del mapa
			annotation.coordinate = coordToAdd // CLLocationCoordinate2D
			
			// agrega el pin correspondiente a esa coordenada en la vista del mapa
			mapView.addAnnotation(annotation) // MKPointAnnotation
			
			// CoreData ----------------------------------------------------
			/* 2- que se persista la ubicación de ese pin (latitud y longitud) en core data */
			
			addPinToCoreData(coord: coordToAdd)

			// Networking ----------------------------------------------------
			/* 3 - que se efectúe la solicitud web a Flickr para obtener las fotos asociadas a la ubicación (pin) */
			requestFlickrPhotosFromPin(coord: coordToAdd)
			
		} else  {
			
			// edit-mode: TRUE
			// NO se pueden agregar pines
			
		} // end if-else
	
	} // end func
	
	
	// CoreData ----------------------------------------------------
	/* 2- que se persista la ubicación de ese pin (latitud y longitud) en core data */
	
	/// persiste la coordenada tapeada
	func addPinToCoreData(coord: CLLocationCoordinate2D) {
		
		// crea un objeto gestionado 'pin'
		let pin  = Pin(latitude: coord.latitude, longitude: coord.longitude, context: dataController.viewContext)
		// intenta guardar los cambios que registra el contexto (en este caso, que se agregó un nuevo objeto ´Pin´)
		try? dataController.viewContext.save()
		
		// test
		print("✏️ SE AGREGA UN NUEVO PIN \(pin)")
		print("🔭 los pines totales son \(pins)")
		
	}
	
	// Networking ----------------------------------------------------
	/* 3 - que se efectúe la solicitud web a Flickr para obtener las fotos asociadas a la ubicación (pin) */
	
	/// solicita a flickr las fotos asociadas a esa coordenada
	func requestFlickrPhotosFromPin(coord: CLLocationCoordinate2D) {
		
		// network request
		FlickrClient.sharedInstance().getPhotosPath(lat: coord.latitude, lon: coord.longitude) { (photos, error) in

			// comprueba si la solicitud de datos fue exitosa
			if let photos = photos {

				// si se reciben fotos...
				// almacena en la propiedad 'photos' todas las fotos recibidas
				self.photos = photos

				//test
				print("⚗️ \(photos.count)")

				// baraja las fotos recibidas (y almacenadas) para reordenarlas aleatoriemente
				let photosRandom: [FlickrImage] = photos.shuffled()

				// sobre las fotos ordenadas aleatoriamente...
				// si recibe más de 21 fotos ejecutar lo siguiente, sino (else) esto otro
				if photosRandom.count > 21 {

					// del array ya ordenado aletoriamente llenar otro array con sólo 21 fotos
					let extractFirstTwentyOne = photosRandom[0..<21]

					// prepara un array de fotos para contener las primeras 21
					var firstTwentyOne: [FlickrImage] = []

					// convierte la porción extraída (21) en un objeto de tipo Array
					firstTwentyOne = Array(extractFirstTwentyOne)

					// asigna a la propiedad 'photos' las 21 fotos seleccionadas
					self.photos = firstTwentyOne
					print("primeras 21: \(firstTwentyOne.count)")
					print("total de fotos obtenidas: \(photos.count)")

				} else { // si recibe menos de 21 fotos

					// sino almacena las fotos recibidas (las menos de 21) en 'photos'
					self.photos = photos

				}

			} else {

				print(error ?? "empty error")

			} // end optional binding

		} // end closure
		
		print("las fotos recibidas de flickr son: \(photos.count)")

	}
	
} // end class

//*****************************************************************
// MARK: - Map View Methods
//*****************************************************************

extension TravelLocationsMapViewController:  MKMapViewDelegate {
	
	// el pin que ha sido seleccionado en el mapa
	func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) { 
		
		// la coordenada seleccionada
		let coordSelect = view.annotation?.coordinate
		let latitude = coordSelect?.latitude
		let longitude = coordSelect?.longitude
		
		// edit-mode: FALSE, navega hacia el próximo vc desde el pin tapeado
		if !editMode {
			
			// navega desde el pin tapeado siguiente vc
			performSegue(withIdentifier: "PinPhotos", sender: coordSelect)
			// deselecciona la anotación tapeada
			mapView.deselectAnnotation(view.annotation, animated: false)
			
			// TODO: asignar las fotos persistidas asociadas al pin seleccionado
			// al array de fotos (con intenciones de luego pasarlas al próximo vc)
			
		// edit-mode: TRUE, borra los pines tapeados, tanto de la vista como de core data
		} else {
			
			// itera el array de pines persistidos
			for pin in pins {
				
				// si las coordenadas del pin persistido coinciden con la coordenada seleccionada
				if pin.latitude == latitude && pin.longitude == longitude {
					
					// asigna el pin a borrar con el pin coincidente
					let pinToDelete = pin
					// informa al contexto que borre ese pin
					dataController.viewContext.delete(pinToDelete)
					// e intenta guardar el estado actual del contexto
					try? dataController.viewContext.save()

				}
			
			} // end for-in
			
			// borra del mapa el pin tapeado
			mapView.removeAnnotation(view.annotation!) 

			}
			
			// test
			print("un pin ha sido borrado")
		}
	}

//*****************************************************************
// MARK: - Navigation (Segue)
//*****************************************************************

extension TravelLocationsMapViewController {

// notifica al vc que se va a realizar una transición
override func prepare(for segue: UIStoryboardSegue,sender: Any?) {
	
	if segue.identifier == "PinPhotos" {
		
			// el destino de la transición, el 'PhotosAlbumViewController'
			let photoAlbumVC = segue.destination as! PhotoAlbumViewController
			// el remitente será una coordenada (pin) puesto sobre el mapa
			let coord = sender as! CLLocationCoordinate2D
		
			// pasando datos...
			// pasa la coordenada seleccionada
			photoAlbumVC.coordinateSelected = coord
			// pasa las fotos recibidas desde flickr
			photoAlbumVC.photos = photos
			// pasa el controlador de datos
			photoAlbumVC.dataController = dataController
		
		} // end if
	
	} // end func

} // end ext

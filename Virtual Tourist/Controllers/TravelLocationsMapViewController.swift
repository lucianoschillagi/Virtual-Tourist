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
	
	/// The `Pin` objects being presented
	var pins: [Pin] = [] // The `Pin` objects being presented
	
	/// la coordenada seleccionada
	//let selectCoord: CLLocationCoordinate2D = (CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0) // valor inicial)
	
	// edit mode
	var editMode: Bool = false
	
	// map view
	var pinsArray: [PinOnMap] = [] // esta clase adopta el protocolo 'MKAnnotation'
	
	// flickr
	var photos: [FlickrImage] = [FlickrImage]()
	
	
	//*****************************************************************
	// MARK: - View Life Cycle
	//*****************************************************************
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		// edit-done button
		setEditDoneButton()
		
		// Core Data -> Map View
		let fetchRequest: NSFetchRequest<Pin> = Pin.fetchRequest() // solictud de búsqueda del objeto ´Pin´
		fetchRequest.sortDescriptors = [] // descriptores de ordenamiento
		
		// comprueba el resultado de la solicitud de búsqueda del objeto ´Pin´ (los pins)
		if let result = try? dataController.viewContext.fetch(fetchRequest) {
			
			// le pasa el resultado al array de pins
			pins = result
		}
		// itera el array de objetos persistidos (pin)
		// y los agrega en el array de objetos preparados para mostrarse en una vista de mapa
				for pin in pins {
					let coordinate = CLLocationCoordinate2D(latitude: pin.latitude , longitude: pin.longitude as! CLLocationDegrees)
					let pins = PinOnMap(coordinate: coordinate)
					pinsArray.append(pins)
				}
		
		// last step: update the UI
		mapView.addAnnotations(pinsArray)
		
		// test
		print("⚗️ Los pins persistidos actualmente son: \(numberOfPins)")

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
		
}
	
	//*****************************************************************
	// MARK: - IBActions
	//*****************************************************************

	// cuando el usuario hace una tap largo sobre el mapa, se crea un pin...
	@IBAction func addPinToMap(_ sender: UITapGestureRecognizer) {

		/* 4 tareas */

		/* 1- que aparezca efectivamente el pin sobre el sitio tapeado */

		// si NO está en 'modo edición' se pueden agregar pines
		if !editMode {

		// las coordenadas del tapeo sobre el mapa
			let gestureTouchLocation: CGPoint = sender.location(in: mapView) // la ubicación del tapeo sobre una vista

			// convierte las coordenadas de un punto sobre la vista de un mapa (x, y)-  CGPoint
			// en unas coordenadas de mapa (latitud y longitud) - CLLocationCoordinate2D
			let coordToAdd: CLLocationCoordinate2D = mapView.convert(gestureTouchLocation, toCoordinateFrom: mapView)

			// una determinada anotación (pin) sobre un punto del mapa
			let annotation: MKPointAnnotation = MKPointAnnotation()

			// ese pin ubicado en las coordenadas del mapa
			annotation.coordinate = coordToAdd // CLLocationCoordinate2D

			// agrego el pin correspondiente a esa coordenada en la vista del mapa
			mapView.addAnnotation(annotation) // MKPointAnnotation

		// test
			print("🔒 un pin ha sido puesto")
			print("🙎🏾 : \(coordToAdd.latitude)")

			/* 2- que se persista la ubicación de ese pin (latitud y longitud) en core data */
			
			// crea un objeto pin 
			let pin  = Pin(latitude: coordToAdd.latitude, longitude: coordToAdd.longitude, context: dataController.viewContext)
			// intenta guardar los cambios que registra el contexto (en este caso, que se agregó un nuevo objeto ´Pin´)
			try? dataController.viewContext.save()
			
			// test
			print("✏️ se agrega un nuevo pin \(pin)")
			print("🔭 los pines totales son \(pins)")
			
			/* 3 - que se efectúe la solicitud web a Flickr para obtener las fotos asociadas a la ubicación (pin) */
			// network request
			FlickrClient.sharedInstance().getPhotosPath(lat: coordToAdd.latitude, lon: coordToAdd.longitude) { (photos, error) in // recibe los valores desde 'FlickrClient' y los procesa acá (photos ó error)
				
				// optional binding
					if let photos = photos {

					// si se reciben fotos...
					// almacena en la propiedad 'photos' todas las fotos recibidas
						self.photos = photos

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

									} else { // si recibe menos de 21 fotos

								// sino almacenar las fotos recibidas (las menos de 21) en 'photos'
								self.photos = photos

						}

								} else {

							print(error ?? "empty error")

						} // end optional binding

			} // end closure

		} else  {

			// ...caso contrario, NO

		} // end if-else

		print("🔌 Las fotos actuales son \(photos.count)")


	} // end func
	
	//*****************************************************************
	// MARK: - Helpers
	//*****************************************************************
	
	/// cuenta la cantidad de pins persistidos
	var numberOfPins: Int { return pins.count }
	
	
	// TODO: falta implementar este método
	func tieneCambiosElContexto() {
		
		dataController.viewContext.hasChanges
		
		// TODO: ver tip de buena práctica ´hasChanges´ [https://classroom.udacity.com/nanodegrees/nd003/parts/e97f6879-7f09-42cf-81a2-8ee1a1e9958e/modules/307104883375460/lessons/a1aca629-8165-4eb6-9b9a-ed4ccd3c906d/concepts/263eb36c-3ad2-446a-800f-e6324f1b4a6d]
		
		
	}
	
	//*****************************************************************
	// MARK: - Navigation (Segue)
	//*****************************************************************
	
	// notifica al controlador de vista que se va a realizar una transición
	override func prepare(for segue: UIStoryboardSegue,sender: Any?) {
		
		if segue.identifier == "PinPhotos" {
			// el destino de la transición, el 'PhotosViewController'
			let photoAlbumVC = segue.destination as! PhotoAlbumViewController
			// el remitente será una coordenada (pin) puesto sobre el mapa
			let coord = sender as! CLLocationCoordinate2D
		
			// MARK: pasando datos de este vc al siguiente...
			// le pasa la coordenada seleccionada
			photoAlbumVC.coordinateSelected = coord
			// le pasa las fotos recibidas desde flickr
			photoAlbumVC.photos = photos
			// le pasa el controlador de datos
			photoAlbumVC.dataController = dataController
			
		}
		
	}
		
} // end class

//*****************************************************************
// MARK: - Map View Methods
//*****************************************************************

extension TravelLocationsMapViewController:  MKMapViewDelegate {
	
	// el pin que ha sido seleccionado en el mapa
	func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) { // método del delegado
		
		let coordSelect = view.annotation?.coordinate
		let latitude = coordSelect?.latitude
		let longitude = coordSelect?.longitude
		print("📊\(coordSelect)")
		
		// si NO esté en modo edición...
		if !editMode {
			// inicia el segue
			performSegue(withIdentifier: "PinPhotos", sender: view.annotation?.coordinate)
			// esconde el callout view cuando es tapea sobre el pin
			mapView.deselectAnnotation(view.annotation, animated: false) // método de la clase
			
			// si está en modo edición...
		} else {
			
			for pin in pins {
				
				if pin.latitude == latitude && pin.longitude == longitude {
					
					let pinToDelete = pin
					dataController.viewContext.delete(pinToDelete)
					try? dataController.viewContext.save()

				}
			}
			
			// borra del mapa el pin tapeado
			mapView.removeAnnotation(view.annotation!) // método de la clase

			}
			
			// test
			print("un pin ha sido borrado")
		}
	}
	
	


// test

//	@IBAction func longPressPrueba(_ sender: Any) {
//
//		// las coordenadas del tapeo sobre el mapa
//		let gestureTouchLocation: CGPoint = (sender as AnyObject).location(in: mapView) // la ubicación del tapeo sobre una vista
//
//		print("🔏 toque largo sobre el mapa \(gestureTouchLocation)")
//
//
//	}

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

class TravelLocationsMapViewController: CoreDataViewController {
	
	//*****************************************************************
	// MARK: - IBOutles
	//*****************************************************************
	
	@IBOutlet weak var mapView: MKMapView!
	@IBOutlet weak var deletePins: UIView!
	@IBOutlet weak var editButton: UIBarButtonItem!
	
	//*****************************************************************
	// MARK: - Properties
	//*****************************************************************
	
	// core data stack
	let stack = CoreDataStack(modelName: "Model")!
	
	// edit mode
	var editMode: Bool = false
	
	// un array con los pins puestos actualmente sobre el mapa
	var currentPins: [Pin] = [] // LUEGO DESCOMENTAR
	
	
	var pins: PinOnMap?
	var pinsArray: [PinOnMap] = [] // MKAnnotation
	
	// las images (fotos) descargadas desde Flickr
	var photos: [FlickrImage] = [FlickrImage]()
	

	
	//*****************************************************************
	// MARK: - View Life Cycle
	//*****************************************************************
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		// edit-done button
		setEditDoneButton()
		
		/* Core Data */
		
		// obtiene la pila de core data
		let delegate = UIApplication.shared.delegate as! AppDelegate
		let stack = delegate.stack
		
		// solicita la búsqueda el objeto 'Pin'
		let frPin = NSFetchRequest<NSFetchRequestResult>(entityName: "Pin")
		// ordena los resultados
		frPin.sortDescriptors = []
	
		// el controlador de los resultados obtenidos
		fetchedResultsController = NSFetchedResultsController(fetchRequest: frPin,
																													managedObjectContext: stack.context,
																													sectionNameKeyPath: nil,
																													cacheName: nil)
		
		// crea un par de coordenadas y las pone dentro de la estructura 'CLLocationCoordinate2D'
		// luego pone esos dos objetos en un array de coordenadas
		
		// el modelo alternativo
		let coordenada1 = CLLocationCoordinate2D(latitude: -32.944243, longitude: -60.650539)// rosario
		let coordenada2 = CLLocationCoordinate2D(latitude: -34.603684, longitude: -58.381559)// buenos aires
		let coordenadasPersistidas: [CLLocationCoordinate2D] = [coordenada1, coordenada2]
		
		// este funciona!
		for coordenada in coordenadasPersistidas {

			let pin = PinOnMap(coordinate: coordenada) // convierte los datos en objeto de tipo 'MKAnnotation'
			pinsArray.append(pin)
		}
		
		mapView.addAnnotations(pinsArray)
		
		// este todavía NO
		
		//		for pin in currentPins {
		//
		//			let coordenada = CLLocationCoordinate2D(latitude: pin.latitude, longitude: pin.longitude)
		//			let pins = Pins(coordinate: coordenada)
		//			pinsArray.append(pins)
		//
		//		}
		

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
		

		// test, LUEGO BORRAR
		if editing {
		print("la pantalla está en modo edición")
		// cuando la vista de 'delete pins' aparece el marco de la supervista se eleva
		mapView.frame.origin.y = deletePins.frame.height * (-1)
		} else {
		print("la pantalla NO está en modo edición")
		mapView.frame.origin.y = 0

		}
}
	
	//*****************************************************************
	// MARK: - IBActions
	//*****************************************************************

	// cuando el usuario hace una tap largo sobre el mapa, se crea un pin...
	@IBAction func addPinToMap(_ sender: UILongPressGestureRecognizer) {
		
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
			print("un pin ha sido puesto")
			print("🙎🏾 : \(coordToAdd.latitude)")
			
			/* 2- que se persista la ubicación de ese pin (latitud y longitud) en core data */
			
			// CREA instancias del objeto gestionado 'Pin', cada vez que se el usuario agregar un pin
			// y le avisa al contexto que se ha producido un cambio en el Modelo
			let pin = Pin(latitude: coordToAdd.latitude, longitude: coordToAdd.longitude, context: fetchedResultsController!.managedObjectContext)
			
			// test
			print("📡 Estas son las instancias creadas del objeto gestionado 'Pin': \(pin)")
	
			// almacena los pins que va guardando en un array de objetos 'Pin' [Pin] llamado 'currentPins'
			currentPins.append(pin)
			print("🖥 Los pines actuales son \(currentPins). Cantidad: \(currentPins.count)")
			
			// guarda los cambios recientes en el contexto
			// en este caso los pines agregados
			savePins()
			
			/* 3 - que se efectúe la solicitud web a Flickr para obtener las fotos asociadas a la ubicación (pin) */
			
			// network request
			FlickrClient.sharedInstance().getPhotosPath(lat: coordToAdd.latitude,
																									lon: coordToAdd.longitude) { (photos, error) in // recibe los valores desde 'FlickrClient' y los procesa acá (photos ó error)
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
	// MARK: - Core Data
	//***************************************************************
	
	// guardar los pines puestos
	func savePins() {
		
		do {
				try stack.saveContext()
				print("🐽 guarda el contexto porque se puso un pin sobre el mapa")
			} catch {
				print("Error while saving.")
		}
	
	}

	// remover los pines tapeados
	func removePins() {
		
		print("un pin ha sido removido de core data!")

	}
	
	//*****************************************************************
	// MARK: - Navigation (Segue)
	//*****************************************************************
	
	// notifica al controlador de vista que se va a realizar una transición
	override func prepare(for segue: UIStoryboardSegue,sender: Any?) {
		
		if segue.identifier == "PinPhotos" {
			// el destino de la transición, el 'PhotosViewController'
			let destination = segue.destination as! PhotoAlbumViewController
			// el remitente será una coordenada (pin) puesto sobre el mapa
			let coord = sender as! CLLocationCoordinate2D
			
			// MARK: pasando datos de este vc al siguiente...
			// le pasa la coordenada seleccionada
			destination.coordinateSelected = coord
			// le pasa las fotos recibidas desde flickr
			destination.photos = photos
		}
		
	}
	
} // end vc

//*****************************************************************
// MARK: - Map View Methods
//*****************************************************************

extension TravelLocationsMapViewController:  MKMapViewDelegate {
	
	// el pin que ha sido seleccionado en el mapa
	func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) { // método del delegado
		
		// si NO esté en modo edición...
		if !editMode {
			// inicia el segue
			performSegue(withIdentifier: "PinPhotos", sender: view.annotation?.coordinate)
			// esconde el callout view cuando es tapea sobre el pin
			mapView.deselectAnnotation(view.annotation, animated: false) // método de la clase
			
			// si está en modo edición...
		} else {
			// borra del mapa el pin tapeado
			mapView.removeAnnotation(view.annotation!) // método de la clase
			// y borra el objeto del modelo de datos (core data)
			removePins() //
			// debug
			print("un pin ha sido borrado")
		}
	}
	
}



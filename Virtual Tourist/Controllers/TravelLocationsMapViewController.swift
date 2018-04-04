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
	var flickrPhotos: [FlickrImage] = [FlickrImage]()
	
	//*****************************************************************
	// MARK: - Superview Life Cycle
	//*****************************************************************
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		// Pone el botón edit-done
		setEditDoneButton()
		
		// cuando la supervista se cargó...
		// busca los objetos 'Pin' persistidos
		let fetchRequest: NSFetchRequest<Pin> = Pin.fetchRequest() 
		
		// comprueba los resultados de la solicitud de búsqueda
		if let result = try? dataController.viewContext.fetch(fetchRequest) {
			
			// asigna el resultado de la solicitud al array de pins
			pins = result
		}
		// itera el array pins
				for pin in pins {
					// y a las coordenadas de los pins persistidos..
					let coordinate = CLLocationCoordinate2D(latitude: pin.latitude , longitude: pin.longitude )
					// las convierte en objetos que adoptan el protocolo 'MKAnnotation'
					let pins = PinOnMap(coordinate: coordinate)
					// y los agrega al array de objetos preparados para mostrarse en una vista de mapa
					pinsArray.append(pins)
				}
		
		// por último, actualiza la vista de mapa agregando los pins persistidos.
		mapView.addAnnotations(pinsArray)

	}
	
	//*****************************************************************
	// MARK: - Edit-Done Button
	//*****************************************************************
	
	/// pone el botón edit-done en el navegador
	func setEditDoneButton() {
		self.navigationItem.rightBarButtonItem = self.editButtonItem
	}
	
	/// establece si el controlador de vista muestra una vista editable
	override func setEditing(_ editing: Bool, animated: Bool) {
		
		super.setEditing(editing, animated: animated)
		
		deletePins.isHidden = !editing // si la vista 'tap pins to delete' está oculta el modo edición estará en false
		editMode = editing // si el modo edición es habilitado, poner ´editMode´ a ´true´
		
}
	
	//*****************************************************************
	// MARK: - IBActions
	//*****************************************************************
	
	// Cuando el usuario tapea sobre el mapa, se crea un pin y se realizan 4 tareas:
	
	/* 1 - addPinToMap: aparece el pin sobre el sitio tapeado */
	/* 2 - addPinToCoreData: se persiste la ubicación de ese pin (latitud y longitud) */
	/* 3 - requestFlickrPhotosFromPin: se efectúa la solicitud web a Flickr para obtener las fotos asociadas a la ubicación (pin) */
	
	/* 1/3 Map View */
	@IBAction func addPinToMap(_ sender: UITapGestureRecognizer) {
		
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
			
			// agrega un pin en el mapa
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
	
	/* 2/3 Core Data */
	/// persiste la coordenada tapeada
	func addPinToCoreData(coord: CLLocationCoordinate2D) {
		
		// crea un objeto gestionado 'pin'
		let pin = Pin(latitude: coord.latitude, longitude: coord.longitude, context: dataController.viewContext)
		// agrega el pin (managed object) a un array que contiene todos los pins
		pins.append(pin)
		// intenta guardar los cambios que registra el contexto (en este caso, que se agregó un nuevo objeto ´Pin´)
		try? dataController.viewContext.save()
		
		// test
		print("🛡\(pins)")
		
	}

	/* 3/3 Flickr (networking) */
	/// solicita a flickr las fotos asociadas a esa coordenada
	func requestFlickrPhotosFromPin(coord: CLLocationCoordinate2D) {
		
		// solicitud web
		FlickrClient.sharedInstance().getPhotosPath(lat: coord.latitude, lon: coord.longitude) { (photos, error) in

			// comprueba si la solicitud de datos fue exitosa
			if let photos = photos {

				// si se reciben fotos...
				// almacena en la propiedad 'photos' todas las fotos recibidas (hay un límite para recibir no más de 21 fotos)
				self.flickrPhotos = photos

			} else {

				print(error ?? "empty error")

			} // end optional binding

		} // end closure

	} // end func
	
} // end class

//*****************************************************************
// MARK: - Map View Methods
//*****************************************************************

extension TravelLocationsMapViewController: MKMapViewDelegate {
	
	// el pin que ha sido seleccionado en el mapa
	func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) { 
		
		// la coordenada seleccionada
		let coordSelect = view.annotation?.coordinate
		let latitude = coordSelect?.latitude
		let longitude = coordSelect?.longitude
		
		// edit-mode: FALSE, navega hacia el próximo vc desde el pin tapeado
		if !editMode {
			
			// navega desde el pin tapeado al siguiente vc
			performSegue(withIdentifier: "PinPhotos", sender: coordSelect)
			// deselecciona la anotación tapeada
			mapView.deselectAnnotation(view.annotation, animated: false)
			
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
			photoAlbumVC.flickrPhotos = flickrPhotos
			// pasa el controlador de datos
			photoAlbumVC.dataController = dataController
		
		} // end if
	
	} // end func

} // end ext

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
	
	var editMode: Bool = false
	var currentPins: [Pin] = []  // los pins actuales!!!!!!!!!IMPLEMENTAR
	var coordinateSelected:CLLocationCoordinate2D?  // la coordenada (pin) seleccionada por el usuario
	
	// modelo en 'FlickrImage'
	var photos: [FlickrImage] = [FlickrImage]()
	
	//*****************************************************************
	// MARK: - View Life Cycle
	//*****************************************************************
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		// set edit-done button on navigation bar
		setEditDoneButton()
		
		/* Core Data */
		
		// get the stack
		let delegate = UIApplication.shared.delegate as! AppDelegate
		let stack = delegate.stack
		
		// create a fetch request
		let fr = NSFetchRequest<NSFetchRequestResult>(entityName: "Pin")
		fr.sortDescriptors = []
	
		// create the fetched results controller
		fetchedResultsController = NSFetchedResultsController(fetchRequest: fr,
																													managedObjectContext: stack.context,
																													sectionNameKeyPath: nil,
																													cacheName: nil)
		
	
		//TODO: cuando la supervista se carga voy a buscar los pins(las coordenadas persistidas) para presentarlas en forma de anotaciones (pins) sobre el mapa

		// test
		print("🌂 \(currentPins.count)")
		
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
		
		
		//TODO: cuando la vista de 'delete pins' aparece el marco de la supervista se eleva
		mapView.frame.origin.y = -60
		
		
		
		// test
		if editing {
		print("la pantalla está en modo edición")
		} else {
		print("la pantalla NO está en modo edición")
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
			// convierte las coordenadas en unas coordenadas de mapa (latitud y longitud)
			let coordToAdd: CLLocationCoordinate2D = mapView.convert(gestureTouchLocation, toCoordinateFrom: mapView)
			// un pin sobre el mapa
			let annotation: MKPointAnnotation = MKPointAnnotation()
			// ese pin ubicado en las coordenadas del mapa
			annotation.coordinate = coordToAdd // CLLocationCoordinate2D
			// agrego el pin correspondiente a esa coordenada en la vista del mapa
			mapView.addAnnotation(annotation) // MKPointAnnotation
			
		// test
			print("un pin ha sido puesto")
			print("🙎🏾 latitud: \(coordToAdd.latitude)")
			
			/* 2- que se persista la ubicación de ese pin (latitud y longitud) en core data */
			
			// TODO: Cuando los pines se dejan caer en el mapa, ¿persisten como instancias 'Pin' en Core Data?
			// add pin to core data

			// create a new pin in core data
	
//				let nb = Notebook(name: "New Notebook", context: fetchedResultsController!.managedObjectContext)
			
			// crea instancias del objeto gestionado 'Pin'
			// cada vez que se el usuario agregar un pin
			 let pin = Pin(latitude: coordToAdd.latitude, longitude: coordToAdd.longitude, context: fetchedResultsController!.managedObjectContext)
			
			// currentPins, prueba, no sé si queda
			currentPins.append(pin)
//
//			print("🎩 los pins actuales son: \(currentPins.count)")
//
//			for pin in currentPins {
//				print("👛 Los pins actuales son: \(pin)")
//			}
			

			// test
			print("🏃🏽‍♀️ Se ha creado un nuevo pin: \(pin).")

			
		} else  {
			
			// ...caso contrario, NO
			
		} // end if-else
		
		
		/* 3 - que se efectúe la solicitud web a Flickr para obtener las fotos asociadas a la ubicación (pin) */
		
		
		
		/* 4 - que se guarden los datos obtenidos (set de fotos) en core data */
		
		
		
		// test
		print("\(currentPins.count)")
		
	} // end func

	
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
			// pasa esta coordenada (este valor) a la propiedad 'coordinateSelected' de 'PhotosViewController'
			destination.coordinateSelected = coord
			
		}
		
		// debug
		print("transición hacia otra pantalla...")
		
	}
	
} // end vc


//*****************************************************************
// MARK: - Map View Methods
//*****************************************************************

extension TravelLocationsMapViewController:  MKMapViewDelegate {
	
	// el pin que ha sido seleccionado en el mapa
	func mapView(_ mapView: MKMapView,
							 didSelect view: MKAnnotationView) {
		
		// si NO esté en modo edición...
		if !editMode {
			// inicia el segue
			performSegue(withIdentifier: "PinPhotos", sender: view.annotation?.coordinate)
			// esconde el callout view cuando es tapea sobre el pin
			mapView.deselectAnnotation(view.annotation, animated: false)
			
			// si está en modo edición...
		} else {
			// borra del mapa el pin tapeado
			mapView.removeAnnotation(view.annotation!)
			// debug
			print("un pin ha sido borrado")
		}
	}
	
}



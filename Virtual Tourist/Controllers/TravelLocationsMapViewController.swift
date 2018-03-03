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
	// saved pins
	var currentPins: [Pin] = []  // los pins actuales!!!!!!!!!IMPLEMENTAR
	// coordenada seleccionada
	var coordinateSelected:CLLocationCoordinate2D?  // la coordenada (pin) seleccionada por el usuario
	
	// las images (fotos) descargadas desde Flickr
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
		
		mapView.addAnnotations(currentPins as! [MKAnnotation])
		
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
			
			// CREA instancias del objeto gestionado 'Pin', cada vez que se el usuario agregar un pin
			let pin = Pin(latitude: coordToAdd.latitude, longitude: coordToAdd.longitude, context: fetchedResultsController!.managedObjectContext)
			// y los GUARDA
			savePins()

			// y almacena los pins que va guardando en un array de objetos 'Pin' [Pin]
			currentPins.append(pin)
			
			// test
			print("🎩 los pins actuales son: \(currentPins.count)")
			for _ in currentPins {
				print("👛 Los pins actuales son: \(currentPins)")
			}
			
			
		} else  {
			
			// ...caso contrario, NO
			
		} // end if-else
		
		
		/* 3 - que se efectúe la solicitud web a Flickr para obtener las fotos asociadas a la ubicación (pin) */
		
		


		
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
		// TODO: 1- 'decirle' al contexto que elimine el objeto especificado
		
		
		
		
		
		
//		//Delete Core Data
//
//		func removeCoreData(of: MKAnnotation) {
//
//			let coord = of.coordinate
//			for pin in currentPins {
//
//				if pin.latitude == coord.latitude && pin.longitude == coord.longitude {
//
//					do {
//
//						getCoreDataStack().context.delete(pin)
//						try getCoreDataStack().saveContext()
//
//					} catch {
//
//						print("Remove Core Data Failed")
//					}
//					break
//				}
//			}
//		}
		
		
		
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
			// y borra el objeto del modelo de datos (core data)
			removePins() //
			// debug
			print("un pin ha sido borrado")
		}
	}
	
}



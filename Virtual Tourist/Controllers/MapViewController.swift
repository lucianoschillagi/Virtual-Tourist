//
//  MapViewController.swift
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
Un objeto que representa el mapa donde el usuario interactúa añadiendo ubicaciones a través de pins.
*/

class MapViewController: CoreDataMapAndCollectionViewController, UIGestureRecognizerDelegate, MKMapViewDelegate  {
	
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
	//var gestureBegin: Bool = false
//	var currentPins: [Pin] = [] // los pins actuales
	var coordinateSelected:CLLocationCoordinate2D! // la coordenada (pin) seleccionada por el usuario
	
	//*****************************************************************
	// MARK: - View Life Cycle
	//*****************************************************************
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		// set edit-done button on navigation bar
		setEditDoneButton()
		
		// Core Data
		
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
		// debug
		print("presionó el botón de Edit")
		print("El valor de 'editMode' es \(editMode)")
	}
	
	//*****************************************************************
	// MARK: - Gesture Recognizer
	//*****************************************************************
	
//	func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
//
//		gestureBegin = true
//		return true
//	}
	
	//*****************************************************************
	// MARK: - IBActions
	//*****************************************************************

	// cuando el usuario hace una tap largo sobre el mapa, se crea un pin
	@IBAction func addPin(_ sender: UILongPressGestureRecognizer) {
		
		if !editMode {
			sender.isEnabled = true
		//debug
		print("El modo edición está en \(editMode). [addPin]")
			
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
		// debug
		print("Agrega un Pin")
		
		} else  {
			
			print("El modo edición está en \(editMode). [addPin]")
			sender.isEnabled =  false
		}
	}
	
	//*****************************************************************
	// MARK: - MapView
	//*****************************************************************
	
	// el pin que ha sido seleccionado en el mapa
	func mapView(_ mapView: MKMapView,
							 didSelect view: MKAnnotationView) {
		
		// Edit-Mode conditional
		if !editMode { // si 'editMode' es 'false' (si NO esté en modo edición)
			
			// inicia el segue
			performSegue(withIdentifier: "PinPhotos", sender: view.annotation?.coordinate)
			// esconde el callout view cuando es tapea sobre el pin
			mapView.deselectAnnotation(view.annotation, animated: false)
		
		} else { // si está en modo edición...
			print("El modo edición está en \(editMode). Puedo borrar pero no agregar pines")
			// borra del mapa el pin tapeado
			mapView.removeAnnotation(view.annotation!)
			print("Borra el pin tapeado")
	
		}
	}
	
	//*****************************************************************
	// MARK: - Navigation (Segue)
	//*****************************************************************
	
	// notifica al controlador de vista que se va a realizar una transición
	override func prepare(for segue: UIStoryboardSegue,sender: Any?) {
		
		if segue.identifier == "PinPhotos" {
			// el destino de la transición, el 'PhotosViewController'
			let destination = segue.destination as! PhotosViewController
			// el remitente será una coordenada (pin) puesto sobre el mapa
			let coord = sender as! CLLocationCoordinate2D
			// pasa esta coordenada (este valor) a la propiedad 'coordinateSelected' de 'PhotosViewController'
			destination.coordinateSelected = coord
		}
		
//				if segue.identifier == "PinPhotos" {
//
//
//
//
//				}
		
		
	}
	
//	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//
//		if segue.identifier == "PinPhotos" {
//
//			let destination = segue.destination as! PhotosViewController
//			let coord = sender as! CLLocationCoordinate2D
//			destination.coordinateSelected = coord
//
//			for pin in currentPins {
//
//				if pin.latitude == coord.latitude && pin.longitude == coord.longitude {
//
//					destination.coreDataPin = pin
//					break
//				}
//			}
//
//		}
//	}
	
}  // end VC


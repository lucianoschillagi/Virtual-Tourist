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
//	var gestureBegin: Bool = false
//	var currentPins: [Pin] = [] // los pins actuales
//	var coordinateSelected:CLLocationCoordinate2D!
	
	// MARK: - View Life Cycle
	override func viewDidLoad() {
		super.viewDidLoad()
		setEditDoneButton()
		//autolayoutMapView()
		
	}
	
	func setEditDoneButton() {
		self.navigationItem.rightBarButtonItem = self.editButtonItem
	}
	
	//Gesture Recognizer
	
//	func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
//
//		gestureBegin = true
//		print("reconoce el gesto")
//		return true
//	}
	
	// Edit Mode View
	
	override func setEditing(_ editing: Bool, animated: Bool) {
		
		super.setEditing(editing, animated: animated)
		
		deletePins.isHidden = !editing
		editMode = editing
		
		if editing {
			print("está en modo de edición")
		} else {
			print("NO está en modo de edición")
		}
	}
	
	//*****************************************************************
	// MARK: - IBActions
	//*****************************************************************

	// cuando el usuario hace una tap largo sobre el mapa, se crea un pin
	@IBAction func addPin(_ sender: UILongPressGestureRecognizer) {
		
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
		// guardo el pin
		//addCoreData(of: annotation)
		// pone 'gestureBegin' nuevamente a 'false'
//		gestureBegin = false
		print("Add Pin")
//		print(gestureBegin)
	}
	
	//Map View Function
	
	func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
		
		if !editMode { // si NO está en modo edición...
			print("NO estoy en modo edición y he sido seleccionado")
			//performSegue(withIdentifier: "PinPhotos", sender: view.annotation?.coordinate)
			
			mapView.deselectAnnotation(view.annotation, animated: false)
//			//mapView.removeAnnotation(view.annotation!)
//			print("pero no deselecciona el pin") // es true
		
		} else { // si está en modo edición...
			
			//removeCoreData(of: view.annotation!)
			
			mapView.removeAnnotation(view.annotation!)
			print("Estoy en modo edición y he sido seleccionado")
			print("Y el pin se remueve con un tap!") // es true
		}
	}
	
	
	// MARK: - Navigation
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		
		
	}
	
}  // end VC


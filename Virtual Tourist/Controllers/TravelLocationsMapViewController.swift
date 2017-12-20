//
//  TravelLocationsMapViewController..swift
//  Virtual Tourist
//
//  Created by Luciano Schillagi on 12/5/17.
//  Copyright © 2017 luko. All rights reserved.
//

import UIKit // interfaz de usuario
import MapKit // mapa
import CoreData // persistencia

/* Controller */

class TravelLocationsMapViewController: UIViewController  {
	
	// MARK: Properties
	var editMode: Bool = false // por defecto la vista del mapa NO está en modo edición
	
	// Outlets
	@IBOutlet weak var deletePinsMessage: UILabel!
	@IBOutlet weak var mapView: MKMapView! // un objeto que representa el mapa
	
	
	// ..representa la vista que aparece cuando el usuario presiona el botón 'Edit'
	
	// MARK: Life Cycle
	override func viewDidLoad() {
		super.viewDidLoad()
		// le asigno al botón de la barra de navegación la propiedad 'editButtonItem'
		// esta propiedad lo que hace es devolver un botón de barra de navegación que alterna entre 'Edit' y 'Done'
		// esta propiedad invoca por defecto al método 'setEditing(_ editing: Bool, animated: Bool)'
		// y le pasa al primer parámetro de este método ´true´ si está en modo de edición y sino ´false´
		self.navigationItem.rightBarButtonItem = editButtonItem
		deletePinsMessage.isHidden = true
	}
	
	// MARK: Actions
	
	// TODO: VER ESTO-----------------
	func resignIfFirstResponder(_ mapView: MKMapView) {
		if mapView.isFirstResponder {
			mapView.resignFirstResponder()
		}
	}
	
	@IBAction func userDidTapView(_ sender: AnyObject) {
		resignIfFirstResponder(mapView)

	}
	// HASTA ACÁ--------------------------
	
	/**
	Reconoce el tap largo del usuario sobre un punto del mapa, y sobre ese punto añade un PIN.
	
	- parameter sender: el tap largo del usuario sobre el mapa .
	*/
	@IBAction func tapPin(_ sender: UILongPressGestureRecognizer) {
		
		// las coordenadas del tapeo sobre el mapa
		let gestureTouchLocation = sender.location(in: mapView)
		// convierto las coordenadas en una coordenada de mapa
		let coordToAdd = mapView.convert(gestureTouchLocation, toCoordinateFrom: mapView)
		// un pin sobre el mapa
		let annotation = MKPointAnnotation()
		// ese pin ubicado en las coordenadas del mapa
		annotation.coordinate = coordToAdd
		// agrego el pin correspondiente a esa coordenada en la vista del mapa
		mapView.addAnnotation(annotation)
		// guardo el pin
		//addCoreData(of: annotation)
		
		// debug
		print(coordToAdd)
		
		//displayImageFromFlickrBySearch
	}

	// Edit-Done Button
	/**
	Al tapear sobre el botón 'edit-done' aparece la vista-mensaje 'Tap Pins To Delete' y el vc entra en modo edición. Se podrán entonces borrar los pins que estén colocados sobre el mapa pero no se podrán agregar nuevos.
	
	- parameter editing: si es true el vc entrará en modo de edición.
	- parameter animated: si es true se animará la transición.
	*/
	override func setEditing(_ editing: Bool, animated: Bool) {
		// el argumento del 1er parámetro de este método es pasado por la propiedad ´editButtonItem´
		// cuando el usuario presione el botón el valor del parámetro ´editing´ será true, por defecto es false
		super.setEditing(editing, animated: animated)
		// la vista con el mensaje 'Tap Pins To Delete' aparece en pantalla
		deletePinsMessage.isHidden = !editing // editing = true (porque por defecto es false)
		// la variable 'editMode', que representa si el vc está en modo de edición pasa a ´true´, estaba al inicio en ´false´
		editMode = editing; print("está en modo edición? \(editing)") // editing = true
		// TODO: el marco se levante
		
	}
	
}  // end VC

// MARK: Extensions
extension TravelLocationsMapViewController: MKMapViewDelegate {
	/**
	TODO:
	
	- parameter sender: el tap del usuario sobre el mapa .
	*/
	// Delegate Methods (Map View)
	func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
		// si NO está en modo edición
		if !editMode {
			performSegue(withIdentifier: "PinPhotos", sender: view.annotation?.coordinate)
			mapView.deselectAnnotation(view.annotation, animated: false)
			// si está en modo edición
		} else {
			print("esta en modo edición")
			//removeCoreData(of: view.annotation!)
			mapView.removeAnnotation(view.annotation!)
		}
	}
	
} // end VC


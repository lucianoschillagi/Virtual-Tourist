//
//  MapViewController.swift
//  Virtual Tourist
//
//  Created by Luciano Schillagi on 1/17/18.
//  Copyright © 2018 luko. All rights reserved.
//

/* Controller */

import UIKit // interfaz de usuario
import MapKit // mapa
import CoreData // persistencia

/* Abstract:
Un objeto que representa el mapa donde el usuario interactúa añadiendo ubicaciones a través de pins.
*/

class MapViewController: CoreDataMapAndCollectionViewController  {
	
	// MARK: - Outlets
	@IBOutlet weak var mapView: MKMapView! // un objeto que representa el mapa
	
	// MARK: - Properties
	var currentPins: [Pin] = [] // los pins actuales
	var coordinateSelected:CLLocationCoordinate2D!
	
	// MARK: - View Life Cycle
	override func viewDidLoad() {
		super.viewDidLoad()
		
		
		
	} // end view did load
	
	// MARK: - Core Data



	// MARK: - Actions - Add Annotations to Map
	
	/**
	Reconoce el tap largo del usuario sobre un punto del mapa, y sobre ese punto añade un PIN.
	
	- parameter sender: el tap largo del usuario sobre el mapa .
	*/
	@IBAction func tapPin(_ sender: UILongPressGestureRecognizer) {
		
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

	}
	
	// MARK: - Map View
	func addAnnotationToMap(fromCoord: CLLocationCoordinate2D) {
		
		let annotation = MKPointAnnotation()
		annotation.coordinate = fromCoord
		mapView.addAnnotation(annotation)
	}
	
	// segue
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		
		if segue.identifier == "PinPhotos" {
			
			let destination = segue.destination as! PhotosViewController
			let coord = sender as! CLLocationCoordinate2D
			destination.coordinateSelected = coord
			
			for pin in currentPins {
				if pin.latitude == coord.latitude && pin.longitude == coord.longitude {
					destination.coreDataPin =  pin
					break
				}
			}
		}
	}
	
}  // end VC

// MARK: - Extensions
extension MapViewController {
	/**
	Le dice al delegado que una de sus pins (vistas de anotación) ha sido seleccionado.
	- parameter mapView: la vista del mapa.
	- parameter view: el pin.
	*/
	func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
			// pasa el id del segue y el objeto que ha sido seleccionado
			performSegue(withIdentifier: "PinPhotos", sender: view.annotation?.coordinate) // la vista del pin y sus coordenadas
			// deselecciona un pin específico y su callout view
			mapView.deselectAnnotation(view.annotation, animated: false)
	}
	
} // end extension


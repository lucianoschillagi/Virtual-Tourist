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

class TravelLocationsMapViewController: UIViewController  {
	
	// MARK: - Outlets
	@IBOutlet weak var mapView: MKMapView! // un objeto que representa el mapa
	
	// MARK: - Properties
	var currentPins: [Pin] = [] // los pins actuales
	var coordinateSelected:CLLocationCoordinate2D!
	
	// MARK: - View Life Cycle
	override func viewDidLoad() {
		super.viewDidLoad()
		
		let savedPins = preloadSavedPins() // trae los pins guardados cuando la supervista se carga
		
	// if
		if savedPins != nil {
			currentPins = savedPins! // si hay pins persistidos, se los asigno a los 'pins actuales' !!!!!!!!!!!
		
		// add annotation to map
		// for - in
		for pin in currentPins {
			let coord = CLLocationCoordinate2D(latitude: pin.latitude, longitude:pin.longitude)
			addAnnotationToMap(fromCoord: coord)
			
			} // end for - in
		
		} // end if
		
	} // end view did load
	
	// MARK: - Core Data
	func getCoreDataStack() -> CoreDataStack {
		
		let delegate = UIApplication.shared.delegate as! AppDelegate
		return delegate.stack
	}
	
	// obtener resultados
	func getFetchedResultsController() -> NSFetchedResultsController<NSFetchRequestResult> {
		
		let stack = getCoreDataStack()
		
		let frPin = NSFetchRequest<NSFetchRequestResult>(entityName: "Pin")
		frPin.sortDescriptors = []
		
		return NSFetchedResultsController(fetchRequest: frPin, managedObjectContext: stack.context, sectionNameKeyPath: nil, cacheName: nil)
	}
	
	// cargar pins guardados
	func preloadSavedPins() -> [Pin]? {
		// do-try-catch
		do {
			var pinArray: [Pin] = []
			let fetchedResultsController = getFetchedResultsController()
			try fetchedResultsController.performFetch()
			let pinCount = try fetchedResultsController.managedObjectContext.count(for: fetchedResultsController.fetchRequest)
			// for-in
			for index in 0..<pinCount {
				pinArray.append(fetchedResultsController.object(at: IndexPath(row: index, section: 0)) as! Pin)
			}
			return pinArray
		
		} catch {
			
			return nil
		}
	}
	
	// add core data
	func addCoreData(of:MKAnnotation) {
		// do - try - catch
		do {
			let coord = of.coordinate
			let pin = Pin(latitude: coord.latitude, longitude: coord.longitude, context: getCoreDataStack().context)
			
			try getCoreDataStack().saveContext()
			currentPins.append(pin)
		
		} catch {
			print("Add Core Data Failed")
		}
	}
	
	// remove core data
	func removeCoreData(of:MKAnnotation) {
		
		let coord = of.coordinate
		
		for pin in currentPins {
			
			if pin.latitude == coord.latitude && pin.longitude == coord.longitude {
				
				do {
					
					getCoreDataStack().context.delete(pin)
					try getCoreDataStack().saveContext()
					
				} catch {
					
					print("Remove Core Data Failed")
					
				} // end do - try - catch
				break
			} // end if
		} // end for - in
	} // en method

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
		addCoreData(of: annotation)

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
			
			let destination = segue.destination as! PhotoAlbumViewController
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
extension TravelLocationsMapViewController: MKMapViewDelegate {
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


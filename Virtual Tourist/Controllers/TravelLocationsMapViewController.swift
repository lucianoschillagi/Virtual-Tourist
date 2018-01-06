
import UIKit // interfaz de usuario
import MapKit // mapa
import CoreData // persistencia

/* Controller */

class TravelLocationsMapViewController: UIViewController  {
	
	// MARK: - Properties
	
	// Outlets
	@IBOutlet weak var mapView: MKMapView! // un objeto que representa el mapa
	
	// MARK: Life Cycle
	override func viewDidLoad() {
		super.viewDidLoad()
	}
	
	// MARK: - Actions
	
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
		print(coordToAdd.latitude)
		print(coordToAdd.longitude)
		//displayImageFromFlickrBySearch
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
		
			performSegue(withIdentifier: "PinPhotos", sender: view.annotation?.coordinate)
			mapView.deselectAnnotation(view.annotation, animated: false)
			// si está en modo edición
		
	}
	
} // end VC


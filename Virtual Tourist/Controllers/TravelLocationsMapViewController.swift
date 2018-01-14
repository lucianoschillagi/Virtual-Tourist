
import UIKit // interfaz de usuario
import MapKit // mapa
import CoreData // persistencia

/* Controller */

class TravelLocationsMapViewController: UIViewController  {
	
	// MARK: - Properties
	 var coordinateSelected:CLLocationCoordinate2D! // (debora)
	
	// MARK: - Outlets
	@IBOutlet weak var mapView: MKMapView! // un objeto que representa el mapa
	
	// MARK: - View Life Cycle
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
	
} // end VC


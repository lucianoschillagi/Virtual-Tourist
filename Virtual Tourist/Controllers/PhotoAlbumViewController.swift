
/* Controller */

import UIKit // interfaz de usuario
import MapKit // mapa
import CoreData // persistir datos

/* Abstract:
Un objeto que contiene:
-un fragmento de mapa con un zoom a la ubicación seleccionada
-una colección de vistas con imágenes relacionadas con esa ubicación
-un botón para actualizar la colección de imágenes
*/

class PhotoAlbumViewController: UIViewController {
	
	// MARK: - Outlets
	@IBOutlet weak var mapFragment: MKMapView!
	@IBOutlet weak var collectionView: UICollectionView!
	@IBOutlet weak var newCollectionButton: UIButton!

	// MARK: - Stored Properties
	// la coordenada seleccionada
	var coordinateSelected: CLLocationCoordinate2D!
	// las imágenes guardadas (core data)
	var savedImages:[Photo] = []
	
	var flickrImage: [FlickrImage] = [FlickrImage]()
	let regionRadius: CLLocationDistance = 1000
	
	var selectedToDelete:[Int] = [] {
		didSet {
			if selectedToDelete.count > 0 {
				newCollectionButton.setTitle("Remove Selected Pictures", for: .normal)
			} else {
				newCollectionButton.setTitle("New Collection", for: .normal)
			}
		}
	} // end computed property
	
	
	
	
	
	// MARK: - Model
	var collectionData = ["1 🤡", "2 👄", "3 👴🏽", "4 👩🏼‍🚀", "5 🐊", "6 🦏", "7 🐆", "8 🐿"
		, "9 🐸", "10 🐛", "11 🎹", "12 🏄🏼‍♀️"] // end model
	
	// MARK: - Core Data
	func getCoreDataStack() -> CoreDataStack {
		
		let delegate = UIApplication.shared.delegate as! AppDelegate
		return delegate.stack
	}
	
	// MARK: - View Life Cycle
	override func viewDidLoad() {
		super.viewDidLoad()
		
		// el diseño de la colección de vista, en 3 columnas separadas por 20pts
		let width = (view.frame.size.width - 20) / 3
		let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
		// el tamaño de cada item
		layout.itemSize = CGSize(width: width, height: width)
	
		// map view
		// set initial location in Honolulu
		let initialLocation = CLLocation(latitude: 21.282778, longitude: -157.829444)
		centerMapOnLocation(location: initialLocation)
	}
	
	override func viewWillAppear(_ animated: Bool) {
		//TODO: llamar al método
		// networking
		FlickrClient.sharedInstance().getPhotosFromFlickr(lat: 21.282778, lon:-157.829444) { (success, errorString) in
			performUIUpdatesOnMain {
				if success {
					//self.completeLogin()
				} else {
					print(errorString ?? "")
				}
			}
		}
	}
	
	// MARK: - Map, Helper Method
	func centerMapOnLocation(location: CLLocation) {
		let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,regionRadius, regionRadius)
		mapFragment.setRegion(coordinateRegion, animated: true)
	}
	
} // end VC



extension PhotoAlbumViewController: UICollectionViewDataSource, UICollectionViewDelegate {
	// MARK: - Collection View Methods
	/**
	Pregunta al 'data source object' por el número de items en una sección específica.
	
	- parameter collectionView: la collection view que solicita esta información.
	- parameter section: Un número de índice que identifica una sección en collectionView. Este valor de índice está basado en 0.
	
	- returns: El número de filas en la sección.
	*/
	// UICollectionViewDataSource
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return collectionData.count
	}
	
	/**
	Pide el objeto de fuente de datos para la celda que corresponde al elemento especificado en la vista de colección.
	
	- parameter collectionView: la vista de colección que solicita esta información.
	- parameter indexPath: La ruta de índice que especifica la ubicación del elemento
	
	- returns: El número de filas en la sección.
	*/
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath)
		if let label = cell.viewWithTag(100) as? UILabel {
			label.text = collectionData[indexPath.row]

		}
		return cell
	}
	
	
	func selectedToDeleteFromIndexPath(_ indexPathArray: [IndexPath]) -> [Int] {
		
		var selected: [Int] = []
		
		for indexPath in indexPathArray {
			selected.append(indexPath.row)
		}
		print(selected)
		return selected
	}
	
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		
		selectedToDelete = selectedToDeleteFromIndexPath(collectionView.indexPathsForSelectedItems!)
		let cell = collectionView.cellForItem(at: indexPath)
		
		DispatchQueue.main.async {
			//cell?.contentView.alpha = 0.3
			cell?.contentView.backgroundColor = UIColor.cyan
		}
	}
	
	
	
	
	
	
	
} // end extension
	
	


//
//  PhotosViewController.swift
//  Virtual Tourist
//
//  Created by Luciano Schillagi on 1/17/18.
//  Copyright © 2018 luko. All rights reserved.
//

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

	// MARK: - Properties
	var coordinateSelected: CLLocationCoordinate2D! // la coordenada seleccionada
	
	var stack: CoreDataStack!
	
	var savedImages:[Photo] = [] // las imágenes guardadas (core data)
	var coreDataPin: Pin! = nil
	let totalCellCount = 25
	
	//var flickrImage: [FlickrImage] = [FlickrImage]()
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
		//frPin.predicate = NSPredicate(format: "pin = %@", argumentArray: [coreDataPin!])
		
		return NSFetchedResultsController(fetchRequest: frPin, managedObjectContext: stack.context, sectionNameKeyPath: nil, cacheName: nil)
	}
	
	// cargar fotos guardadas
	func preloadSavedPhoto() -> [Photo]? {
		// do-try-catch
		do {
			var photoArray: [Photo] = []
			let fetchedResultsController = getFetchedResultsController()
			try fetchedResultsController.performFetch()
			let photoCount = try fetchedResultsController.managedObjectContext.count(for: fetchedResultsController.fetchRequest)
			// for-in
			for index in 0..<photoCount {
				photoArray.append(fetchedResultsController.object(at: IndexPath(row: index, section: 0)) as! Photo)
			}
			return photoArray.sorted(by: {$0.index < $1.index})
		} catch {
			return nil
		}
	}
	
	// delete photo
	func deleteExistingCoreDataPhoto() {
		
		for image in savedImages {
			getCoreDataStack().context.delete(image)
		}
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
		// set initial location in Honolulu, LUEGO BORRAR
		let initialLocation = CLLocation(latitude: 21.282778, longitude: -157.829444)
		centerMapOnLocation(location: initialLocation)
		
		collectionView.isHidden = false
		
		collectionView.allowsMultipleSelection = true
	
		addAnnotationToMap()
		
		// obtener fotos
		let savedPhoto = preloadSavedPhoto()
		
		if savedPhoto != nil && savedPhoto?.count != 0 {
			savedImages =  savedPhoto!
			showSavedResult()
		} else {
			showNewResult()
		}
	} // end view did load
	
	// saved result
	func showSavedResult() {
		DispatchQueue.main.async {
			self.collectionView.reloadData()
		}
	}
	
	// show result
	func showNewResult() {
		
		newCollectionButton.isEnabled = false
		
		deleteExistingCoreDataPhoto()
		savedImages.removeAll()
		collectionView.reloadData()
		
		getFlickrImagesRandomResult{( flickrImages) in
			
			if flickrImages != nil {
				
				DispatchQueue.main.async {
					
					//self.addCoreData(flickrImages: flickrImages!, coreDataPin: self.coreDataPin)
					self.savedImages = self.preloadSavedPhoto()!
					self.showSavedResult()
					self.newCollectionButton.isEnabled = true
				}
			}
		}
	}
	
	// add core data
	func addCoreData(flickrImages: [FlickrImage], coreDataPin: Pin) {
		
		for image in flickrImages {
			
			do {
				
				let delegate = UIApplication.shared.delegate as! AppDelegate
				let stack = delegate.stack
				let photo = Photo(index: flickrImages.index {$0 === image}!, imageURL: image.imageURLString(), imageData: nil, context: stack.context)
				photo.pin = coreDataPin
				try stack.save()
			
			} catch {
				
				print("Add Core Data Failed")
			}
		}
	}
	
	
	// networking
	func getFlickrImagesRandomResult(completion: @escaping (_ result: [FlickrImage]?) -> Void) {
		
		var result: [FlickrImage] = []
		
		FlickrClient.sharedInstance().getPhotosFromFlickr(lat: coordinateSelected.latitude, lon: coordinateSelected.longitude) { ( success, flickrImages) in
			
			if success {
				
				if flickrImages!.count > self.totalCellCount {
					
					var randomArray: [Int] = []
						
					while randomArray.count > self.totalCellCount {
						
						let random = arc4random_uniform(UInt32(flickrImages!.count))
						
						if !randomArray.contains(Int(random)) { randomArray.append(Int(random)) }
		
					}
					
					for random in randomArray {
						
						result.append(flickrImages![random])
					
					}
					completion(result)
				
				} else {
					completion(flickrImages!)
					
				}
				
				} else {
					completion(nil)
			}
		}
	}

	
	override func viewWillAppear(_ animated: Bool) {
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
	
	// MARK: - Map View
	func centerMapOnLocation(location: CLLocation) {
		let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,regionRadius, regionRadius)
		mapFragment.setRegion(coordinateRegion, animated: true)
	}
	
	func addAnnotationToMap() {
		
		let annotation = MKPointAnnotation()
		annotation.coordinate = coordinateSelected
		mapFragment.addAnnotation(annotation)
		mapFragment.showAnnotations([annotation], animated: true)
	}
	
	func selectedToDeleteFromIndexPath(_ indexPathArray: [IndexPath]) -> [Int] {
		
		var selected: [Int] = []
		
		for indexPath in indexPathArray {
			selected.append(indexPath.row)
		}
		print(selected)
		return selected
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
	// Collection View Functions
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return savedImages.count
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "photoCell", for: indexPath) as! CollectionViewCell
		cell.activityIndicator.startAnimating()
		cell.initWithPhoto(savedImages[indexPath.row])
		return cell
	}
	
	/**
	Pide el objeto de fuente de datos para la celda que corresponde al elemento especificado en la vista de colección.
	
	- parameter collectionView: la vista de colección que solicita esta información.
	- parameter indexPath: La ruta de índice que especifica la ubicación del elemento
	
	- returns: El número de filas en la sección.
	*/
	func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
		
		selectedToDelete = selectedToDeleteFromIndexPath(collectionView.indexPathsForSelectedItems!)
		let cell = collectionView.cellForItem(at: indexPath)
		
		DispatchQueue.main.async {
			cell?.contentView.alpha = 0.5
		}
	}
	
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		
		selectedToDelete = selectedToDeleteFromIndexPath(collectionView.indexPathsForSelectedItems!)
		let cell = collectionView.cellForItem(at: indexPath)
		
		DispatchQueue.main.async {
			cell?.contentView.alpha = 0.3
			cell?.contentView.backgroundColor = UIColor.cyan
		}
	}
	
} // end extension
	
	


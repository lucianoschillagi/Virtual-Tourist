////
////  CoreDataPhotosVC.swift
////  Virtual Tourist
////
////  Created by Luciano Schillagi on 2/14/18.
////  Copyright © 2018 luko. All rights reserved.
////
//
///* Controller */
//
//import UIKit
//import MapKit
//import CoreData
//
////*****************************************************************
//// MARK: - Methods (about Core Data)
////*****************************************************************
//
//extension PhotosViewController {
//
//	/* 1 */
//	// obtiene el modelo
//	func getCoreDataStack() -> CoreDataStack {
//
//		let delegate = UIApplication.shared.delegate as! AppDelegate
//
//		return delegate.stack
//	}
//
//	/* 2 */
//	// obtiene los resultados de la solicitud y se los pasa al controlador
//	func getFetchedResultsController() -> NSFetchedResultsController<NSFetchRequestResult> {
//
//		let stack = getCoreDataStack() // trae el Modelo
//
//		let fr = NSFetchRequest<NSFetchRequestResult>(entityName: "Photo")
//		fr.sortDescriptors = []
////		fr.predicate = NSPredicate(format: "pin = %@", argumentArray: [coreDataPin!]) // TODO: estudiar esta línea!
//
//		return NSFetchedResultsController(fetchRequest: fr,
//																			managedObjectContext: stack.context,
//																			sectionNameKeyPath: nil,
//																			cacheName: nil)
//	}
//
//
//	/* 3 */
//	// precarga las fotos guardadas...ESTUDIAR BIEN ESTA FUNCIón
//	func preloadSavedPhoto() -> [Photo]? {
//
//		do {
//			// crea un un array, por ahora vacío, del objeto 'Photo'
//			var photoArray: [Photo] = []
//
//			let  fetchedResultsController = getFetchedResultsController()
//
//			try fetchedResultsController.performFetch()
//
//			let photoCount = try fetchedResultsController.managedObjectContext.count(for: fetchedResultsController.fetchRequest)
//
//			for index in 0..<photoCount {
//
//				photoArray.append(fetchedResultsController.object(at: IndexPath(row: index, section: 0)) as! Photo)
//
//			}
//
//			return photoArray.sorted(by: {$0.index < $1.index})
//
//		} catch {
//
//			return nil
//
//		}
//	}
//
//	/* 4 */
//	// muestra los resultados persistidos
//	func showSavedResult() {
//
//		DispatchQueue.main.async {
//
//			self.collectionView.reloadData()
//		}
//	}
//
//
//	/* 5 */
//	// muestra las fotos de una nueva solicitud (nuevo resultado)
//	func showNewResult() {
//
//		// inhabilita el 'newCollectionButton'
//		newCollectionButton.isEnabled = false
//
//		// remueve las fotos persitidas en core data
//		removeExisitingCoreDataPhotos()
//		savedPhotos.removeAll()
//
//		// carga nuevamente todos los datos de la collectionView
//		collectionView.reloadData()
//
//		getFlickrPhotosRandomResult { (flickrImages) in
//
//			if flickrImages != nil {
//
//				// dispatch
//				DispatchQueue.main.async {
//
//
//
//				}
//			}
//
//
//
//		}
//
//	}
//
//	/* 6 */
//	// borra la fotos persistidas en core data
//	func removeExisitingCoreDataPhotos() {
//
//		for photo in savedPhotos {
//			getCoreDataStack().context.delete(photo)
//		}
//
//	}
//
//	/* 7 */
//	// delete photos
//	func removeSelectedPhotosAtCoreData() {}
//
//	/* 8 */
//	// obtener resultado aleatorio
//	func getFlickrPhotosRandomResult(completion: @escaping (_ result: [FlickrImage]?) -> Void) {
//
//		// crea una variable 'result' de tipo [FlickrImage] en principio vacío
//		var result: [FlickrImage] = []
//
//		FlickrClient.taskForGetPhotos(lat: coordinateSelected.latitude, lon: coordinateSelected.longitude) { (success, flickrImages) in
//
//			if success {
//
//				if flickrImages!.count > self.totalCellCount {
//
//					// un array de enteros para usar aleatoriamente
//					var randomArray: [Int] = []
//
//					while randomArray.count < self.totalCellCount {
//
//
//						let random = arc4random_uniform(UInt32(flickrImages!.count))
//
//						if !randomArray.contains(Int(random)) { randomArray.append(Int(random)) }
//
//					}
//
//					for random in randomArray {
//
//						result.append(flickrImages![random])
//
//					}
//
//					completion(result)
//
//				} else {
//
//					completion(flickrImages!)
//				}
//
//
//			} else {
//				completion(nil)
//			}
//
//		}
//
//	} // end func
//
//	/* 9 */
//
//		func addCoreData(flickrImages: [FlickrImage], coreDataPin: Pin) {
//
//			for image in flickrImages {
//
//				do {
//
//					 	let delegate = UIApplication.shared.delegate as! AppDelegate
//						let stack = delegate.stack
//						let photo = Photo(index: flickrImages.index{$0 === image}!, imageURL: image.imageURLString(), imageData: nil, context: stack.context)
//						photo.pin = coreDataPin
//						try stack.saveContext()
//
//				} catch {
//
//					print("Add Core Data Failed")
//
//				}
//
//			}
//
//		} // end func
//
//}


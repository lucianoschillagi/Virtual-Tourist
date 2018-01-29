//
//  CoreDataMapAndCollectionViewController
//  Virtual Tourist
//
//  Created by Luciano Schillagi on 1/20/18.
//  Copyright © 2018 luko. All rights reserved.

/* Model */

import UIKit
import CoreData

class CoreDataMapAndCollectionViewController: UIViewController {

	//*****************************************************************
	// MARK: - Properties (fetchedResultsController)
	//*****************************************************************
	
	var fetchedResultsController : NSFetchedResultsController<NSFetchRequestResult>? {
		didSet { // observer...
			// cada vez que el Modelo cambia
			// realizar una búsqueda (para saber qué datos del modelo han cambiado)
			fetchedResultsController?.delegate = self
			executeSearch()
		}
	}
	
	//*****************************************************************
	// MARK: - Initializers
	//*****************************************************************
	
	init(fetchedResultsController fc : NSFetchedResultsController<NSFetchRequestResult>) {
		fetchedResultsController = fc
		super.init(nibName: "nose", bundle: nil) // luego REVISAR ESTA LÍNEA
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
}

//*****************************************************************
// MARK: - Fetches
//*****************************************************************

extension CoreDataMapAndCollectionViewController {

	func executeSearch() {
		if let fc = fetchedResultsController {
			do {
				try fc.performFetch()
			} catch let e as NSError {
				print("Error while trying to perform a search: \n\(e)\n\(String(describing: fetchedResultsController))")
			}
		}
	}
}

//*****************************************************************
// MARK: - Results
//*****************************************************************

extension CoreDataMapAndCollectionViewController: NSFetchedResultsControllerDelegate {

	func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
		
	}

	func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
//
//		let set = IndexSet(integer: sectionIndex)
//
//		switch (type) {
//		case .insert:
//			tableView.insertSections(set, with: .fade)
//		case .delete:
//			tableView.deleteSections(set, with: .fade)
//		default:
//			// irrelevant in our case
//			break
//		}
	}

	func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {

//		switch(type) {
//		case .insert:
//			collectionView.insertItem(at: [newIndexPath!], with: .fade)
//		case .delete:
//			collectionView.insertItem(at: [indexPath!], with: .fade)
//		case .update:
//			collectionView.insertItem(at: [indexPath!], with: .fade)
//		case .move:
//			collectionView.insertItem(at: [indexPath!], with: .fade)
//			collectionView.insertItem(at: [newIndexPath!], with: .fade)
//		}
	}

	func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
		//collectionView.endUpdates()
	}

} // end extension


//
//  CoreDataMapViewController.swift
//  Virtual Tourist
//
//  Created by Luciano Schillagi on 1/20/18.
//  Copyright © 2018 luko. All rights reserved.
//

//import UIKit
//import CoreData
//
//// MARK: - CoreDataMapViewController: UIViewController
//
//class CoreDataMapViewController: UIViewController {
//	
//	// MARK: Properties
//	
//	var fetchedResultsController : NSFetchedResultsController<NSFetchRequestResult>? {
//		didSet {
//			// Whenever the frc changes, we execute the search and
//			// reload the table
//			fetchedResultsController?.delegate = self as! NSFetchedResultsControllerDelegate
//			//executeSearch()
//			//mapView.reloadData()
//		}
//	}
//	
//	// MARK: Initializers
//	
//	init(fetchedResultsController fc : NSFetchedResultsController<NSFetchRequestResult>) {
//		fetchedResultsController = fc
//		super.init()
//	}
//	
//	// Do not worry about this initializer. I has to be implemented
//	// because of the way Swift interfaces with an Objective C
//	// protocol called NSArchiving. It's not relevant.
//	required init?(coder aDecoder: NSCoder) {
//		super.init(coder: aDecoder)
//	}
//}

// MARK: - CoreDataTableViewController (Subclass Must Implement)

//extension CoreDataMapViewController {
//
//	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//		fatalError("This method MUST be implemented by a subclass of CoreDataTableViewController")
//	}
//}

// MARK: - CoreDataTableViewController (Table Data Source)

//extension CoreDataMapViewController {
//
//	override func numberOfSections(in tableView: UITableView) -> Int {
//		if let fc = fetchedResultsController {
//			return (fc.sections?.count)!
//		} else {
//			return 0
//		}
//	}
//
//	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//		if let fc = fetchedResultsController {
//			return fc.sections![section].numberOfObjects
//		} else {
//			return 0
//		}
//	}
//
//	override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//		if let fc = fetchedResultsController {
//			return fc.sections![section].name
//		} else {
//			return nil
//		}
//	}
//
//	override func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
//		if let fc = fetchedResultsController {
//			return fc.section(forSectionIndexTitle: title, at: index)
//		} else {
//			return 0
//		}
//	}
//
//	override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
//		if let fc = fetchedResultsController {
//			return fc.sectionIndexTitles
//		} else {
//			return nil
//		}
//	}
//}

// MARK: - CoreDataTableViewController (Fetches)

//extension CoreDataMapViewController {
//
//	func executeSearch() {
//		if let fc = fetchedResultsController {
//			do {
//				try fc.performFetch()
//			} catch let e as NSError {
//				print("Error while trying to perform a search: \n\(e)\n\(fetchedResultsController)")
//			}
//		}
//	}
//}

// MARK: - CoreDataTableViewController: NSFetchedResultsControllerDelegate

//extension CoreDataMapViewController: NSFetchedResultsControllerDelegate {
//
//	func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
//		tableView.beginUpdates()
//	}
//
//	func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
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
//	}
//
//	func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
//
//		switch(type) {
//		case .insert:
//			tableView.insertRows(at: [newIndexPath!], with: .fade)
//		case .delete:
//			tableView.deleteRows(at: [indexPath!], with: .fade)
//		case .update:
//			tableView.reloadRows(at: [indexPath!], with: .fade)
//		case .move:
//			tableView.deleteRows(at: [indexPath!], with: .fade)
//			tableView.insertRows(at: [newIndexPath!], with: .fade)
//		}
//	}
//
//	func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
//		tableView.endUpdates()
//	}
//}


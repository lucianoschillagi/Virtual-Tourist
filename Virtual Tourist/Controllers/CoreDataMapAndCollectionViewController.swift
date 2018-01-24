//
//  CoreDataMapAndCollectionViewController.swift
//  Virtual Tourist
//
//  Created by Luciano Schillagi on 1/20/18.
//  Copyright © 2018 luko. All rights reserved.

/* Model */

import UIKit
import MapKit
import CoreData

// MARK: - CoreDataMapAndCollectionViewController: UIViewController

class CoreDataMapAndCollectionViewController: UIViewController, UICollectionViewDelegate {

	
	// MARK: Properties (fetchedResultsController)
	
	var fetchedResultsController : NSFetchedResultsController<NSFetchRequestResult>? {
		didSet {
			// Whenever the frc changes, we execute the search and
			// reload the table
			fetchedResultsController?.delegate = self as! NSFetchedResultsControllerDelegate
			executeSearch()
			//tableView.reloadData()
		}
	}
	
	// MARK: Initializers
	
	init(fetchedResultsController fc : NSFetchedResultsController<NSFetchRequestResult>) {
		fetchedResultsController = fc
		super.init()
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
}

// MARK: - CoreDataMapAndCollectionViewController

extension CoreDataMapAndCollectionViewController: MKMapViewDelegate {

	
}

// MARK: - CoreDataMapAndCollectionViewController (Collection Data Source)

extension CoreDataMapAndCollectionViewController: UICollectionViewDataSource {

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
		//return savedImages.count
		return 0
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "photoCell", for: indexPath)
		//		cell.activityIndicator.startAnimating()
		//		cell.initWithPhoto(savedImages[indexPath.row])
		return cell
	}
	

//	override func numberOfSections(in tableView: UITableView) -> Int {
//		if let fc = fetchedResultsController {
//			return (fc.sections?.count)!
//		} else {
//			return 0
//		}
//	}

//	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//		if let fc = fetchedResultsController {
//			return fc.sections![section].numberOfObjects
//		} else {
//			return 0
//		}
//	}

//	override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//		if let fc = fetchedResultsController {
//			return fc.sections![section].name
//		} else {
//			return nil
//		}
//	}

//	override func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
//		if let fc = fetchedResultsController {
//			return fc.section(forSectionIndexTitle: title, at: index)
//		} else {
//			return 0
//		}
//	}

//	override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
//		if let fc = fetchedResultsController {
//			return fc.sectionIndexTitles
//		} else {
//			return nil
//		}
//	}

}

// MARK: - CoreDataMapAndCollectionViewController (Fetches)

extension CoreDataMapAndCollectionViewController {

	func executeSearch() {
		if let fc = fetchedResultsController {
			do {
				try fc.performFetch()
			} catch let e as NSError {
				print("Error while trying to perform a search: \n\(e)\n\(fetchedResultsController)")
			}
		}
	}
}

// MARK: - CoreDataMapAndCollectionViewController: NSFetchedResultsControllerDelegate

extension CoreDataMapAndCollectionViewController: NSFetchedResultsControllerDelegate {

	func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
		
	}

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
}


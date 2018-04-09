//
//  PhotoAlbumViewController_CollectionViewMethods.swift
//  Virtual Tourist
//
//  Created by Luciano Schillagi on 4/8/18.
//  Copyright © 2018 luko. All rights reserved.
//

/* Controller */

import UIKit
import MapKit

/* Abstract:
Contiene los métodos del delegado de la collection view, tanto los de la fuente de datos como los de interacción del usuario.
*/

//*****************************************************************
// MARK: - Collection View Methods (Data Source)
//*****************************************************************

extension PhotoAlbumViewController: UICollectionViewDataSource {
	
	// collection view 🔌 model [Photo]
	
	/// task: poblar los items de la sección con la cantidad de elementos que tenga actualmente el modelo [Photo]
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {


		return coreDataPhotos.count  // 👈 MODEL
		
	}
	
	/// task: poblar los items de la colección con los datos actuales del modelo
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		
		// pone las fotos persistidas en [Photo] en cada item de la 'collection view'
		let photo = coreDataPhotos[(indexPath as NSIndexPath).row] // 👈 MODEL [Photo]
		
		// obtiene la celda reusable (personalizada)
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath) as! PhotoCell
		
		
		
		// CRUCIAL!
		// Comprobar si hay datos de imagenes persistidas, si así, convertirlos en imágenes y mostrarlos en la vistas de colección
		// caso contrario, realizar una solicitud web para obtener esos 'imageData' y realizar el proceso para convertirlos en imágenes
		
		
		
		/*	escenario 1: 'imageData' tiene valores (porque estan persistidos por Core Data) */
		// hay 'imageData' persistidos?
		// Sí!!!!!!!!!!!
		if photo.imageData != nil {
			
			// usarlos!
			
			// crea la imagen con los datos persistidos
			let photo = UIImage(data: photo.imageData! as Data) // 👈

			// actualiza la UI en la cola principal (dispatch)
			performUIUpdatesOnMain {
				
				// pone la imagen creada en la vista de celda 👏
				cell.photoImageView.image = photo
				
				// por último se detiene el indicator de actividad
				cell.activityIndicator.stopAnimating()
			
			}
			
		
	
		/*	escenario 2: 'imageData' no tiene ningún valor, entonces realizar una solicitud web para obtenerlos 🚀 */
		// hay 'imageData' persistidos?
		// NO!!!!!!!!!!!!!!!!!!!!
		} else  {
			
			// comprueba que hay ´imageURL´ para enviar con la solicitud
			if let photoPath = photo.imageURL {
				
				// Flickr Client 👈 ///////////////////////////////////////////////////////////////////////////imageData
		
				// realiza la solicitud web, envía las urls para obtener los datos de las imágenes
				let _ = FlickrClient.sharedInstance().taskForGetImage(photoPath: photoPath, completionHandlerForImage: { (imageData, error) in
					
					// si están los DATOS de imagen los convierte ahora sí en una imagen
					if let image = UIImage(data: imageData!) {
						
						// asigna los datos de la imagen a la propiedad del objeto gestionado 'Photo.imageData' 🔌
						photo.imageData = NSData.init(data: imageData!) // 'imageData' en CoreData!!!!
						
						// guarda el contexto (para que los datos de las imágenes queden persistidas)
						try? self.dataController.viewContext.save() // 💿
						
						
						// actualiza la UI en la cola principal (dispatch)
						performUIUpdatesOnMain {
							
								// pone la imagen creada en la vista de celda 👏
								cell.photoImageView.image = image
								
								// por último se detiene el indicator de actividad
								cell.activityIndicator.stopAnimating()
						}
						
					} else {
						
						print(error ?? "empty error")
					}
					
				}) // end 'taskForGetImage' method
				
			} // end optional binding

		}

		return cell
		
	} // end func
	
} // end ext


//*****************************************************************
// MARK: - Collection View Methods (Delegate)
//*****************************************************************

extension PhotoAlbumViewController: UICollectionViewDelegate {
	
	// task: decirle al delegado que el ítem en la ruta especificada ha sido SELECCIONADO
	func collectionView(_ collectionView: UICollectionView,didSelectItemAt indexPath: IndexPath) {
		
		// asigna a la propiedad 'selectedToDelete' los items seleccionados en la colección de vistas
		selectedToDelete = selectedToDeleteFromIndexPath(collectionView.indexPathsForSelectedItems!)
		
		// la ´dirección´ de la celda seleccionada
		let cell = collectionView.cellForItem(at: indexPath)
		
		// dispatch
		DispatchQueue.main.async {
			cell?.contentView.alpha = 0.4
		}
		
	}
	
	// task: decirle al delegado que el ítem en la ruta especificada ha sido DESELECCIONADO
	func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
		
		// asigna a la propiedad 'selectedToDelete' los items seleccionados en la colección de vistas
		selectedToDelete = selectedToDeleteFromIndexPath(collectionView.indexPathsForSelectedItems!)
		
		// la ´dirección´ de la celda seleccionada
		let cell = collectionView.cellForItem(at: indexPath)
		
		// dispatch
		DispatchQueue.main.async {
			cell?.contentView.alpha = 1.0
		}
		
	}
	
} // end ext

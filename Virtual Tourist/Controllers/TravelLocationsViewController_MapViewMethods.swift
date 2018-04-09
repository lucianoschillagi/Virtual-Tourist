//
//  TravelLocationsViewController_MapViewMethods.swift
//  Virtual Tourist
//
//  Created by Luciano Schillagi on 4/9/18.
//  Copyright © 2018 luko. All rights reserved.
//

/* Controller */

import UIKit
import MapKit
import CoreData

/* Abstract:
Contiene los métodos del delegado del map view concernientes a la intereacción del usuario.
*/

//*****************************************************************
// MARK: - Map View Methods
//*****************************************************************

extension TravelLocationsMapViewController: MKMapViewDelegate {
	
	// task:
	// si la pantalla está en modo edición y se tapea sobre un pin, borrar ese pin
	// si la pantalla NO está en modo edición y se tapea sobre un pin, navegar hacia la siguiente pantalla
	func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
		
		// la coordenada de ese pin
		let coordSelect = view.annotation?.coordinate
		let latitude = coordSelect?.latitude
		let longitude = coordSelect?.longitude
		
		// edit-mode: FALSE, navega hacia el próximo vc desde el pin tapeado
		if !editMode {
			
			// itera el array de pines persistidos con intenciones de pasarle
			// la ubicación del pin tapeado al ´PhotosAlbumVC´
			for pin in pins {
				
				// busca el pin con la ubicación coincidente
				if pin.latitude == latitude && pin.longitude == longitude {
					
					// almacena el pin correcto (coincidente) en la propiedad 'pinToPass'..
					self.pinToPass = pin
					// y su coordenada en 'pinCoordinate'
					self.pinCoordinate = coordSelect
					
				}
				
			} // end for-in loop
			
			// navega desde el pin tapeado al siguiente vc
			performSegue(withIdentifier: "PinPhotos", sender: coordSelect)
			// deselecciona la anotación tapeada
			mapView.deselectAnnotation(view.annotation, animated: false)
			
			// edit-mode: TRUE, borra los pines tapeados, tanto de la vista como de core data
		} else {
			
			// itera el array de pines persistidos con intenciones de BORRAR el pin tapeado
			for pin in pins {
				
				// si las coordenadas del pin persistido coinciden con la coordenada seleccionada
				if pin.latitude == latitude && pin.longitude == longitude {
					
					// asigna el pin a borrar con el pin coincidente
					let pinToDelete = pin
					
					
					// Core Data DELETE ///////////////////////////////
					
					// informa al contexto que borre ese pin
					dataController.viewContext.delete(pinToDelete)
					// e intenta guardar el estado actual del contexto
					try? dataController.viewContext.save() // 💿
					
				}
				
			} // end for-in
			
			// borra del mapa el pin tapeado
			mapView.removeAnnotation(view.annotation!)
			
		}
	}
	
} // end class



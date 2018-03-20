//: Playground - noun: a place where people can play

import Foundation
import MapKit

class Pins: NSObject, MKAnnotation {
	
	var coordinate: CLLocationCoordinate2D
	
	// MARK: - Initializers
	init(coordinate: CLLocationCoordinate2D) {
		
		self.coordinate = coordinate
		
		super.init()
	}
	
}

// crea un coordenadas y las pone dentro de la estructura 'CLLocationCoordinate2D'
let coordenadas = CLLocationCoordinate2D(latitude: 56.435345, longitude: 67.4543345)

// crea una instancia de 'Pins' y le pasa, al inicializarlo, esas coordenadas
let pins = Pins(coordinate: coordenadas)

print("\(pins.coordinate)")





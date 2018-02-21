//: Playground - noun: a place where people can play

import Foundation
import UIKit

/* Crear una clase y luego un array (colección) de esa misma clase */

// crea una clase
class MiClase {
	
	var nro = 0
}

// instancia la clase
let mc = MiClase()
mc.nro = 1
// otra instancia de la misma clase
let mc2 = MiClase()
mc2.nro = 100

// un array de clase 'MiClase'
var arrayMc : [MiClase] = []

// el array por ahora está vacío
arrayMc.count
// le agrega un elmento al array
arrayMc.append(mc)
// entonces el array ahora contiene UN elemento
arrayMc.count
// el agrega un elemento más al array
arrayMc.append(mc2)
// entonces el array ahora contiene DOS elementos
arrayMc.count

class OtraClase {
	
	let cara = "😎"
}

let oc = OtraClase()
oc.cara

//arrayMc.append(oc) // ERROR, el array espera otro tipo de dato (un objeto de clase 'MiClase')

//*****************************************************************

/* Acceder a los valores de un diccionario mediante sus claves */

let pasos: [Int:String] // [key:value]
pasos = [1:"uno", 2:"dos", 3:"tres"]
pasos[1]
pasos[2]

let tarot = ["V": "Le Pape", "XV": "Le Diable", "XIII": "Temperance"]
tarot["XII"]
tarot["XIII"]

let url = ["url_m": "https://tomato-timer.com/"]
url["url_m"]

//////

// modelo
let significado: [String: String] = ["Atmosfera": "Capa gaseosa que envuelve un astro; especialmente, la que rodea la Tierra.",
																		 "Biósfera": "Capa constituida por agua, tierra y una masa delgada de aire, en la cual se desarrollan los seres vivos; comprende desde unos 10 km de altitud en la atmósfera hasta los fondos oceánicos.",
																		 "Estratosfera": "Capa de la atmósfera terrestre que se extiende entre los 10 y los 50 km de altitud aproximadamente; en ella reina un perfecto equilibrio dinámico y una temperatura casi constante."]
// accede por clave al valor
significado["Atmósfera"]
significado.count

// estructura para albergar el modelo
struct Significado {
	
	let palabra: String
	
	init(diccionario: [String: String]) {
	
		palabra = diccionario["Atmósfera"] as! String

	}
}


// 21-02-18

// completion handler

// define una función que toma un ´closure´ como parámetro
func hola(nombre: String, completionHandler: @escaping (_ n1: Int, _ n2: Int) -> Int) {
	
	print("hola \(nombre)")
}






//FlickrClient.sharedInstance().getPhotosPath(lat: coordinateSelected.latitude, lon: coordinateSelected.longitude) { (photos, error) in
//
//	if let photos = photos {
//		self.photos = photos
//
//		// dispatch
//		performUIUpdatesOnMain {
//			print("🏈 \(photos)")
//
//		}
//	} else {
//		print(error ?? "empty error")
//	}
//}





//: Playground - noun: a place where people can play

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






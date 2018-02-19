
import Foundation

// CRUCIAL ENTENDER BIEN ESTO!

// simil objeto JSON recibido de una solicitud web

// modelo

let significadoWikipedia: [String: String] = ["Atmosfera": "Capa gaseosa que envuelve un astro; especialmente, la que rodea la Tierra.",
																							"Biosfera": "Capa constituida por agua, tierra y una masa delgada de aire, en la cual se desarrollan los seres vivos; comprende desde unos 10 km de altitud en la atmósfera hasta los fondos oceánicos.",
																							"Estratosfera": "Capa de la atmósfera terrestre que se extiende entre los 10 y los 50 km de altitud aproximadamente; en ella reina un perfecto equilibrio dinámico y una temperatura casi constante."]

let significadoRae = ["Atmosfera": "Capa gaseosa que rodea la Tierra y otros cuerpos celestes..",
											"Biosfera": "Conjunto de los medios donde se desarrollan los seres vivos.",
											"Estratosfera": "Capa intermedia de la homosfera, desde los 12 a los 50 km de altura."]


let significadoElMundo = ["Atmosfera": "Masa gaseosa que rodea un astro, especialmente referida a la que rodea la Tierra.",
													"Biosfera": "Parte de la superficie sólida, líquida y gaseosa de la Tierra en la que se desarrollan los seres vivos.",
													"Estratosfera": "Región de la atmósfera, que va desde los 10 o 20 km a los 50 km de altura, compuesta por capas de diferente temperatura, una de las cuales es la de ozono, que protege la tierra de los rayos ultravioleta del Sol."]


// crea una array de diccionario '[String: String]' y les asigna tres diccionario
let tresFuentes: [[String: String]] = [significadoWikipedia, significadoRae, significadoElMundo]
tresFuentes.count

// accede por clave al valor
significadoWikipedia["Atmosfera"]
significadoWikipedia.count

// estructura para albergar el modelo
struct Significado {
	
	let atmosfera: String
	let biosfera: String
	let estratosfera: String
	
	init(diccionario: [String: String]) {
		
		// claves de los valores deseados de cada objeto
		atmosfera = diccionario["Atmosfera"]!
		biosfera = diccionario["Biosfera"]!
		estratosfera = diccionario["Estratosfera"]!
	}
	
		static func significadosDesdeResultados(_ resultados: [[String:String]]) -> [Significado] {
	
			var significado = [Significado]()
	
			// iterate through array of dictionaries, each 'FlickrImage' is a dictionary
			for resultado in resultados {
				significado.append(Significado(diccionario: resultado))
			}
	
			return significado
		}
	
	
} // end struct

// usando los datos (valores) ya mapeados y almacenados en el modelo
let sWikipedia = Significado(diccionario: significadoWikipedia)
sWikipedia.biosfera

let sElMundo = Significado(diccionario: significadoElMundo)
sElMundo.atmosfera

let r = Significado.significadosDesdeResultados(tresFuentes)
print("\(r)")

let frase = "😲 Esta es una definición de 'atmosfera': \(sWikipedia.biosfera))"
print(frase)








/* Controller */

import UIKit // interfaz de usuario
import MapKit // mapa
import CoreData // persistir datos

class PhotoAlbumViewController: UIViewController {
	
	// MARK: - Model
	var collectionData = ["1 🤡", "2 👄", "3 👴🏽", "4 👩🏼‍🚀", "5 🐊", "6 🦏", "7 🐆", "8 🐿"
		, "9 🐸", "10 🐛", "11 🎹", "12 🏄🏼‍♀️"] // end model
	
	// MARK: - Outlets
	@IBOutlet weak var mapFragment: MKMapView!
	@IBOutlet weak var collectionView: UICollectionView!
	
	// MARK: - View Life Cycle
	override func viewDidLoad() {
		super.viewDidLoad()
		
		// el diseño de la colección de vista, en 3 columnas separadas por 20pts
		let width = (view.frame.size.width - 20) / 3
		let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
		// el tamaño de cada item
		layout.itemSize = CGSize(width: width, height: width)
	
	}
	
} // end VC

extension PhotoAlbumViewController: UICollectionViewDataSource, UICollectionViewDelegate {
	/**
	Pregunta al 'data source object' por el número de items en una sección específica.
	
	- parameter collectionView: la collection view que solicita esta información.
	- parameter section: Un número de índice que identifica una sección en collectionView. Este valor de índice está basado en 0.
	
	- returns: El número de filas en la sección.
	*/
	// UICollectionViewDataSource
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return collectionData.count
	}
	
	/**
	Pide el objeto de fuente de datos para la celda que corresponde al elemento especificado en la vista de colección.
	
	- parameter collectionView: la vista de colección que solicita esta información.
	- parameter indexPath: La ruta de índice que especifica la ubicación del elemento
	
	- returns: El número de filas en la sección.
	*/
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath)
		if let label = cell.viewWithTag(100) as? UILabel {
			label.text = collectionData[indexPath.row]
		}
		return cell
	}
	
} // end extension
	
	


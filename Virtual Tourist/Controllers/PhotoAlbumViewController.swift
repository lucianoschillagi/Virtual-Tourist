
/* Controller */

import UIKit // interfaz de usuario
import MapKit // mapa
import CoreData // persistir datos

class PhotoAlbumViewController: UIViewController {
	
	// MARK: - Model
	var collectionData = ["1 🤡", "2 👄", "3 👴🏽", "4 👩🏼‍🚀", "5 🐊", "6 🦏", "7 🐆", "8 🐿"
		, "9 🐸", "10 🐛", "11 🎹", "12 🏄🏼‍♀️"] // end model
	
	// MARK: - Stored Properties
	let regionRadius: CLLocationDistance = 1000
	
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
	
		// map view
		// set initial location in Honolulu
		let initialLocation = CLLocation(latitude: 21.282778, longitude: -157.829444)
		centerMapOnLocation(location: initialLocation)
	}
	
	// MARK: - Map, Helper Method
	func centerMapOnLocation(location: CLLocation) {
		let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
																															regionRadius, regionRadius)
		mapFragment.setRegion(coordinateRegion, animated: true)
		
		// networking
		getImageFromFlickr()
	}
	
	// MARK: - Make Network Request
	/**
	Mediante este método (obtener una imagen desde Flickr) creo una solicitud web conectándome con la API de Flickr. Le voy a solicitar datos. Un recurso específico que en este caso serán imágenes de galerías alojadas en Flickr. Este es un método que no toma ni devuelve nada, sólo ejecuta, al ser llamado, lo que contiene su cuerpo.
	*/
	func getImageFromFlickr() {
	
		let session = URLSession.shared // luego mover esta linea
		
		/* 1. Set the parameters */
		let methodParameters = [
			Flickr.ParameterKeys.Method: Flickr.ParameterValues.SearchMethod,
			Flickr.ParameterKeys.ApiKey: Flickr.ParameterValues.ApiKey,
			Flickr.ParameterKeys.Lat: "-32.944243",
			Flickr.ParameterKeys.Lon: "-60.650539",
			Flickr.ParameterKeys.Format: Flickr.ParameterValues.ResponseFormat,
			Flickr.ParameterKeys.NoJSONCallback: Flickr.ParameterValues.DisableJSONCallback
		]
		
		/* 2/3. Build the URL, Configure the request */
		let request = URLRequest(url: flickrURLFromParameters(methodParameters as [String:AnyObject]))
		
		/* 4. Make the request */
		let task = session.dataTask(with: request) { (data, response, error) in
			
			// if an error occurs, print it and re-enable the UI
			func displayError(_ error: String) {
				print(error)
				//print("URL at time of error: \(url)")
				performUIUpdatesOnMain {
					//self.setUIEnabled(true)
				}
			}
			
			/* GUARD: Was there an error? */
			guard (error == nil) else {
				displayError("There was an error with your request: \(error!)")
				return
			}
			
			/* GUARD: Did we get a successful 2XX response? */
			guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
				displayError("Your request returned a status code other than 2xx!")
				return
			}
			
			/* GUARD: Was there any data returned? */
			guard let data = data else {
				displayError("No data was returned by the request!")
				return
			}
			
			// parse the data
			let parsedResult: [String:AnyObject]!
			do {
				parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String:AnyObject]
			} catch {
				displayError("Could not parse the data as JSON: '\(data)'")
				return
			}
			
			print(parsedResult)
			/* GUARD: Did Flickr return an error (stat != ok)? */
			guard let stat = parsedResult[Flickr.ResponseKeys.Status] as? String, stat == Flickr.ResponseValues.OKStatus else {
				displayError("Flickr API returned an error. See error code and message in \(parsedResult)")
				return
			}
			
			/* GUARD: Are the "photos" and "photo" keys in our result? */
			guard let photosDictionary = parsedResult[Flickr.ResponseKeys.Photos] as? [String:AnyObject], let photoArray = photosDictionary[Flickr.ResponseKeys.Photo] as? [[String:AnyObject]] else {
				displayError("Cannot find keys '\(Flickr.ResponseKeys.Photos)' and '\(Flickr.ResponseKeys.Photo)' in \(parsedResult)")
				return
			}
			
			// select a random photo
			let randomPhotoIndex = Int(arc4random_uniform(UInt32(photoArray.count)))
			let photoDictionary = photoArray[randomPhotoIndex] as [String:AnyObject]
			let photoTitle = photoDictionary[Flickr.ResponseKeys.Title] as? String
			
			/* GUARD: Does our photo have a key for 'url_m'? */
			guard let imageUrlString = photoDictionary[Flickr.ResponseKeys.MediumURL] as? String else {
				displayError("Cannot find key '\(Flickr.ResponseKeys.MediumURL)' in \(photoDictionary)")
				return
			}
			
			// if an image exists at the url, set the image and title
			let imageURL = URL(string: imageUrlString)
			if let imageData = try? Data(contentsOf: imageURL!) {
				performUIUpdatesOnMain {
					//self.setUIEnabled(true)
					//self.photoImageView.image = UIImage(data: imageData)
					//self.photoTitleLabel.text = photoTitle ?? "(Untitled)"
				}
			} else {
				displayError("Image does not exist at \(imageURL!)")
			}
		}
		
		// start the task!
		task.resume()
	}
	
//	 MARK: - URL from parameters
		/**
		Crea una URL con los parámetros necesarios para obtener los datos buscados.
	
		- parameter parameters: los parámetros necesarios para realizar la petición.
	
		- returns: la URL completa para realizar la petición.
		*/
		private func flickrURLFromParameters(_ parameters: [String:AnyObject]) -> URL {
			// los componentes (piezas) de la URL
			var components = URLComponents()
			components.scheme = Flickr.Constants.ApiScheme
			components.host = Flickr.Constants.ApiHost
			components.path = Flickr.Constants.ApiPath
			components.queryItems = [URLQueryItem]()
			// itera los parámetros de la solicitud
			for (key, value) in parameters {
				let queryItem = URLQueryItem(name: key, value: "\(value)")
				components.queryItems!.append(queryItem)
			}
	
			return components.url!
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
	
	


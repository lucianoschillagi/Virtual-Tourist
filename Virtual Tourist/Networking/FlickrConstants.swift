//
//  FlickrConstants.swift
//  Virtual Tourist
//
//  Created by Luciano Schillagi on 12/7/17.
//  Copyright © 2017 luko. All rights reserved.
//

/* Networking */

import Foundation

/* Abstract:
Un objeto que contiene los datos constantes requeridos para confeccionar la solicitud web.
*/

//*****************************************************************
// MARK: - FlickrClient (Constants)
//*****************************************************************

extension FlickrClient {
	
	//*****************************************************************
	// MARK: - Constants
	//*****************************************************************

	struct Constants {
		
			static let ApiScheme = "https"
			static let ApiHost = "api.flickr.com"
			static let ApiPath = "/services/rest"
		
	}
		
		//*****************************************************************
		// MARK: - Flickr Parameter Keys
		//*****************************************************************
		
		struct ParameterKeys {
			
			static let Method = "method"
			static let ApiKey = "api_key"
			static let Format = "format"
			static let Lat = "lat"
			static let Lon = "lon"
			static let NoJSONCallback = "nojsoncallback"
			static let SafeSearch = "safe_search"
			static let Extras = "extras"
			static let Radius = "radius"
			static let PerPage = "per_page"
			static let Page = "page"

		}
		
		//*****************************************************************
		// MARK: - Flickr Parameter Values
		//*****************************************************************
		
		struct ParameterValues {
			
			static let SearchMethod = "flickr.photos.search"
			static let ApiKey = "200778b8a74284c35e9cf41905e84d39"
			static let ResponseFormat = "json"
			static let DisableJSONCallback = "1" /* 1 means "yes" */
			static let MediumURL = "url_m"
			static let UseSafeSearch = "1"
			static let SearchRangeKm = 10
			static let PerPageAmount = 21
		}
		
		//*****************************************************************
		// MARK: - Flickr Response Keys
		//*****************************************************************
		
		struct JSONResponseKeys {
			
			static let Status = "stat"
			static let Photos = "photos"
			static let Photo = "photo"
			static let MediumURL = "url_m"
			
		}
		
		//*****************************************************************
		// MARK: - Flickr Response Values
		//*****************************************************************
		struct ResponseValues {
			
			static let OKStatus = "ok"
			
		}
}


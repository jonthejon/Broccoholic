//
//  Restaurant.swift
//  Broccoholic
//
//  Created by Jonathan Oliveira on 11/02/18.
//  Copyright © 2018 Jonathan Oliveira. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class Restaurant: NSObject, MKAnnotation {
	
	var title: String?
	let url: String
	let rating: Double
	let price: String
	let phone: String
	var coordinate: CLLocationCoordinate2D
	
	init(data:[String:Any]) {
		self.title = data["name"] as? String ?? "?"
		self.url = data["url"] as? String ?? "No ULR defined"
		self.rating = data["rating"] as? Double ?? 0.0
		self.price = data["price"] as? String ?? "No price defined"
		self.phone = data["display_phone"] as? String ?? "No phone defined"
		if let rawCoordinates = data["coordinates"] as? [String:Double] {
			let latitude = rawCoordinates["latitude"] ?? 0.0
			let longitude = rawCoordinates["longitude"] ?? 0.0
			self.coordinate = CLLocationCoordinate2DMake(latitude, longitude)
		} else {
			self.coordinate = CLLocationCoordinate2DMake(0.0, 0.0)
		}
	}

}

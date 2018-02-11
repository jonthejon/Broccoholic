//
//  Restaurant.swift
//  Broccoholic
//
//  Created by Jonathan Oliveira on 11/02/18.
//  Copyright © 2018 Jonathan Oliveira. All rights reserved.
//

import UIKit

class Restaurant {
	
	let name: String
	let url: String
	let rating: Double
	let price: String
	let phone: String
	
	init(data:[String:Any]) {
		self.name = data["name"] as? String ?? "No name defined"
		self.url = data["url"] as? String ?? "No ULR defined"
		self.rating = data["rating"] as? Double ?? 0.0
		self.price = data["price"] as? String ?? "No price defined"
		self.phone = data["display_phone"] as? String ?? "No phone defined"
	}

}

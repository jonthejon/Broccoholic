//
//  Ingredient.swift
//  Broccoholic
//
//  Created by Jonathan Oliveira on 10/02/18.
//  Copyright © 2018 Jonathan Oliveira. All rights reserved.
//

import UIKit

class Ingredient {
	
	let name:String
	let quantity:Double
	let unit:String
	
	init(name:String, quantity:Double, unit:String) {
		self.name = name
		self.quantity = quantity
		self.unit = unit
	}

}

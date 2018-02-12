//
//  IngredientRealm.swift
//  Broccoholic
//
//  Created by Jonathan Oliveira on 10/02/18.
//  Copyright © 2018 Jonathan Oliveira. All rights reserved.
//

import UIKit
import RealmSwift

class IngredientRealm: Object {
	
	@objc dynamic var name = ""
	@objc dynamic var quantity: Double = 0.0
	@objc dynamic var unit = ""

}

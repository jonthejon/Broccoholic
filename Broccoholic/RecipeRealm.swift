//
//  RecipeRealm.swift
//  Broccoholic
//
//  Created by Jonathan Oliveira on 09/02/18.
//  Copyright © 2018 Jonathan Oliveira. All rights reserved.
//

import UIKit
import RealmSwift

class RecipeRealm: Object {

	@objc dynamic var id = 0
	@objc dynamic var title = ""
	@objc dynamic var imageUrl = ""
	@objc dynamic var image: Data? = nil
	let ingredients = List<IngredientRealm>()
	let servings = RealmOptional<Int>()
	let readyInMin = RealmOptional<Int>()
	@objc dynamic var instructions: String? = nil
	let detailedInstructions = List<String>()
	@objc dynamic var isBookmarked = false
	@objc dynamic var isComplete = false
	
}

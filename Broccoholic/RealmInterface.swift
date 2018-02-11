//
//  RealmInterface.swift
//  Broccoholic
//
//  Created by Jonathan Oliveira on 09/02/18.
//  Copyright © 2018 Jonathan Oliveira. All rights reserved.
//

import UIKit
import RealmSwift

class RealmInterface {
	
	func saveRecipe(recipe: Recipe) {
		let recipeToSave = RecipeRealm()
		recipeToSave.id = recipe.id
		recipeToSave.title = recipe.title
		recipeToSave.imageUrl = recipe.imageUrl
		if let image = recipe.image {
//			might break if image is of png format
			recipeToSave.image = UIImageJPEGRepresentation(image, 1.0)
		}
		let ingredientsRealm = List<IngredientRealm>()
		if let ingredients = recipe.ingredients {
			for ingredient in ingredients {
				let realmIngredient = IngredientRealm()
				realmIngredient.name = ingredient.name
				realmIngredient.quantity = ingredient.quantity
				realmIngredient.unit = ingredient.unit
				ingredientsRealm.append(realmIngredient)
//				recipeToSave.ingredients.append(realmIngredient)
			}
		}
		recipeToSave.ingredients.append(objectsIn: ingredientsRealm)
		recipeToSave.servings.value = recipe.servings
		recipeToSave.readyInMin.value = recipe.readyInMin
		recipeToSave.instructions = recipe.instructions
		let detailedInstRealm = List<String>()
		if let detailedInstructions = recipe.detailedInstructions {
			for detaileInstruction in detailedInstructions {
				detailedInstRealm.append(detaileInstruction)
			}
		}
		recipeToSave.detailedInstructions.append(objectsIn: detailedInstRealm)
		recipeToSave.isBookmarked = recipe.isBookmarked
		recipeToSave.isComplete = recipe.isComplete
		self.persistRecipeIntoRealm(recipe: recipeToSave)
	}
	
	func deleteRecipe(recipe: Recipe) {
		let realm = try! Realm()
		let results = realm.objects(RecipeRealm.self)
		var objectToDelete:RecipeRealm = RecipeRealm()
		for realmRecipe in results {
			if recipe.id == realmRecipe.id {
				objectToDelete = realmRecipe
				break
			}
		}
		let ingredientsToDelete = objectToDelete.ingredients
		try! realm.write {
			realm.delete(ingredientsToDelete)
			realm.delete(objectToDelete)
		}
	}
	
	func deleteAll() {
		let realm = try! Realm()
		try! realm.write {
			realm.delete(realm.objects(RecipeRealm.self))
		}
	}
	
	func fetchSavedRecipes() -> [Recipe] {
		return self.fetchRecipesFromRealm()
	}
	
	func fetchIDsOfSavedRecipes() -> [Int] {
		let savedRecipes = self.fetchRecipesFromRealm()
		let ids = savedRecipes.map { (saved) -> Int in
			return saved.id
		}
		return ids
	}
	
	private func persistRecipeIntoRealm(recipe: RecipeRealm) {
		let realm = try! Realm()
		try! realm.write {
			realm.add(recipe)
		}
	}
	
	private func fetchRecipesFromRealm() -> [Recipe] {
		let realm = try! Realm()
		let results = realm.objects(RecipeRealm.self)
		var recipes:[Recipe] = [Recipe]()
		for recipe in results {
			let temp = Recipe(id: recipe.id, title: recipe.title, imageUrl: recipe.imageUrl)
			temp.servings = recipe.servings.value
			temp.readyInMin = recipe.readyInMin.value
			var image:UIImage? = nil
			if let imageData = recipe.image {
				image = UIImage.init(data: imageData)
			}
			temp.image = image
			var ingredients = [Ingredient]()
			for realmIngredient in recipe.ingredients {
				let name = realmIngredient.name
				let quantity = realmIngredient.quantity
				let unit = realmIngredient.unit
				ingredients.append(Ingredient(name: name, quantity: quantity, unit: unit))
			}
			temp.ingredients = ingredients.count > 0 ? ingredients : nil
			temp.instructions = recipe.instructions
			var detailedInstructions = [String]()
			for realmDetailInst in recipe.detailedInstructions {
				detailedInstructions.append(realmDetailInst)
			}
			temp.detailedInstructions = detailedInstructions.count > 0 ? detailedInstructions : nil
			temp.isBookmarked = recipe.isBookmarked
			temp.isComplete = recipe.isComplete
			recipes.append(temp)
		}
		return recipes
	}

}

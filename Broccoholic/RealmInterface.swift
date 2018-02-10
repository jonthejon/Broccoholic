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
//		recipeToSave.image = recipe.image
		recipeToSave.servings.value = recipe.servings
		recipeToSave.readyInMin.value = recipe.readyInMin
		recipeToSave.instructions = recipe.instructions
		recipeToSave.isBookmarked = recipe.isBookmarked
		recipeToSave.isComplete = recipe.isComplete
		self.persistRecipeIntoRealm(recipe: recipeToSave)
	}
	
	func deleteRecipe(recipe: Recipe) {
		let realm = try! Realm()
		let results = realm.objects(RecipeRealm.self)
		var objectToDelete:RecipeRealm = RecipeRealm()
//		let objectToDelete:RecipeRealm?
		for realmRecipe in results {
			if recipe.id == realmRecipe.id {
				objectToDelete = realmRecipe
				break
			}
		}
		try! realm.write {
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
		return self.fetchSavedRecipes()
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
//			temp.image = recipe.image
			temp.servings = recipe.servings.value
			temp.readyInMin = recipe.readyInMin.value
			temp.instructions = recipe.instructions
			temp.isBookmarked = recipe.isBookmarked
			temp.isComplete = recipe.isComplete
			recipes.append(temp)
		}
		return recipes
	}

}

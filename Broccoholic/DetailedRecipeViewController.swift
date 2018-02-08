//
//  DetailedRecipeViewController.swift
//  Broccoholic
//
//  Created by Aaron Chong on 2/7/18.
//  Copyright © 2018 Jonathan Oliveira. All rights reserved.
//

import UIKit

class DetailedRecipeViewController: UIViewController {
    
    @IBOutlet weak var recipeNameLabel: UILabel!
    @IBOutlet weak var recipeImageView: UIImageView!
    
    var optRecipe: Recipe?
	var optApiManager: RecipeAPIManager?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let recipe = optRecipe {
            recipeNameLabel.text = recipe.title
            recipeImageView.image = recipe.image
			if recipe.isComplete {
				print("Fetching from CACHE!!")
				print("Num of servings: \(recipe.servings!)")
				print("Ready in: \(recipe.readyInMin!) minutes")
				print("Num of ingredients: \((recipe.ingredients!).count)")
				print("Instructions: \(recipe.instructions!)")
			} else {
				if let manager = self.optApiManager {
					manager.fetchRecipeDetailFromApi(recipe: recipe, callback: { (result:Recipe) in
						OperationQueue.main.addOperation({
							recipe.servings = result.servings
							recipe.readyInMin = result.readyInMin
							recipe.instructions = result.instructions
							recipe.ingredients = result.ingredients
							recipe.isComplete = result.isComplete
							print("Fetching from API!!")
							print("Num of servings: \(recipe.servings!)")
							print("Ready in: \(recipe.readyInMin!) minutes")
							print("Num of ingredients: \((recipe.ingredients!).count)")
							print("Instructions: \(recipe.instructions!)")
						})
					})
				}
			}
        } else {
            print("Nil")
        }
    }
}

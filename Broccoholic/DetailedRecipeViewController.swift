//
//  DetailedRecipeViewController.swift
//  Broccoholic
//
//  Created by Aaron Chong on 2/7/18.
//  Copyright © 2018 Jonathan Oliveira. All rights reserved.
//

import UIKit

class DetailedRecipeViewController: UIViewController, UITableViewDataSource {
    
    @IBOutlet weak var recipeNameLabel: UILabel!
    @IBOutlet weak var recipeImageView: UIImageView!
    @IBOutlet weak var servingsLabel: UILabel!
    @IBOutlet weak var readyLabel: UILabel!
    @IBOutlet weak var directionsText: UITextView!
    
    
    @IBOutlet weak var bookmarkSwitch: UISwitch! //temp switch
    
    let randomArray = ["text1", "text2", "text3"]
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return randomArray.count // return array
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "detailedCell", for: indexPath) as! DetailedControllerCell
        
    
    
        return cell
    }
    
}

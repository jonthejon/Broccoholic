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
    @IBOutlet weak var servingsLabel: UILabel!
    @IBOutlet weak var readyLabel: UILabel!
    @IBOutlet weak var directionsText: UITextView!
    @IBOutlet weak var ingredientsLabel: UILabel!
    
    @IBOutlet weak var bookSwitch: UISwitch!
    var optRecipe: Recipe?
    var optApiManager: RecipeAPIManager?
    
    
    
    @IBAction func bookmarkSwitch(_ sender: UISwitch) {
        let switchValue = sender.isOn
            if let recipe = optRecipe {
                recipe.isBookmarked = switchValue
                print("\(recipe.isBookmarked)")
            }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let recipe = optRecipe {
            recipeNameLabel.text = recipe.title
            recipeImageView.image = recipe.image
            if recipe.isComplete {
                self.updateUI()
            }
//			else {
//                if let manager = self.optApiManager {
//                    manager.fetchRecipeDetailFromApi(recipe: recipe, callback: { (result:Recipe) in
//                        OperationQueue.main.addOperation({
//                            recipe.servings = result.servings
//                            recipe.readyInMin = result.readyInMin
//                            recipe.instructions = result.instructions
//                            recipe.ingredients = result.ingredients
//                            recipe.isComplete = result.isComplete
//
//                            self.updateUI()
//
//                        })
//                    })
//                }
//            }
        }
    }
    
    func updateUI() {
        guard let recipe = self.optRecipe else {
            return
        }
        self.ingredientsLabel.text = ""
        if let ingredientsArrTup = recipe.ingredients {
            for tuple in ingredientsArrTup {
                let name = tuple.name
                let amount = tuple.quantity
                let unit = tuple.unit
                self.ingredientsLabel.text?.append("\(name), quantity:\(amount), unit:\(unit)\n")
            }
        }
        
        self.bookSwitch.isOn = recipe.isBookmarked
        
        if let recipeServings = recipe.servings {
            self.servingsLabel.text = "Servings: \(String(recipeServings))"
        }
        
        if let readyInMin = recipe.readyInMin {
            self.readyLabel.text = "Prepare time: \(String(readyInMin))mins"
        }
        
        if let instructions = recipe.instructions {
            self.directionsText.text = instructions
        }
        
    }
    
}

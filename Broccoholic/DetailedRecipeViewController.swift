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
    
    @IBOutlet weak var bookmarkOutlet: UIButton!

    
    var optRecipe: Recipe?
    var optApiManager: RecipeAPIManager?
    
    @IBAction func bookmarkButton(_ sender: UIButton) {
        
        bookmarkOutlet.isHidden = false
        self.bookmarkOutlet.transform = CGAffineTransform(scaleX: 0, y: 0)
        
        UIView.animate(withDuration: 0.35, delay: 0, options: [], animations: { () -> Void in
            self.bookmarkOutlet.transform = CGAffineTransform(scaleX: 1, y: 1)
        })
        
        if let recipe = optRecipe {
            recipe.isBookmarked = !recipe.isBookmarked
			
			if let scv = self.navigationController?.viewControllers[0] as? SearchRecipesViewController {
				scv.updateBookmark(recipe: recipe)
			}
			
			
            displayBookmarkState()
        }
    }
    
    func displayBookmarkState() {
        if let recipe = optRecipe {
            if recipe.isBookmarked {
                bookmarkOutlet.setImage(#imageLiteral(resourceName: "hearts-on"), for: .normal)
            } else {
                bookmarkOutlet.setImage(#imageLiteral(resourceName: "hearts-off"), for: .normal)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.font: UIFont(name: "Futura", size: 17)!]
        self.title = "Broccoholic"
        
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
//		if let ingredientsArrTup = recipe.ingredients {
        if let ingredientsArr = recipe.ingredients {
//			for tuple in ingredientsArrTup {
            for tuple in ingredientsArr {
                let name = tuple.name
                let amount = tuple.quantity
                let unit = tuple.unit
                self.ingredientsLabel.text?.append("\(name), quantity:\(amount), unit:\(unit)\n")
            }
        }
        
        displayBookmarkState()
        
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

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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let recipe = optRecipe {
            recipeNameLabel.text = recipe.title
            recipeImageView.image = recipe.image
        } else {
            print("Nil")
        }
    }
}

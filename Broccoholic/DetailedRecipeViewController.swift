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
    
    var dummyRecipe: DummyRecipe?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let dummyrecipe = dummyRecipe {
            
            recipeNameLabel.text = dummyrecipe.recipeName
            recipeImageView.image = dummyrecipe.recipeImage
            
        } else {
            print("Nil")
        }
    }
}

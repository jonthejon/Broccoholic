//
//  RecipeCollectionViewCell.swift
//  Broccoholic
//
//  Created by Aaron Chong on 2/7/18.
//  Copyright © 2018 Jonathan Oliveira. All rights reserved.
//

import UIKit

class RecipeCollectionViewCell: UICollectionViewCell {
    
    var recipe: Recipe! {
        didSet {
            self.prepareCircle()
            self.recipeNameLabel.text = recipe.title
//            recipe.isBookmarked
        }
    }
    
    @IBOutlet weak var recipeImageView: UIImageView!
    @IBOutlet weak var recipeNameLabel: UILabel!
    
     func prepareCircle() {
        recipeImageView.layer.borderWidth = 0
        recipeImageView.layer.masksToBounds = false
        recipeImageView.layer.borderColor = UIColor.black.cgColor
        recipeImageView.layer.cornerRadius = recipeImageView.frame.height/2
        recipeImageView.clipsToBounds = true
    }
    
}



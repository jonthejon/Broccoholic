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
            prepareCircle()
            recipeNameLabel.text = recipe.title
            recipeImageView.image = recipe.image
            displayBookmarkState()
            self.backgroundColor = UIColor.clear
        }
    }
	var rootController: SearchRecipesViewController!
    
    @IBOutlet weak var recipeImageView: UIImageView!
    @IBOutlet weak var recipeNameLabel: UILabel!
    @IBOutlet weak var bookmarkButton: UIButton!
    
    func displayBookmarkState()  {
        if recipe.isBookmarked {
            bookmarkButton.setImage(#imageLiteral(resourceName: "hearts-on"), for: .normal)
        } else {
            bookmarkButton.setImage(#imageLiteral(resourceName: "hearts-off"), for: .normal)
        }
    }
    
    @IBAction func bookmarkRecipe(_ sender: Any) {
        
        bookmarkButton.isHidden = false
        self.bookmarkButton.transform = CGAffineTransform(scaleX: 0, y: 0)
        
//        UIView.animate(withDuration: 0.35, delay: 0, options: [], animations: { () -> Void in
//            self.bookmarkButton.transform = CGAffineTransform(scaleX: 1, y: 1)
//        })
        
        UIView.animate(withDuration: 0.35,
                       delay: 0,
                       usingSpringWithDamping: CGFloat(0.35),
                       initialSpringVelocity: CGFloat(0.0),
                       options: UIViewAnimationOptions.allowUserInteraction,
                       animations: {
                        self.bookmarkButton.transform = CGAffineTransform(scaleX: 1, y: 1)
        },
                       completion: { Void in()  }
        )
    
        recipe.isBookmarked = !recipe.isBookmarked
		
		self.rootController.updateBookmark(recipe: self.recipe)
		
        displayBookmarkState()
    }
    
    func prepareCircle() {
        recipeImageView.layer.borderWidth = 0
        recipeImageView.layer.masksToBounds = false
        recipeImageView.layer.borderColor = UIColor.black.cgColor
        recipeImageView.layer.cornerRadius = recipeImageView.frame.height/2
        recipeImageView.clipsToBounds = true

    }
}



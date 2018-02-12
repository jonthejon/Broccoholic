//
//  RecipeCollectionViewCell.swift
//  Broccoholic
//
//  Created by Aaron Chong on 2/7/18.
//  Copyright © 2018 Jonathan Oliveira. All rights reserved.
//

import UIKit

class RecipeCollectionViewCell: UICollectionViewCell {
	
	var itemSize: CGSize = .zero {
		didSet {
			if oldValue == .zero {
				prepareCircle()
			}
		}
	}

    var recipe: Recipe! {
        didSet {
            recipeNameLabel.text = recipe.title
            recipeImageView.image = recipe.image
            displayBookmarkState()
            self.backgroundColor = .clear
        
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
	
	func clearCell() {
		self.recipeNameLabel.text = ""
		self.recipeImageView.image = nil
	}
    
    @IBAction func bookmarkRecipe(_ sender: Any) {
        
        bookmarkButton.isHidden = false
        self.bookmarkButton.transform = CGAffineTransform(scaleX: 0, y: 0)
        
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
		let imageProportion:CGFloat = 0.75
		recipeImageView.bounds.size = CGSize.init(width: self.itemSize.width*imageProportion, height: self.itemSize.width*imageProportion)
		let xvalue = itemSize.width/2
		let yvalue = itemSize.height/2 - 20
		recipeImageView.center = CGPoint.init(x: xvalue, y: yvalue)
        recipeImageView.layer.borderWidth = 0
        recipeImageView.layer.masksToBounds = false
        recipeImageView.layer.borderColor = UIColor.black.cgColor
        recipeImageView.layer.cornerRadius = recipeImageView.frame.height/2
        recipeImageView.clipsToBounds = true
		
		let bookmarkRatio = bookmarkButton.bounds.width / bookmarkButton.bounds.height
		let newBookmarkWidth = recipeImageView.bounds.width*0.21
		let newBookmarkHeight = newBookmarkWidth / bookmarkRatio
		bookmarkButton.bounds.size = CGSize.init(width: newBookmarkWidth, height: newBookmarkHeight)
//		let bookmarkOffset:CGFloat = 5
		let newBookmarkX = recipeImageView.bounds.origin.x + recipeImageView.bounds.size.width// - 5// - (newBookmarkWidth/2)
		let newBookmarkY = recipeImageView.bounds.origin.y + recipeImageView.bounds.size.height - 5// - (newBookmarkHeight/2)
		bookmarkButton.center = CGPoint.init(x: newBookmarkX, y: newBookmarkY)
		
		let labelX = self.itemSize.width/2
		let labelY = newBookmarkY + 35
		recipeNameLabel.center = CGPoint.init(x: labelX, y: labelY)
		

    }
}



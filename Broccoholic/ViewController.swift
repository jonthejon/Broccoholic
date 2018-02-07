//
//  ViewController.swift
//  Broccoholic
//
//  Created by Jonathan Oliveira on 07/02/18.
//  Copyright © 2018 Jonathan Oliveira. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDataSource {
    
    var recipeArray = [DummyRecipe]()
//    var dummyRecipe =
    
    
	override func viewDidLoad() {
		super.viewDidLoad()
        
        let recipe1 = DummyRecipe(recipeName: "Broccoli Pasta", recipeImage: UIImage(named:"broccoli_pasta")!)
        let recipe2 = DummyRecipe(recipeName: "Broccoli Salad", recipeImage: UIImage(named:"broccoli_salad")!)
        let recipe3 = DummyRecipe(recipeName: "Pea & Potato Curry", recipeImage: UIImage(named:"pea_potato_curry")!)
        let recipe4 = DummyRecipe(recipeName: "Roasted Vegetables", recipeImage: UIImage(named:"roasted_vegetables")!)
        let recipe5 = DummyRecipe(recipeName: "Spinach Pie", recipeImage: UIImage(named:"spinach_pie")!)
        
        self.recipeArray = [recipe1, recipe2, recipe3, recipe4, recipe5]
	}

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return recipeArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "recipeCell", for: indexPath) as! RecipeCollectionViewCell
        
        let dummyRecipe = self.recipeArray[indexPath.item]
        
        cell.recipeImageView.image = dummyRecipe.recipeImage
        cell.recipeNameLabel.text = dummyRecipe.recipeName
        
        return cell
        
    }
}


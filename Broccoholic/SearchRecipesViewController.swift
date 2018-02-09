//
//  ViewController.swift
//  Broccoholic
//
//  Created by Jonathan Oliveira on 07/02/18.
//  Copyright © 2018 Jonathan Oliveira. All rights reserved.
//

import UIKit

class SearchRecipesViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    
    @IBOutlet weak var recipeCollectionView: UICollectionView!
    var data = [Recipe]()
	var apiManager = RecipeAPIManager()

	override func viewDidLoad() {
		super.viewDidLoad()
		self.apiManager.fetchRecipesFromApi(queryParameter: nil) { (resultArr:[Recipe]) in
			self.data = resultArr
			OperationQueue.main.addOperation({
				self.recipeCollectionView.reloadData()
                
			})
		}
	}
    
    override func viewWillAppear(_ animated: Bool) {
        self.recipeCollectionView.reloadData()
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "recipeCell", for: indexPath) as! RecipeCollectionViewCell
        let recipe = self.data[indexPath.item]
        cell.recipe = recipe
        // get rid of below
		cell.recipeNameLabel.text = recipe.title
		if recipe.image != nil {
			cell.recipeImageView.image = recipe.image!
			return cell
            
		}
		self.apiManager.fetchImageWithUrl(url: recipe.imageUrl) { (image:UIImage?) in
			OperationQueue.main.addOperation({
				recipe.image = image
				cell.recipeImageView.image = image
			})
		}
        return cell
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let segueIdentifier = "showDetail"
        if segue.identifier == segueIdentifier,
            let destination = segue.destination as? DetailedRecipeViewController,
            let indexPath = self.recipeCollectionView.indexPathsForSelectedItems?.last {
            destination.optRecipe = data[indexPath.item]
			destination.optApiManager = self.apiManager
        }
    }
}



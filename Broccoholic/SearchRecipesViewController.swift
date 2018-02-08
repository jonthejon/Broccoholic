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

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "recipeCell", for: indexPath) as! RecipeCollectionViewCell
        let recipe = self.data[indexPath.item]
		// TODO: this is where we will fetch the image data using Download with the API manager
        cell.recipeImageView.image = UIImage(cgImage: #imageLiteral(resourceName: "roasted_vegetables").cgImage!)
//        cell.recipeImageView.image = recipe.image
        cell.recipeNameLabel.text = recipe.title
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let segueIdentifier = "showDetail"
        
        if segue.identifier == segueIdentifier,
            let destination = segue.destination as? DetailedRecipeViewController,
            let indexPath = self.recipeCollectionView.indexPathsForSelectedItems?.last {
            destination.optRecipe = data[indexPath.item]
        }
    }
}



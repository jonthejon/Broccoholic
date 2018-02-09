//
//  ViewController.swift
//  Broccoholic
//
//  Created by Jonathan Oliveira on 07/02/18.
//  Copyright © 2018 Jonathan Oliveira. All rights reserved.
//

import UIKit

class SearchRecipesViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    
    @IBOutlet weak var collectionViewLayout: UICollectionViewFlowLayout!
    @IBOutlet weak var bookmarkButton: UIButton!
    @IBOutlet weak var recipeCollectionView: UICollectionView!
    
    var data = [Recipe]()
	var apiManager = RecipeAPIManager()

	override func viewDidLoad() {
		super.viewDidLoad()
        
		
		// THIS IS THE FAKE DATA INSERTION PART
		let rec1 = Recipe(id: 1, title: "Broccoli", imageUrl: "fakeURl")
		let rec2 = Recipe(id: 2, title: "pea", imageUrl: "fakeURl")
		rec1.image = UIImage(named:"broccoli_pasta")
		rec1.servings = 3
		rec1.readyInMin = 20
		rec1.ingredients = [("ingredient 1", 2, "cups"),
		("ingredient 2", 3, "cups"),
		("ingredient 3", 6, "cups"),
		("ingredient 4", 1, "spoons")]
		rec1.instructions = "mix all ingredients and there you go!"
		rec1.isComplete = true
		rec2.image = UIImage(named:"pea_potato_curry")
		rec2.servings = 3
		rec2.readyInMin = 20
		rec2.ingredients = [("ingredient 1", 2, "cups"),
							("ingredient 2", 3, "cups"),
							("ingredient 3", 6, "cups"),
							("ingredient 4", 1, "spoons")]
		rec2.instructions = "mix all ingredients and there you go!"
		rec2.isComplete = true
		self.data.append(rec1)
		self.data.append(rec2)
		// THIS END THE FAKE DATA PART

        // DONT DELETE LINES BELOW//
		
//		self.apiManager.fetchRecipesFromApi(queryParameter: nil) { (resultArr:[Recipe]) in
//			self.data = resultArr
//			OperationQueue.main.addOperation({
//				self.recipeCollectionView.reloadData()
//			})
//		}

	}
//
//    - (void)viewDidLayoutSubviews {
//    CGFloat collectionWidth = self.collectionView.frame.size.width;
//    CGFloat minItemSpace = self.collectionLayout.minimumInteritemSpacing;
//    CGFloat spaceToDraw = collectionWidth - minItemSpace;
//    //    CGFloat spaceToDraw = collectionWidth - minItemSpace*2;
//    CGSize calcItemSize = CGSizeMake(spaceToDraw/2, spaceToDraw/2);
//    self.collectionLayout.itemSize = calcItemSize;
//    [self.collectionLayout invalidateLayout];
//    }
    
    override func viewDidLayoutSubviews() {
        
        let collectionWidth = self.recipeCollectionView.frame.size.width
        let minItemSpace = self.collectionViewLayout.minimumInteritemSpacing
        let spaceToDraw = collectionWidth - minItemSpace
        let ratio = self.collectionViewLayout.itemSize.width / self.collectionViewLayout.itemSize.height
        let calcItemSize = CGSize(width: spaceToDraw/2, height: (spaceToDraw/2)*ratio)
        self.collectionViewLayout.itemSize = calcItemSize
        self.collectionViewLayout.invalidateLayout()
        
        view.layoutIfNeeded()
        
        recipeCollectionView.visibleCells.forEach { (cell: UICollectionViewCell) in
            let cell = cell as! RecipeCollectionViewCell
            cell.prepareCircle()
        }
        
        
//        CGFloat collectionWidth = self.collectionView.frame.size.width;
//            CGFloat minItemSpace = self.collectionLayout.minimumInteritemSpacing;
//            CGFloat spaceToDraw = collectionWidth - minItemSpace;
//                CGFloat spaceToDraw = collectionWidth - minItemSpace*2;
//            CGSize calcItemSize = CGSizeMake(spaceToDraw/2, spaceToDraw/2);
//            self.collectionLayout.itemSize = calcItemSize;
//            [self.collectionLayout invalidateLayout];
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
//        cell.recipeNameLabel.text = recipe.title
//        if recipe.image != nil {
//            cell.recipeImageView.image = recipe.image!
//            return cell
//
//        }
        
        // DONT DELETE LINES BELOW//
        
//		self.apiManager.fetchImageWithUrl(url: recipe.imageUrl) { (image:UIImage?) in
//			OperationQueue.main.addOperation({
//				recipe.image = image
//				cell.recipeImageView.image = image
//			})
//		}
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



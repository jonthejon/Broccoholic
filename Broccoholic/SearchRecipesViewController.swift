//
//  ViewController.swift
//  Broccoholic
//
//  Created by Jonathan Oliveira on 07/02/18.
//  Copyright © 2018 Jonathan Oliveira. All rights reserved.
//

import UIKit
import RealmSwift

class SearchRecipesViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UISearchBarDelegate {
    
    
    @IBOutlet weak var collectionViewLayout: UICollectionViewFlowLayout!
    @IBOutlet weak var bookmarkButton: UIButton!
    @IBOutlet weak var recipeCollectionView: UICollectionView!
    @IBOutlet weak var recipeSearchBar: UISearchBar!

    
    var data = [Recipe]()
	var apiManager = RecipeAPIManager()
	let realm = RealmInterface()
	var flag = false
	func updateBookmark(recipe:Recipe) {
		if recipe.isBookmarked {
			realm.saveRecipe(recipe: recipe)
		} else {
			realm.deleteRecipe(recipe: recipe)
		}
	}
    
    @IBAction func bookmarkButtonTapped(_ sender: UIBarButtonItem) {
        
    }
	
	func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
		searchBar.resignFirstResponder()
		if let query = searchBar.text {
			self.doFetchData(query: query)
		}
	}
    
    
    
	override func viewDidLoad() {
		super.viewDidLoad()
        
        recipeCollectionView.backgroundView?.backgroundColor = UIColor.clear
        self.navigationController?.navigationBar.backItem?.title = " "
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.font: UIFont(name: "Futura", size: 17)!]
        self.title = "Broccoholic"
		
		// THIS IS THE FAKE DATA INSERTION PART
//		let rec1 = Recipe(id: 1, title: "Broccoli Pasta", imageUrl: "fakeURl")
//		rec1.image = UIImage(named:"broccoli_pasta")
//		rec1.servings = 3
//		rec1.readyInMin = 20
//		rec1.ingredients = [Ingredient(name: "ingredient1", quantity: 2, unit: "cups"),
//							Ingredient(name: "ingredient2", quantity: 3, unit: "cups"),
//							Ingredient(name: "ingredient3", quantity: 6, unit: "cups"),
//							Ingredient(name: "ingredient4", quantity: 1, unit: "spoons")]
//		rec1.instructions = "mix all ingredients and there you go!"
//		rec1.isComplete = true
//		self.data.append(rec1)
//		let rec2 = Recipe(id: 2, title: "Pea & Potato Curry", imageUrl: "fakeURl")
//		rec2.image = UIImage(named:"pea_potato_curry")
//		rec2.servings = 3
//		rec2.readyInMin = 20
//		rec2.ingredients = [Ingredient(name: "ingredient1", quantity: 2, unit: "cups"),
//							Ingredient(name: "ingredient2", quantity: 3, unit: "cups"),
//							Ingredient(name: "ingredient3", quantity: 6, unit: "cups"),
//							Ingredient(name: "ingredient4", quantity: 1, unit: "spoons")]
//		rec2.instructions = "mix all ingredients and there you go!"
//		rec2.isComplete = true
//		self.data.append(rec2)
//		let rec3 = Recipe(id: 3, title: "Broccoli Salad", imageUrl: "fakeURl")
//		rec3.image = UIImage(named:"broccoli_salad")
//		rec3.servings = 3
//		rec3.readyInMin = 20
//		rec3.ingredients = [Ingredient(name: "ingredient1", quantity: 2, unit: "cups"),
//							Ingredient(name: "ingredient2", quantity: 3, unit: "cups"),
//							Ingredient(name: "ingredient3", quantity: 6, unit: "cups"),
//							Ingredient(name: "ingredient4", quantity: 1, unit: "spoons")]
//		rec3.instructions = "mix all ingredients and there you go!"
//		rec3.isComplete = true
//		self.data.append(rec3)
//		let rec4 = Recipe(id: 4, title: "Roasted Vegetables", imageUrl: "fakeURl")
//		rec4.image = UIImage(named:"roasted_vegetables")
//		rec4.servings = 3
//		rec4.readyInMin = 20
//		rec4.ingredients = [Ingredient(name: "ingredient1", quantity: 2, unit: "cups"),
//							Ingredient(name: "ingredient2", quantity: 3, unit: "cups"),
//							Ingredient(name: "ingredient3", quantity: 6, unit: "cups"),
//							Ingredient(name: "ingredient4", quantity: 1, unit: "spoons")]
//		rec4.instructions = "mix all ingredients and there you go!"
//		rec4.isComplete = true
//		self.data.append(rec4)
		// THIS END THE FAKE DATA PART

        // DONT DELETE LINES BELOW//
	
		self.doFetchData(query: nil)

	}
	
	private func doFetchData(query:String?) {
		self.apiManager.fetchRecipesFromApi(queryParameter: query) { (resultArr:[Recipe]) in
			self.data = resultArr
			OperationQueue.main.addOperation({
				self.recipeCollectionView.reloadData()
			})
		}
	}

	func updateBookmarkInData() {
		let savedIds = realm.fetchIDsOfSavedRecipes()
		for recipe in self.data {
			if savedIds.contains(recipe.id) {
				recipe.isBookmarked = true
			}
		}
		self.recipeCollectionView.reloadData()
		view.layoutIfNeeded()
	}

	var screenWidth: CGFloat = 0.0 {
		didSet {
			let collectionWidth = self.recipeCollectionView.frame.size.width
			let minItemSpace = self.collectionViewLayout.minimumInteritemSpacing
			let spaceToDraw = collectionWidth - minItemSpace
			let ratio = self.collectionViewLayout.itemSize.width / self.collectionViewLayout.itemSize.height
			let calcItemSize = CGSize(width: spaceToDraw/2, height: (spaceToDraw/2)*ratio)
			self.collectionViewLayout.itemSize = calcItemSize
			self.collectionViewLayout.invalidateLayout()
			self.updateBookmarkInData()
			view.layoutIfNeeded()
			self.recipeCollectionView.reloadData()
		}
	}
	
    override func viewDidLayoutSubviews() {
		print(#line, self.view.frame.size.width)
		print(#line, self.recipeCollectionView.bounds.width)
		if !self.flag {
			self.flag = true
			screenWidth = self.recipeCollectionView.frame.size.width
			
			
//			recipeCollectionView.visibleCells.forEach { (cell: UICollectionViewCell) in
//				let cell = cell as! RecipeCollectionViewCell
//				cell.prepareCircle()
//			}
			
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
		cell.itemSize = (self.recipeCollectionView.collectionViewLayout as! UICollectionViewFlowLayout).itemSize
//		cell.prepareCircle()
        let recipe = self.data[indexPath.item]
		
		
//		cell.recipeImageView.image = nil
//		cell.clearCell()
		
		cell.rootController = self
		if let _ = recipe.image {
			cell.recipe = recipe
			return cell
		}
		
		// DONT DELETE LINES BELOW//
		self.apiManager.fetchImageWithUrl(url: recipe.imageUrl) { (image:UIImage?) in
			OperationQueue.main.addOperation({
				recipe.image = image
				cell.recipe = recipe
//				cell.recipeImageView.image = image
			})
		}

        return cell
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if segue.identifier == "showDetail",
            let destination = segue.destination as? DetailedRecipeViewController,
            let indexPath = self.recipeCollectionView.indexPathsForSelectedItems?.last {
            destination.optRecipe = data[indexPath.item]
			destination.optApiManager = self.apiManager
        }
    }
}



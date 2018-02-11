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
	var cachedData = [Recipe]()
	var apiManager = RecipeAPIManager()
	let realm = RealmInterface()
	var flag = false
	var bookmarkflag = false
	func updateBookmark(recipe:Recipe) {
		if recipe.isBookmarked {
			realm.saveRecipe(recipe: recipe)
		} else {
			realm.deleteRecipe(recipe: recipe)
		}
	}
    
    @IBAction func bookmarkButtonTapped(_ sender: UIBarButtonItem) {
		if !self.bookmarkflag {
			self.bookmarkflag = true
			self.cachedData = data
			let savedRecipes = realm.fetchSavedRecipes()
			self.data = savedRecipes
			self.recipeCollectionView.reloadData()
		} else {
			self.bookmarkflag = false
			self.data = self.cachedData
			self.cachedData.removeAll()
			self.recipeCollectionView.reloadData()
		}
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
        self.navigationController?.navigationItem.backBarButtonItem?.title = " "
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.font: UIFont(name: "Futura", size: 17)!]
        self.title = "Broccoholic"
		
		// THIS IS THE FAKE DATA INSERTION PART
//        let rec1 = Recipe(id: 1, title: "Broccoli Pasta", imageUrl: "fakeURl")
//        rec1.image = UIImage(named:"broccoli_pasta")
//        rec1.servings = 3
//        rec1.readyInMin = 20
//        rec1.ingredients = [Ingredient(name: "ingredient1", quantity: 2, unit: "cups"),
//                            Ingredient(name: "ingredient2", quantity: 3, unit: "cups"),
//                            Ingredient(name: "ingredient3", quantity: 6, unit: "cups"),
//                            Ingredient(name: "ingredient4", quantity: 1, unit: "spoons")]
//        rec1.instructions = "mix all ingredients and there you go!"
//        rec1.isComplete = true
//
//        let instructions1 = "1. Put the potatoes in a large pot filled with cold water. Bring to a boil, reduce the heat to medium and cook until fork-tender, 35 to 40 minutes. Let the potatoes cool for 45 minutes; they will still be warm but will hold their shape when sliced into 1/4-inch-thick rounds."
//        let instructions2 = "2. Heat 1 tablespoon of the oil in a large saute pan over medium heat. Add the bacon and cook until crisp, stirring occasionally, about 10 minutes. With a slotted spoon, remove the bacon to a paper-towel-lined plate; set aside. Remove the drippings from the pan; return 3 tablespoonfuls and discard the rest."
//        let instructions3 = "3. Add the onions to the pan and sweat over medium heat until soft, about 6 minutes. Add the vinegar, mustard, sugar, 2 1/2 teaspoons salt and 1 teaspoon pepper and cook until fragrant, 1 minute more."
//        let instructions4 = "4. Add the cooled potatoes, half the cooked bacon, half the scallions, half the parsley and the remaining 2 tablespoons olive oil to the pan. Stir to combine and season with salt and pepper. Serve garnished with the remaining bacon, scallions and parsley."
//
//        rec1.detailedInstructions = [instructions1, instructions2, instructions3, instructions4]
//        self.data.append(rec1)
//
//        let rec2 = Recipe(id: 2, title: "Pea & Potato Curry", imageUrl: "fakeURl")
//        rec2.image = UIImage(named:"pea_potato_curry")
//        rec2.servings = 3
//        rec2.readyInMin = 20
//        rec2.ingredients = [Ingredient(name: "ingredient1", quantity: 2, unit: "cups"),
//                            Ingredient(name: "ingredient2", quantity: 3, unit: "cups"),
//                            Ingredient(name: "ingredient3", quantity: 6, unit: "cups"),
//                            Ingredient(name: "ingredient4", quantity: 1, unit: "spoons")]
//        rec2.instructions = "mix all ingredients and there you go!"
//        rec2.isComplete = true
//        rec2.detailedInstructions = [instructions1 + "REC2222", instructions2 + "REC2222", instructions3 + "REC2222", instructions4 + "REC2222"]
//        self.data.append(rec2)
//
//
//        let rec3 = Recipe(id: 3, title: "Broccoli Salad", imageUrl: "fakeURl")
//        rec3.image = UIImage(named:"broccoli_salad")
//        rec3.servings = 3
//        rec3.readyInMin = 20
//        rec3.ingredients = [Ingredient(name: "ingredient1", quantity: 2, unit: "cups"),
//                            Ingredient(name: "ingredient2", quantity: 3, unit: "cups"),
//                            Ingredient(name: "ingredient3", quantity: 6, unit: "cups"),
//                            Ingredient(name: "ingredient4", quantity: 1, unit: "spoons")]
//        rec3.instructions = "mix all ingredients and there you go!"
//        rec3.isComplete = true
//
//        rec3.detailedInstructions = [instructions1 + "REC3333", instructions2 + "REC3333", instructions3 + "REC3333", instructions4 + "REC3333"]
//        self.data.append(rec3)
//
//
//        let rec4 = Recipe(id: 4, title: "Roasted Vegetables", imageUrl: "fakeURl")
//        rec4.image = UIImage(named:"roasted_vegetables")
//        rec4.servings = 3
//        rec4.readyInMin = 20
//        rec4.ingredients = [Ingredient(name: "ingredient1", quantity: 2, unit: "cups"),
//                            Ingredient(name: "ingredient2", quantity: 3, unit: "cups"),
//                            Ingredient(name: "ingredient3", quantity: 6, unit: "cups"),
//                            Ingredient(name: "ingredient4", quantity: 1, unit: "spoons")]
//        rec4.instructions = "mix all ingredients and there you go!"
//
//        rec4.detailedInstructions = [instructions1 + "REC4444", instructions2 + "REC44444", instructions3 + "REC4444", instructions4 + "REC4444"]
//        rec4.isComplete = true
//        self.data.append(rec4)
//         THIS END THE FAKE DATA PART

        // DONT DELETE LINES BELOW//
	
        self.doFetchData(query: nil)

	}
	
    private func doFetchData(query:String?) {
        self.apiManager.fetchRecipesFromApi(queryParameter: query) { (resultArr:[Recipe]) in
            self.data = resultArr
            OperationQueue.main.addOperation({
                self.updateBookmarkInData()
//                self.recipeCollectionView.reloadData()
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
		if !self.flag {
			self.flag = true
			screenWidth = self.recipeCollectionView.frame.size.width
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
        let recipe = self.data[indexPath.item]
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



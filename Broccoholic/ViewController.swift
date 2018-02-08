//
//  ViewController.swift
//  Broccoholic
//
//  Created by Jonathan Oliveira on 07/02/18.
//  Copyright © 2018 Jonathan Oliveira. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
		let manager = RecipeAPIManager()
		do {
			try manager.fetchRecipesFromApi(queryParameter: nil, callback: { (recipes:[TempRecipe]) in
				for recipe in recipes {
					print("ID: \(recipe.id)")
					print("TITlE: \(recipe.title)")
					print("IMAGE: \(recipe.imageUrl)")
					print("------")
				}
//				print(recipes)
			})
		} catch let error {
			print(error)
		}
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}


}


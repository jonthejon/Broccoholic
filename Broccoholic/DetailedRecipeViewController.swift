//
//  DetailedRecipeViewController.swift
//  Broccoholic
//
//  Created by Aaron Chong on 2/7/18.
//  Copyright © 2018 Jonathan Oliveira. All rights reserved.
//

import UIKit

class DetailedRecipeViewController: UIViewController, UITableViewDataSource {
    
    @IBOutlet weak var recipeNameLabel: UILabel!
    @IBOutlet weak var recipeImageView: UIImageView!
    @IBOutlet weak var servingsLabel: UILabel!
    @IBOutlet weak var readyLabel: UILabel!
    @IBOutlet weak var directionsText: UITextView!
    
    
    @IBOutlet weak var bookmarkSwitch: UISwitch! //temp switch
    
    var dummyRecipe: DummyRecipe?

    let randomArray = ["text1", "text2", "text3"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let dummyrecipe = dummyRecipe {
            
            recipeNameLabel.text = dummyrecipe.recipeName
            print(recipeNameLabel.text!)
            recipeImageView.image = dummyrecipe.recipeImage
            
        } else {
            print("Nil")
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return randomArray.count // return array
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "detailedCell", for: indexPath) as! DetailedControllerCell
        
    
    
        return cell
    }
    
}

//
//  DummyRecipe.swift
//  Broccoholic
//
//  Created by Aaron Chong on 2/7/18.
//  Copyright © 2018 Jonathan Oliveira. All rights reserved.
//

import UIKit

class DummyRecipe: NSObject {

    var recipeName: String
    var recipeImage: UIImage
    
    init(recipeName: String, recipeImage: UIImage) {
        
        self.recipeName = recipeName
        self.recipeImage = recipeImage
    }
    
}

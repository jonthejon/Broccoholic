//
//  InstructionsViewController.swift
//  Broccoholic
//
//  Created by Aaron Chong on 2/10/18.
//  Copyright © 2018 Jonathan Oliveira. All rights reserved.
//

import UIKit

class InstructionsViewController: UIViewController, UIGestureRecognizerDelegate {

    @IBOutlet weak var instructionsTextLabel: UILabel!
    
    var instructionsArray: [String]!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        instructionsTextLabel.text = instructionsArray[0]
       
    }
    
//    @IBAction func leftSwiped(_ sender: UISwipeGestureRecognizer) {
//        
//        if instructionsArray.count == 0 {
//            instructionsTextLabel.text = instructionsArray.last!
//        } else {
//        instructionsTextLabel.text = instructionsArray.count 
//        }
//    }
    
    @IBAction func rightSwiped(_ sender: UISwipeGestureRecognizer) {
        
    }
    
    
}

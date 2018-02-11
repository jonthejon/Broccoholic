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
    var position = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        instructionsTextLabel.text = instructionsArray[position]
       
    }
    
    @IBAction func leftSwiped(_ sender: UISwipeGestureRecognizer) {
        
        print("leftSwiped")
        
        if position == instructionsArray.index(of: instructionsArray.last!)! {
            instructionsTextLabel.text = instructionsArray.first!
            position = 0
        } else {
            position += 1
        instructionsTextLabel.text = instructionsArray[position]
        }
    }
    
    @IBAction func rightSwiped(_ sender: UISwipeGestureRecognizer) {
        
        print("rightSwiped")
        
        if position == instructionsArray.index(of: instructionsArray.first!)! {
            instructionsTextLabel.text = instructionsArray.last!
            position = instructionsArray.count-1
        } else {
            position -= 1
            instructionsTextLabel.text = instructionsArray[position]
        }
        
    }
    
    
}

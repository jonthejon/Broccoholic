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
    @IBOutlet weak var instructionNumber: UILabel!
    var instructionsArray: [String]!
    var position = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        instructionsTextLabel.text = instructionsArray[position]
        self.instructionNumber.text = "Directions: \(self.position+1) / \(self.instructionsArray.count)"
       
    }
    
    @IBAction func leftSwiped(_ sender: UISwipeGestureRecognizer) {
        
        print("leftSwiped")
        if position == instructionsArray.index(of: instructionsArray.last!)! {
            
            self.instructionsTextLabel.fadeOut(completion: {
                (finished: Bool) -> Void in
                self.instructionsTextLabel.text = self.instructionsArray.first!
                self.instructionNumber.text = "Directions: \(self.position+1) / \(self.instructionsArray.count)"
                self.instructionsTextLabel.fadeIn()
            })
            position = 0
            
        } else {
            
            position += 1
            
            self.instructionsTextLabel.fadeOut(completion: {
                (finished: Bool) -> Void in
                self.instructionsTextLabel.text = self.instructionsArray[self.position]
                self.instructionNumber.text = "Directions: \(self.position+1) / \(self.instructionsArray.count)"
                self.instructionsTextLabel.fadeIn()
            })
        }
    }
    
    @IBAction func rightSwiped(_ sender: UISwipeGestureRecognizer) {
        
        print("rightSwiped")
        if position == instructionsArray.index(of: instructionsArray.first!)! {
            
            self.instructionsTextLabel.fadeOut(completion: {
                (finished: Bool) -> Void in
                self.instructionsTextLabel.text = self.instructionsArray.last!
                self.instructionNumber.text = "Directions: \(self.position+1) / \(self.instructionsArray.count)"
                self.instructionsTextLabel.fadeIn()
            })
            position = instructionsArray.count-1
            
        } else {
            
            position -= 1
            
            self.instructionsTextLabel.fadeOut(completion: {
                (finished: Bool) -> Void in
                self.instructionsTextLabel.text = self.instructionsArray[self.position]
                self.instructionNumber.text = "Directions: \(self.position+1) / \(self.instructionsArray.count)"
                self.instructionsTextLabel.fadeIn()
            })
        }
    }
}

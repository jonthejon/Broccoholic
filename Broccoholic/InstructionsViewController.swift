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
            
            UIView.animate(withDuration: 0.3, delay: 0.0, options: UIViewAnimationOptions.curveEaseOut, animations: {
                self.instructionsTextLabel.alpha = 0.0
            
            }, completion: {
                (finished: Bool) -> Void in
                
                self.instructionsTextLabel.text = self.instructionsArray.first!
                
                UIView.animate(withDuration: 0.3, delay: 0.0, options: UIViewAnimationOptions.curveEaseIn, animations: {
                    self.instructionsTextLabel.alpha = 1.0
                }, completion: nil)
            })
            
            position = 0
        } else {
            
            position += 1
            
            UIView.animate(withDuration: 0.3, delay: 0.0, options: UIViewAnimationOptions.curveEaseOut, animations: {
                self.instructionsTextLabel.alpha = 0.0
            }, completion: {
                (finished: Bool) -> Void in
        
                self.instructionsTextLabel.text = self.instructionsArray[self.position]
            
                UIView.animate(withDuration: 0.3, delay: 0.0, options: UIViewAnimationOptions.curveEaseIn, animations: {
                    self.instructionsTextLabel.alpha = 1.0
                }, completion: nil)
            
            })
        
        }
    }
    
    @IBAction func rightSwiped(_ sender: UISwipeGestureRecognizer) {
        
        print("rightSwiped")
        if position == instructionsArray.index(of: instructionsArray.first!)! {
            
            UIView.animate(withDuration: 0.3, delay: 0.0, options: UIViewAnimationOptions.curveEaseOut, animations: {
                self.instructionsTextLabel.alpha = 0.0
            }, completion: {
                (finished: Bool) -> Void in
                
            self.instructionsTextLabel.text = self.instructionsArray.last!
            
                UIView.animate(withDuration: 0.3, delay: 0.0, options: UIViewAnimationOptions.curveEaseIn, animations: {
                    self.instructionsTextLabel.alpha = 1.0
                }, completion: nil)
            })
            
            position = instructionsArray.count-1
        } else {
            
            position -= 1
            
            UIView.animate(withDuration: 0.3, delay: 0.0, options: UIViewAnimationOptions.curveEaseOut, animations: {
                self.instructionsTextLabel.alpha = 0.0
            }, completion: {
                (finished: Bool) -> Void in
                
                self.instructionsTextLabel.text = self.instructionsArray[self.position]
                
                UIView.animate(withDuration: 0.3, delay: 0.0, options: UIViewAnimationOptions.curveEaseIn, animations: {
                    self.instructionsTextLabel.alpha = 1.0
                }, completion: nil)
            })
        }
    }
    
    
    
}

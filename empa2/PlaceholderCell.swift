//
//  PlaceholderCell.swift
//  TRModularCameraView
//
//  Created by Tyler Angert on 12/23/16.
//  Copyright © 2016 Tyler Angert. All rights reserved.
//

import Foundation
import UIKit

class PlaceholderCell : UICollectionViewCell {
    
    @IBOutlet weak var placeholderImage: UIImageView!
    @IBOutlet weak var buttonStackView: UIStackView!
    @IBOutlet weak var sadButton: UIButton!
    @IBOutlet weak var happyButton: UIButton!
    @IBOutlet weak var angryButton: UIButton!
    @IBOutlet weak var surpriseButton: UIButton!
    
    let blue = UIColor(red: 114/255, green: 226/255, blue: 255/255, alpha: 1.0)
    
    override func awakeFromNib() {
        
        sadButton.tag = 1
        happyButton.tag = 2
        angryButton.tag = 3
        surpriseButton.tag = 4
        
        //Text alignment
        sadButton.titleLabel?.textAlignment = .center
        happyButton.titleLabel?.textAlignment = .center
        angryButton.titleLabel?.textAlignment = .center
        surpriseButton.titleLabel?.textAlignment = .center

        //Border width and color
        sadButton.layer.borderColor = blue.cgColor
        sadButton.layer.borderWidth = 1
        
        happyButton.layer.borderColor = blue.cgColor
        happyButton.layer.borderWidth = 1
        
        angryButton.layer.borderColor = blue.cgColor
        angryButton.layer.borderWidth = 1
        
        surpriseButton.layer.borderColor = blue.cgColor
        surpriseButton.layer.borderWidth = 1
        
        //Corner radius
        sadButton.layer.cornerRadius = sadButton.layer.frame.width/2
        happyButton.layer.cornerRadius = happyButton.layer.frame.width/2
        angryButton.layer.cornerRadius = angryButton.layer.frame.width/2
        surpriseButton.layer.cornerRadius = surpriseButton.layer.frame.width/2
    }
    
    var buttonIsPressed = false
    var currentTag = 0
    var previousTag = 0
    
    @IBAction func buttonPress(_ sender: Any) {
        
        if buttonIsPressed == false {
            UIView.animate(withDuration: 0.15) {
                (sender as! UIButton).backgroundColor = self.blue
            }
            
            buttonIsPressed = true
        } else {
            UIView.animate(withDuration: 0.15) {
                (sender as! UIButton).backgroundColor = nil
            }
            buttonIsPressed = false
        }
        
        previousTag = currentTag
        currentTag = (sender as! UIButton).tag
        
    }
}

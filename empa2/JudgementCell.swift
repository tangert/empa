//
//  PlaceholderCell.swift
//  TRModularCameraView
//
//  Created by Tyler Angert on 12/23/16.
//  Copyright © 2016 Tyler Angert. All rights reserved.
//

import Foundation
import UIKit

protocol JudgementTaskDelegate {
    func didJudgeImage(tag: Int, value: Float)
    func didPressNext()
}

class JudgementCell : UICollectionViewCell {
    
    var isLast = false
    var sliderMoved = false
    let origImage = UIImage(named: "next")
    var tintedImage: UIImage!
    
    override func awakeFromNib() {
        tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
        
        if (isLast) {
            print("this button is last")
            self.nextButton.isEnabled = false
            self.nextButton.isHidden = true
        }
    }
    
    @IBOutlet weak var sliderContainer: UIView! {
        didSet {
            sliderContainer.layer.cornerRadius = 10
            sliderContainer.clipsToBounds = true
            sliderContainer.dropShadow(radius: 10)
        }
    }
    
    @IBOutlet weak var slider: UISlider! {
        didSet {
            slider.isContinuous = false
        }
    }
    
    @IBOutlet weak var placeholderImage: UIImageView! {
        didSet {
            placeholderImage.layer.cornerRadius = 10
            placeholderImage.clipsToBounds = true
        }
    }
    
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var sadButton: UIButton! {
        didSet {
            sadButton.tag = 1
            sadButton.titleLabel?.textAlignment = .center
            sadButton.layer.cornerRadius = sadButton.layer.frame.width/2
        }
    }
    @IBOutlet weak var happyButton: UIButton! {
        didSet {
            happyButton.tag = 2
            happyButton.titleLabel?.textAlignment = .center
            happyButton.layer.cornerRadius = happyButton.layer.frame.width/2
        }
    }
    
    //FIXME:
    var delegate: JudgementTaskDelegate?
    
    @IBAction func pressNext(_ sender: Any) {
        delegate?.didPressNext()
    }
    
    @IBAction func sliderChanged(_ sender: UISlider) {
        print("VALUE: \(sender.value)")
        delegate?.didJudgeImage(tag: self.tag, value: sender.value)
    }
}

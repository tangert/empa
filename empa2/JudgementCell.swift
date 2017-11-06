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
}

class JudgementCell : UICollectionViewCell {
        
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var placeholderImage: UIImageView!
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
    
    override func awakeFromNib() {

    }
    
    @IBAction func sliderChanged(_ sender: UISlider) {
        delegate?.didJudgeImage(tag: self.tag, value: sender.value)
    }
}

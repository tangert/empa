//
//  CameraViewCell.swift
//  TRModularCameraView
//
//  Created by Tyler Angert on 10/6/16.
//  Copyright © 2016 Tyler Angert. All rights reserved.
//

import Foundation
import AVFoundation
import UIKit
import Affdex

class CameraViewCell: UICollectionViewCell {
        
    @IBOutlet weak var cameraView: FrontCameraView!
    @IBOutlet weak var emojiLabel: UILabel!
    @IBOutlet weak var faceShownLabel: UILabel!
    
    override func awakeFromNib() {
        SessionViewController.cameraDelegate = self
    }
    
}

extension CameraViewCell: UpdateCameraFeedDelegate {
    
    func willUpdateCameraFeed(image: UIImage) {
        cameraView.image = image
    }
    
    func willUpdateEmojiLabel(input: String) {
        emojiLabel.text = "Emoji: \(input)"
    }
    
    func willUpdateFaceLabel(input: String) {
        faceShownLabel.text = input
    }
}

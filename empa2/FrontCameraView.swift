//
//  FrontCameraView.swift
//  TRModularCameraView
//
//  Created by Tyler Angert on 12/23/16.
//  Copyright © 2016 Tyler Angert. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation
import Affdex

class FrontCameraView: UIImageView, UIGestureRecognizerDelegate {
    
    var placeHolderLayer = CALayer()
    var feedIsActive = false
    var videoDeviceInput: AVCaptureDeviceInput!
    static var scoreDelegate: UpdateScoreDelegate?
    
    override func awakeFromNib() {
        self.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        tap.delegate = self
        self.addGestureRecognizer(tap)
        self.layer.addSublayer(placeHolderLayer)
        
        SessionViewController.nibInstanceDelegate = self
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        placeHolderLayer.frame = self.bounds
        placeHolderLayer.backgroundColor = UIColor.red.cgColor
    }
    
    func handleTap(_ sender: UITapGestureRecognizer) {
        if feedIsActive == false {
            FrontCameraView.scoreDelegate?.scoreDidChange(direction: "up")
            self.placeHolderLayer.removeFromSuperlayer()
            feedIsActive = true
            
        } else {
            FrontCameraView.scoreDelegate?.scoreDidChange(direction: "down")
            
            self.layer.addSublayer(placeHolderLayer)
            feedIsActive = false
        }
    }
}

extension FrontCameraView: LoadNibInstanceDelegate {
    func nibInstanceDidLoad() {
        if feedIsActive {
            self.layer.addSublayer(placeHolderLayer)
            feedIsActive = false
        }
    }
}

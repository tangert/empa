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
    
    override func awakeFromNib() {
        self.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        tap.delegate = self
        self.addGestureRecognizer(tap)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        placeHolderLayer.frame = self.bounds
        placeHolderLayer.backgroundColor = UIColor.red.cgColor
    }
    
    func handleTap(_ sender: UITapGestureRecognizer) {
        if feedIsActive == false {
            self.layer.addSublayer(placeHolderLayer)
            feedIsActive = true
        } else {
            self.placeHolderLayer.removeFromSuperlayer()
            feedIsActive = false
        }
    }
}

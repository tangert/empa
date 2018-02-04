//
//  CameraViewCell.swift
//  TRModularCameraView
//
//  Created by Tyler Angert on 12/23/16.
//  Copyright © 2016 Tyler Angert. All rights reserved.
//

import Foundation
import AVFoundation
import UIKit
import Affdex

protocol PrimingCellDelegate {
    func didFinishPriming()
}

class CameraViewCell: UICollectionViewCell {
    
    var delegate: PrimingCellDelegate?
    
    @IBOutlet weak var cameraView: FrontCameraView! {
        didSet {
            cameraView.layer.cornerRadius = 10
            cameraView.clipsToBounds = true
        }
    }
    
    @IBOutlet weak var sliderContainer: UIVisualEffectView! {
        didSet {
            sliderContainer.layer.cornerRadius = 10
            sliderContainer.clipsToBounds = true
        }
    }
    
    @IBOutlet weak var emojiLabel: UILabel!
    @IBOutlet weak var progressView: UIProgressView! {
        didSet {
            progressView.dropShadow(radius: 10)
        }
    }
    
    var currentProgressScore: Float = 0

    override func awakeFromNib() {
        SessionViewController.cameraDelegate = self
        progressView.progressTintColor = EMPA_BLUE
        progressView.trackTintColor = UIColor.white
    }
    
    
}

extension CameraViewCell: UpdateCameraFeedDelegate {
    
    func willUpdateProgress(type: subjectType, data: [String : AnyObject]) {
    
        guard !SessionViewController.primingProgressIsFinished else { return }
        
            if type == .happy {
                
                guard let joyData = (data["joy"] as? NSString)?.doubleValue else {
                    return
                }
                
                guard let valenceData = (data["valence"] as? NSString)?.doubleValue else {
                    return
                }
                
                let maxJoyData = max(joyData, valenceData)
                
                currentProgressScore = Float(joyData/100)
                
            } else {
                
                guard let sadnessData = (data["sadness"] as? NSString)?.doubleValue else {
                    return
                }
                
                guard let valenceData = (data["valence"] as? NSString)?.doubleValue else {
                    return
                }
                
                currentProgressScore = Float((sadnessData + (0.25*valenceData))/100)
                
            }
            
            progressView.setProgress(currentProgressScore*1.5, animated: true)
            
            if(progressView.progress == 1.0) {
                print("finished!")
                
                SessionViewController.primingProgressIsFinished = true
                
                self.delegate?.didFinishPriming()
                
                UIView.animate(withDuration: 0.2, animations: {
                    self.sliderContainer.backgroundColor = UIColor.green.withAlphaComponent(0.3)
                    self.progressView.progressTintColor = UIColor.green.withAlphaComponent(0.6)
                })
            }
        
    }
    
    func willUpdateCameraFeed(image: UIImage) {
        cameraView.image = image
    }
    
}

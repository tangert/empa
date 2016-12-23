//
//  FrontCameraView.swift
//  TRModularCameraView
//
//  Created by Tyler Angert on 10/10/16.
//  Copyright © 2016 Tyler Angert. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

class FrontCameraView: UIImageView, UIGestureRecognizerDelegate {
    
    var previewLayer: AVCaptureVideoPreviewLayer?
    var placeHolderLayer = CALayer()
    var feedIsActive = false
    var videoDeviceInput: AVCaptureDeviceInput!
    static var session: AVCaptureSession?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupPreviewLayer()
        
        self.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        tap.delegate = self
        self.addGestureRecognizer(tap)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupPreviewLayer()
        
        self.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        tap.delegate = self
        self.addGestureRecognizer(tap)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        previewLayer?.frame = self.bounds
        placeHolderLayer.frame = self.bounds
        placeHolderLayer.backgroundColor = UIColor.red.cgColor
        
        if let connection = self.previewLayer?.connection {
            if connection.isVideoOrientationSupported {
                switch UIApplication.shared.statusBarOrientation {
                case .landscapeLeft:
                    connection.videoOrientation = .landscapeLeft
                case .landscapeRight:
                    connection.videoOrientation = .landscapeRight
                case .portraitUpsideDown:
                    connection.videoOrientation = .portraitUpsideDown
                default:
                    connection.videoOrientation = .portrait
                }
            }
        }
    }
    
    func setupPreviewLayer() {
        
        FrontCameraView.session = AVCaptureSession()
        FrontCameraView.session?.sessionPreset = AVCaptureSessionPresetPhoto
        
        guard let frontCamera = AVCaptureDeviceDiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: AVMediaTypeVideo, position: .front).devices.first else { return }
        
        var error: NSError?
        var input: AVCaptureDeviceInput!
        do {
            input = try AVCaptureDeviceInput(device: frontCamera)
        } catch let error1 as NSError {
            error = error1
            input = nil
            print("Error: \(error!.localizedDescription)")
        }
        
        if error == nil && (FrontCameraView.session?.canAddInput(input))! {
            FrontCameraView.session?.addInput(input)
        }
        
        previewLayer = AVCaptureVideoPreviewLayer(session: FrontCameraView.session)
        previewLayer!.videoGravity = AVLayerVideoGravityResizeAspect
        previewLayer!.connection?.videoOrientation = AVCaptureVideoOrientation.portrait
        
        previewLayer!.frame = self.bounds
        self.layer.addSublayer(previewLayer!)
    }
    
    func handleTap(_ sender: UITapGestureRecognizer) {
        
        if feedIsActive == false {
            self.layer.replaceSublayer(previewLayer!, with: placeHolderLayer)
            feedIsActive = true
        } else {
            self.layer.replaceSublayer(placeHolderLayer, with: previewLayer!)
            feedIsActive = false
        }
    }


}

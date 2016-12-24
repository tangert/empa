//
//  ViewController.swift
//  TRModularCameraView
//
//  Created by Tyler Angert on 10/6/16.
//  Copyright © 2016 Tyler Angert. All rights reserved.
//

import UIKit
import Foundation
import Affdex

protocol UpdateCameraFeedDelegate {
    func willUpdateCameraFeed(image: UIImage)
    func willUpdateEmojiLabel(input: String)
    func willUpdateFaceLabel(input: String)
}

class ViewController: UIViewController {
    
    var images = [UIImage]()
    var placeholderCellNib: UINib? = UINib(nibName: "PlaceholderCell", bundle:nil)
    var cameraViewNib: UINib? = UINib(nibName: "CameraViewCell", bundle: nil)
    
    var detector: AFDXDetector? = nil
    var processedImage = UIImage()
    var unprocessedImage = UIImage()
    static var cameraDelegate: UpdateCameraFeedDelegate?
    
    @IBOutlet weak var collectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
        print("Hi! We're working!")
        
        for i in 0...24 {
            //only 6 sample images, so mod 6 to produce 12
            images.append(UIImage(named: "\((i%6)+1)")!)
        }
        
        detector?.delegate = self
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isPagingEnabled = true
        
        //registering nibs
        collectionView.register(placeholderCellNib, forCellWithReuseIdentifier: "placeholderCell")
        collectionView.register(cameraViewNib, forCellWithReuseIdentifier: "cameraViewCell")
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        createDetector()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        destroyDetector()
    }
}

extension ViewController: AFDXDetectorDelegate {
    
    //Affdex delegate methods!
    func detector(_ detector: AFDXDetector!, didStartDetecting face: AFDXFace!) {
        print("Face shown!")
        ViewController.cameraDelegate?.willUpdateFaceLabel(input: "Face shown!")
    }
    
    func detector(_ detector: AFDXDetector!, didStopDetecting face: AFDXFace!) {
        print("Show your face, idiot.")
        ViewController.cameraDelegate?.willUpdateFaceLabel(input: "NO FACE!!!")
    }
    
    func detector(_ detector: AFDXDetector!, hasResults: NSMutableDictionary!, for image: UIImage!, atTime time: TimeInterval) {
        
        if hasResults != nil {
            for (_, face) in hasResults! {
                let currentEmoji : AFDXEmoji = (face as AnyObject).emojis
                let mappedEmoji = mapEmoji(emoji: currentEmoji.dominantEmoji)
                print("Your emoji: \(mappedEmoji)")
                unprocessedImageReady(detector, image: image, atTime: time)
                ViewController.cameraDelegate?.willUpdateEmojiLabel(input: mappedEmoji)
            }
        } else {
            //call to fill in frames when a face isn't detected completely.
            unprocessedImageReady(detector, image: image, atTime: time)
            
        }
    }
    
    //helper functions
    func unprocessedImageReady(_ detector: AFDXDetector, image: UIImage, atTime time: TimeInterval) {
            DispatchQueue.main.async(execute: {() -> Void in
            self.unprocessedImage = UIImage(cgImage: image.cgImage!, scale: image.scale, orientation: UIImageOrientation.upMirrored)
            self.processedImageReady(image: self.unprocessedImage)
        })
    }
    
    func processedImageReady(image: UIImage) {
        ViewController.cameraDelegate?.willUpdateCameraFeed(image: image)
    }
    
    func destroyDetector() {
        detector?.stop()
    }
    
    func createDetector() {
        destroyDetector()
        
        guard let frontCamera = AVCaptureDeviceDiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: AVMediaTypeVideo, position: .front).devices.first else {
            
            print("No front camera.")
            let alert = UIAlertController(title: "No front camera.", message: "Sorry about that.", preferredStyle: .alert)
            self.present(alert, animated: true, completion: {() -> Void in
            })

            return
        }
        
        detector = AFDXDetector(delegate: self, using: frontCamera, maximumFaces: 1)
        detector?.maxProcessRate = 10
        
        // turn on all classifiers (emotions, expressions, and emojis)
        detector?.setDetectAllEmotions(true)
        detector?.setDetectAllExpressions(true)
        detector?.setDetectEmojis(true)
        
        // turn on gender and glasses
        detector?.gender = true
        detector?.glasses = true
        
        // start the detector and check for failure
        let error = detector?.start()
        if nil != error {
            let alert = UIAlertController(title: "Detector Error", message: error?.localizedDescription, preferredStyle: .alert)
            self.present(alert, animated: true, completion: {() -> Void in
            })
            return
        }
    }
    
    func mapEmoji(emoji : Emoji) -> String {
        switch emoji {
        case AFDX_EMOJI_RAGE:
            return "😡"
        case AFDX_EMOJI_WINK:
            return "😉"
        case AFDX_EMOJI_SMIRK:
            return "😏"
        case AFDX_EMOJI_SCREAM:
            return "😱"
        case AFDX_EMOJI_SMILEY:
            return "😀"
        case AFDX_EMOJI_FLUSHED:
            return "😳"
        case AFDX_EMOJI_KISSING:
            return "😗"
        case AFDX_EMOJI_STUCK_OUT_TONGUE:
            return "😛"
        case AFDX_EMOJI_STUCK_OUT_TONGUE_WINKING_EYE:
            return "😜"
        case AFDX_EMOJI_RELAXED:
            return "☺️"
        case AFDX_EMOJI_LAUGHING:
            return "😆"
        case AFDX_EMOJI_DISAPPOINTED:
            return "😞"
        default:
            return "😶"
        }
    }
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    private func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView,
                                 numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                                 cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        //every 4th cell except the first one, it shows a camera view as an emotional "checkpoint"
        if (indexPath.row % 4 == 0 && indexPath.row != 0) {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cameraViewCell", for: indexPath) as! CameraViewCell
            cell.layer.cornerRadius = 10
            return cell
            
        } else {
            //placeholder cells
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "placeholderCell", for: indexPath) as! PlaceholderCell
            cell.placeholderImage.image = images[indexPath.row]
            cell.layer.cornerRadius = 10
            return cell
        }
    }
}

extension ViewController: UICollectionViewDelegateFlowLayout {
    
    //formatting the cells to be centered
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 40
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: collectionView.frame.size.width-40, height: collectionView.frame.size.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(0, 20, 0, 20)
    }
    
}

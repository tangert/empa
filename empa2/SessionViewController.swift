//
//  ViewController.swift
//  TRModularCameraView
//
//  Created by Tyler Angert on 12/23/16.
//  Copyright © 2016 Tyler Angert. All rights reserved.
//

import UIKit
import Foundation
import Affdex

class SessionViewController: UIViewController {
    
    var images = [UIImage]()
    var placeholderCellNib: UINib? = UINib(nibName: "PlaceholderCell", bundle:nil)
    var cameraViewNib: UINib? = UINib(nibName: "CameraViewCell", bundle: nil)
    
    var timer: Timer!
    
    var detector: AFDXDetector? = nil
    var processedImage = UIImage()
    var unprocessedImage = UIImage()
    static var cameraDelegate: UpdateCameraFeedDelegate?
    static var dataManagerDelegate: DataManagerDelegate?
    
    var counter = 0.0
    var roundedCounter = 0.0
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var exportDataButton: UIButton!
    
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Hi! We're working!")
        for i in 0...24 {
            images.append(UIImage(named: "\((i%6)+1)")!)
        }
        
        exportDataButton.layer.cornerRadius = 20
        exportDataButton.layer.borderWidth = 1
        exportDataButton.layer.borderColor = UIColor.darkGray.cgColor
        
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
    
    func updateCounter() {
        counter+=0.1
        roundedCounter = counter.firstDecimal()
        print("Session time: \(roundedCounter)")
        timerLabel.text = "Session time: \(roundedCounter)"
        SessionViewController.dataManagerDelegate?.didUpdateTimer(counter: roundedCounter)
    }
    
    @IBAction func exportData(_ sender: Any) {
        
    guard DataManager.sharedInstance.timeData.count != 0 else {
        
            let alert = UIAlertController(title: "No data yet.", message: "Please give us something.", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
            alert.addAction(cancelAction)
            self.present(alert, animated: true, completion: nil)
            return
        }
            
    SessionViewController.dataManagerDelegate?.didExportData()
        timer.invalidate()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "exportData" {
        
        print("Export data segue")
        GraphDataSource.sharedInstance.chartDictionary = DataManager.sharedInstance.chartDictionary
        GraphDataSource.sharedInstance.chartArray = DataManager.sharedInstance.chartArray
        } else {
            
        let alert = UIAlertController(title: "No available segue.", message: "Please give us something.", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
                alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
                
        }
        
    }
}

extension SessionViewController: AFDXDetectorDelegate {
    
    //Affdex delegate methods!
    func detector(_ detector: AFDXDetector!, didStartDetecting face: AFDXFace!) {
        self.timer = Timer.scheduledTimer(timeInterval: 0.1, target:self, selector: #selector(SessionViewController.updateCounter), userInfo: nil, repeats: true)
        print("Face shown!")
        
        //keeps the timer running even during scrolling.
        RunLoop.main.add(timer, forMode: RunLoopMode.commonModes)
        SessionViewController.cameraDelegate?.willUpdateFaceLabel(input: "Face shown!")
    }
    
    func detector(_ detector: AFDXDetector!, didStopDetecting face: AFDXFace!) {
        timer.invalidate()
        print("Show your face, idiot.")
        SessionViewController.cameraDelegate?.willUpdateFaceLabel(input: "NO FACE!!!")
    }
    
    func detector(_ detector: AFDXDetector!, hasResults: NSMutableDictionary!, for image: UIImage!, atTime time: TimeInterval) {
        
        if hasResults != nil {
            for (_, face) in hasResults! {
                
                let output = face as AnyObject
                
//                //time data
//                DataManager.sharedInstance.timeData.append(self.counter)
                
                //Initial emoji data
                let currentEmoji : AFDXEmoji = output.emojis
                let mappedEmoji = mapEmoji(emoji: currentEmoji.dominantEmoji)
                print("Your emoji: \(mappedEmoji)")
                
                //Raw emotion data as a dictionary, [String: Double]
                let emotions = output.emotions!.jsonDescription()
                if let range = emotions!.range(of: "\"emotions\": ") {
                    let json = emotions!.substring(from: range.upperBound)
                    let jsonArray = json.convertToDictionary()
                    DataManager.sharedInstance.emotionData.append(jsonArray!)
                }
                
                unprocessedImageReady(detector, image: image, atTime: time)
                SessionViewController.cameraDelegate?.willUpdateEmojiLabel(input: mappedEmoji)
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
        SessionViewController.cameraDelegate?.willUpdateCameraFeed(image: image)
    }
    
    func destroyDetector() {
        detector?.stop()
    }
    
    func createDetector() {
        destroyDetector()
        
        guard let frontCamera = AVCaptureDeviceDiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: AVMediaTypeVideo, position: .front).devices.first else {
            
            print("No front camera.")
            let alert = UIAlertController(title: "No front camera.", message: "Sorry about that.", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
            alert.addAction(cancelAction)
            self.present(alert, animated: true, completion: nil)

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

extension SessionViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
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

extension SessionViewController: UICollectionViewDelegateFlowLayout {
    
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

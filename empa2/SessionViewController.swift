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
import Firebase
import FirebaseStorage
//import FirebaseStorageUI

class SessionViewController: UIViewController {
    
    //TEST SUBJECT
    var testSubject: TestSubject?
    var subjectType: subjectType!
    
    var images = [UIImage]()
    var imageReferences = [StorageReference]()
    
    var judgementCellNib: UINib? = UINib(nibName: "JudgementCell", bundle:nil)
    var cameraViewNib: UINib? = UINib(nibName: "CameraViewCell", bundle: nil)
    
    // MARK : Global Timer Variables.
    //Total session timer
    var sessionTimer: Timer!
    static var timerIsRunning = false
    static var instructionsPassed = false

    
    //Priming progress
    static var primingProgressIsFinished: Bool!

    var detector: AFDXDetector? = nil
    var processedImage = UIImage()
    var unprocessedImage = UIImage()
    
    //Delegates
    static var cameraDelegate: UpdateCameraFeedDelegate?
    static var dataManagerDelegate: DataManagerDelegate?
    static var nibInstanceDelegate: LoadNibInstanceDelegate?
    
    var score = 0
    var counter = 0.0
    var roundedCounter = 0.0
    var currentIndex = 0
    
    @IBOutlet weak var faceShownLabel: UILabel! {
        didSet {
            faceShownLabel.layer.cornerRadius = 10
            faceShownLabel.clipsToBounds = true
        }
    }
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("SESSION TEST SUBJECT: \(self.testSubject!)")
        
        
        //FIXME: Connect to Firebase bucket and load images instead of locally
        let storageRef = DataManager.sharedInstance.storage.reference()
        
        //Clear all before starting a new session
        DataManager.sharedInstance.clearAllData()
        
        for i in 1...7 {
            let currentImage = storageRef.child("judgement-images/\(i).jpg")
            imageReferences.append(currentImage)
            images.append(UIImage(named: "\(i)")!)
        }
        
        guard let testSubject = testSubject else {
            return
        }
        
        DataManager.sharedInstance.currentUserID = testSubject.id
        subjectType = self.testSubject?.testGroup.subjectType()
        DataManager.sharedInstance.didRecordPrimingTestSubject(testGroup: testSubject.testGroup)
        
        SessionViewController.primingProgressIsFinished = false
        
        detector?.delegate = self
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isPagingEnabled = true
        
        if subjectType != .control {
            collectionView.isScrollEnabled = false
        }
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        collectionView.collectionViewLayout = layout
        
        //registering nibs
        collectionView.register(judgementCellNib, forCellWithReuseIdentifier: "judgementCell")
        collectionView.register(cameraViewNib, forCellWithReuseIdentifier: "cameraViewCell")
        
        
        var message: String!
        
        if subjectType == .control {
            message = "Rate the pictures you see from happy to sad using the slider. Swipe down to get to the next slide!"
        } else {
            message = "1. Try to match the emoji you see on the screen with your own face. \n\n 2. Rate the pictures you see from happy to sad using the slider. Swipe down to get to the next slide!"
        }
        
        
        //initial alert view
        let alert = UIAlertController(title: "Instructions", message: message, preferredStyle: .alert)
        
        let ok = UIAlertAction(title: "Let's go!", style: .default) { (alert) in
            //Start detector on ok
            DataManager.sharedInstance.startDateTime = Date()
            SessionViewController.instructionsPassed = true
        }
        
        alert.addAction(ok)
        self.present(alert, animated: true, completion: nil)
        
        faceShownLabel.textColor = UIColor.white

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.createDetector()

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if let detector = detector {
            if detector.isRunning {
                destroyDetector()
            }
        }
        
        
        if SessionViewController.timerIsRunning {
            sessionTimer.invalidate()
        }
    }
    
    
    func updateCounter() {
        counter+=0.1
        roundedCounter = Double(String(format: "%0.1f", counter))!
        DataManager.sharedInstance.didUpdateTime(time: roundedCounter)
    }
}

extension SessionViewController: AFDXDetectorDelegate {
    
    func detector(_ detector: AFDXDetector!, didStartDetecting face: AFDXFace!) {
        self.sessionTimer = Timer.scheduledTimer(timeInterval: 0.1, target:self, selector: #selector(SessionViewController.updateCounter), userInfo: nil, repeats: true)
        
        if(!SessionViewController.timerIsRunning && SessionViewController.instructionsPassed) {
            SessionViewController.timerIsRunning = true
        }
        
        //keeps the timer running even during scrolling.
        RunLoop.main.add(sessionTimer, forMode: RunLoopMode.commonModes)
        
        if (!collectionView.isScrollEnabled) {
            collectionView.isScrollEnabled = true
        }
        
        
        
        UIView.animate(withDuration: 0.5, animations: {
            self.faceShownLabel.backgroundColor = SUCCESS_GREEN
            self.faceShownLabel.text = "Face shown!"
        }) { (bool) in
            
            UIView.animate(withDuration: 1, animations: {
                self.faceShownLabel.layer.opacity = 0
            })
            
        }
    }
    
    func detector(_ detector: AFDXDetector!, didStopDetecting face: AFDXFace!) {
        
        SessionViewController.timerIsRunning = false
        
        UIView.animate(withDuration: 0.5) {
            self.faceShownLabel.layer.opacity = 1
            self.faceShownLabel.backgroundColor = FAILURE_RED
            self.faceShownLabel.text = "Face not shown"
        }
        
        sessionTimer.invalidate()
        collectionView.isScrollEnabled = false
        
    }
    
    func detector(_ detector: AFDXDetector!, hasResults: NSMutableDictionary!, for image: UIImage!, atTime time: TimeInterval) {
        
        if hasResults != nil {
            for (_, face) in hasResults! {
                
                let output = face as AnyObject
                
                //Initial emoji data
                let currentEmoji : AFDXEmoji = output.emojis
                let mappedEmoji = mapEmoji(emoji: currentEmoji.dominantEmoji)
                let expressions = output.expressions!.jsonDescription()
                
                //Raw emotion data as a dictionary, [String: Double]
                let emotions = output.emotions!.jsonDescription()
                
                if let range = emotions!.range(of: "\"emotions\": ") {
                    let json = emotions!.substring(from: range.upperBound)
                    let jsonArray = json.convertToDictionary()
                    
                    DataManager.sharedInstance.didUpdateFacialData(data: jsonArray!, time: self.roundedCounter)
                    
                    // if progress is already met
                    if(!SessionViewController.primingProgressIsFinished) {
                        
                        if (SessionViewController.instructionsPassed) {
                            SessionViewController.cameraDelegate?.willUpdateProgress(type: self.subjectType, data: jsonArray!)
                        }
                    }
                    
                }
                
                unprocessedImageReady(detector, image: image, atTime: time)
                
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
        detector?.maxProcessRate = 30
        
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
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    // MARK : Timing methods
    //create a helper function that takes in the indexPath and the
    //testSubject's test group and determines if the given cell is a checkpoint or judgement.
    
    func mapTestgroupToType(testGroup: Int) -> subjectType {
        
        var type: subjectType!
        
        switch(testGroup) {
        case 0:
            type = .control
        case 1:
            type = .happy
        case 2:
            type = .sad
        default:
            type = .control
        }
        
        return type
    }
   

    //This is where all of the time data is actually recorded
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {

        guard let testSubject = self.testSubject else {
            return
        }
        
        currentIndex = indexPath.row

        if subjectType == .control {
            DataManager.sharedInstance.didRecordSlideTimestamp(tag: indexPath.row, time: self.roundedCounter)
        }

        else {
            if (indexPath.row == 0) {
                DataManager.sharedInstance.didRecordPrimingTimestamp(tag: indexPath.row, time: self.roundedCounter)
            } else {
                DataManager.sharedInstance.didRecordSlideTimestamp(tag: indexPath.row, time: self.roundedCounter)
            }
        }

    }
    
    func collectionView(_ collectionView: UICollectionView,
                                 cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        // MARK : Control subject
        if subjectType == .control {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "judgementCell", for: indexPath) as! JudgementCell

            cell.tag = indexPath.row
            cell.placeholderImage.image = images[indexPath.row]
            cell.slider.setValue(50, animated: false)
            cell.delegate = self
            
            return cell

        }
            
        // MARK : Experimental subject
        else {
            
            //Setting up the first cell
            if (indexPath.row == 0) {
                
                    SessionViewController.nibInstanceDelegate?.nibInstanceDidLoad()
                    
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cameraViewCell", for: indexPath) as! CameraViewCell
                    cell.layer.cornerRadius = 10
                    cell.tag = indexPath.row
                    cell.delegate = self
                
                    //Happy subject
                    if(subjectType == .happy) {
                        cell.emojiLabel.text = "😊"
                    } else {
                        cell.emojiLabel.text = "😞"
                    }
                    
                    return cell
            }
                
         else {
                
                //Future firebase stuff
                
                //Grabbing the image from the bucket
                //cell.placeholderImage.sd_setImage(with: imageReferences[indexPath.row], placeholderImage: placeholderImage)
                
                //Placing
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "judgementCell", for: indexPath) as! JudgementCell
                
                cell.tag = indexPath.row
                cell.placeholderImage.image = images[indexPath.row]
                cell.slider.setValue(50, animated: false)
                cell.delegate = self
                
                if (indexPath.row == self.images.count-1) {
                    cell.nextButton.isHidden = true
                }

                guard DataManager.sharedInstance.slideVisitTimestamps["\(cell.tag)"] == nil else {
                    return cell
                }
                
                return cell
                
            }
        }

    }
}

extension SessionViewController: JudgementTaskDelegate {
    
    func didPressNext() {
        
        //for some reason visibility is one index path advanced
        guard self.currentIndex != self.images.count-1 else {
            return
        }
        
        guard SessionViewController.timerIsRunning else {
            return
        }
        
        //Go to the next item in the collection view
        let next: IndexPath = IndexPath.init(item: self.currentIndex+1, section: 0)
        self.collectionView.scrollToItem(at: next, at: UICollectionViewScrollPosition.bottom, animated: true)
    
    }
    
    func didJudgeImage(tag: Int, value: Float) {
        
        DataManager.sharedInstance.didJudgeImage(tag: tag, value: value, counter: self.roundedCounter)
        
    }
    
}

extension SessionViewController: PrimingCellDelegate {
    
    func didFinishPriming() {
        
        DataManager.sharedInstance.didFinishPriming(time: self.roundedCounter)
        collectionView.isScrollEnabled = true
        
        //Showing the user success
        UIView.animate(withDuration: 0.5, animations: {
            self.faceShownLabel.layer.opacity = 1
            self.faceShownLabel.text = "Great job!"
            self.faceShownLabel.backgroundColor = SUCCESS_GREEN
        }) { (bool) in
            
            //Automatically scrolling to the judgement
            setTimeout(1, block: {
                
                UIView.animate(withDuration: 0.5, animations: {
                    self.faceShownLabel.layer.opacity = 0
                    
                }, completion: { (bool) in
                    
                    //for some reason visibility is one index path advanced
                    let second: IndexPath = IndexPath.init(item: 1, section: 0)
                    self.collectionView.scrollToItem(at: second, at: UICollectionViewScrollPosition.bottom, animated: true)
                    
                })
            })
        }
    }
}
extension SessionViewController: UICollectionViewDelegateFlowLayout {
    
    //formatting the cells to be centered
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 40
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: collectionView.frame.size.width-20, height: collectionView.frame.size.height-40)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(20, 0, 20, 0)
    }
    
}

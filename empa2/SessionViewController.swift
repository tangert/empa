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
    //total session timer
    var sessionTimer: Timer!
    //other timers?
    
    //priming progress
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
    
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("SESSION TEST SUBJECT: \(self.testSubject!)")
        
        //FIXME: Connect to Firebase bucket and load images instead of locally
        let storageRef = DataManager.sharedInstance.storage.reference()
        
        
        for i in 1...10 {
            let currentImage = storageRef.child("judgement-images/\(i).jpg")
            imageReferences.append(currentImage)
            images.append(UIImage(named: "\((i%6)+1)")!)
        }
        
        guard let testSubject = testSubject else {
            return
        }
        
        DataManager.sharedInstance.currentUserID = testSubject.id
        subjectType = self.testSubject?.testGroup.subjectType()
        
        SessionViewController.primingProgressIsFinished = false
        
        detector?.delegate = self
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isPagingEnabled = true
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        collectionView.collectionViewLayout = layout
        
        //registering nibs
        collectionView.register(judgementCellNib, forCellWithReuseIdentifier: "judgementCell")
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
    
    @IBAction func endSession(_ sender: Any) {
        guard DataManager.sharedInstance.timeData.count != 0 else {
            let alert = UIAlertController(title: "No data yet.", message: "Please give us something.", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
            alert.addAction(cancelAction)
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        sessionTimer.invalidate()
        DataManager.sharedInstance.didFinishSession()
    }
    
    
    @IBAction func unwindToPrev(segue:UIStoryboardSegue) {
        performSegue(withIdentifier: "unwindToPrev", sender: self)
    }
    
    func updateCounter() {
        counter+=0.1
        roundedCounter = Double(String(format: "%0.1f", counter))!
        timerLabel.text = "Session time: \(roundedCounter)"
        
        DataManager.sharedInstance.didUpdateTime(time: roundedCounter)
    }
}

extension SessionViewController: AFDXDetectorDelegate {
    
    func detector(_ detector: AFDXDetector!, didStartDetecting face: AFDXFace!) {
        self.sessionTimer = Timer.scheduledTimer(timeInterval: 0.1, target:self, selector: #selector(SessionViewController.updateCounter), userInfo: nil, repeats: true)
        
        print("Face shown!")
        
        //keeps the timer running even during scrolling.
        RunLoop.main.add(sessionTimer, forMode: RunLoopMode.commonModes)
        
    }
    
    func detector(_ detector: AFDXDetector!, didStopDetecting face: AFDXFace!) {
        
        sessionTimer.invalidate()
        print("Show your face, idiot.")
        
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
                        SessionViewController.cameraDelegate?.willUpdateProgress(type: self.subjectType, data: jsonArray!)
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

        if subjectType == .control {
            
            //Gathering time data
            DataManager.sharedInstance.didRecordSlideTimestamp(tag: indexPath.row, time: self.roundedCounter)

//            //Resetting
//            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "judgementCell", for: indexPath) as! JudgementCell
//
//            if let currentSlideVal = DataManager.sharedInstance.slideValues[indexPath.row] {
//                cell.slider.setValue(currentSlideVal, animated: true)
//            } else {
//                cell.slider.setValue(50, animated: true)
//            }

        }

        else {
            if (indexPath.row == 0) {
                //Gathering time data
                
                DataManager.sharedInstance.didRecordPrimingTimestamp(tag: indexPath.row, time: self.roundedCounter)

                
            } else {
                
                //Gathering time data
                DataManager.sharedInstance.didRecordSlideTimestamp(tag: indexPath.row, time: self.roundedCounter)
                
//                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "judgementCell", for: indexPath) as! JudgementCell
//
//
//                if let currentSlideVal = DataManager.sharedInstance.slideValues[indexPath.row] {
//                    cell.slider.setValue(currentSlideVal, animated: true)
//                } else {
//                    cell.slider.setValue(50, animated: true)
//                }

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
                cell.delegate = self
                
                guard DataManager.sharedInstance.slideVisitTimestamps[cell.tag] == nil else {
                    return cell
                }
                
                return cell
                
            }
        }

    }
}

extension SessionViewController: JudgementTaskDelegate {
    
    func didJudgeImage(tag: Int, value: Float) {
        
        DataManager.sharedInstance.didJudgeImage(tag: tag, value: value, counter: self.roundedCounter)
        
    }
    
}

extension SessionViewController: PrimingCellDelegate {
    
    func didFinishPriming() {
        
        DataManager.sharedInstance.primingData["primingLength"] = self.roundedCounter
        
        print("priming: \(DataManager.sharedInstance.primingData)")
        
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

//
//  DataManager.swift
//  empa2
//
//  Created by Tyler Angert on 12/25/16.
//  Copyright © 2016 Tyler Angert. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseStorage
import FirebaseDatabase

//collect all available data here from SessionViewController, then send to DataViewController.
class DataManager {
    
    // MARK: Singleton
    class var sharedInstance: DataManager {
        struct Static {
            static let instance: DataManager = DataManager()
        }
        return Static.instance
    }
    
    let storage = Storage.storage(url:"gs://empa-d038c.appspot.com")
    
    
    
    //MARK: Final data to be processed and sent to the creation of a new session.
    
    /***********************************/
    /***********************************/
    /***********************************/

    var currentUserID: String?

    var timeData = [Double]()
    
                    //Time stamp
    var facialData = [ Double:
            //Emotion : JSON
            [String: AnyObject]
            ]()
    
    var slideData = [ String:
            //timeStamp,
            //visitTimeStamps
            //slideScore
            //scoreReversals
            //imageURL
            [ String: Any ]
            ]()
    
    var primingData = [ String: Any ]()
    
    /***********************************/
    /***********************************/
    /***********************************/
    
    
    // MARK: Helper variables for intermediate data processing.
    
    // These maintain the values of the sliders according the indexpath.row
    var slideValues = [Int: Float]()

    //Time stamps to be fed into slide data and priming data in post processing
    var slideVisitTimestamps = [ Int : [ Double ] ]()
    var primingVisitTimestamps = [ Int : [ Double ] ]()

    
    
    //FIXME: do you even need this lol?
    
    var sadnessData = [Double]()
    var joyData = [Double]()
    var angerData = [Double]()
    var surpriseData = [Double]()

}

// MARK: Firebase methods called from shared instance.
extension DataManager {
    
    // MARK: TestSubjects
    
    func createTestSubject(testSubject: TestSubject) {
        testSubjectRef.child(testSubject.id).setValue(testSubject.JSON())
    }
    
    func deleteTestSubject(id: String) {
        testSubjectRef.child(id).removeValue()
    }
    
    // MARK: Sessions
    func createSession(session: Session) {
        print("SESSION: \(session.JSON())")
        let data = session.facialData!
        sessionsRef.childByAutoId().setValue(session.userID)
    }
    
    func deleteSession(id: String) {
        sessionsRef.child(id).removeValue()
    }
    
    // MARK: 
}

// MARK: Gameplay methods
extension DataManager {
    
    func didUpdateTime( time: Double ) {
        timeData.append(time)
    }
    
    func didUpdateFacialData(data: [String: AnyObject], time: Double) {
        
        facialData[time] = data
//        print("Facial data: \(time): \(facialData[time]!)")
        
    }
    
    //Regular slide time stamps
    func didRecordSlideTimestamp(tag: Int, time: Double) {
        
        var prevValues = slideVisitTimestamps[tag]
        
        if prevValues == nil {
            //When it's empty, just make the entire array the first time
            prevValues = [time]
        } else {
            prevValues?.append(time)
        }
        
        slideVisitTimestamps.updateValue(prevValues!, forKey: tag)
    }
    
    //Judgement time stamps
    func didRecordPrimingTimestamp(tag: Int, time: Double) {
        
        var prevValues = primingVisitTimestamps[tag]
        
        if prevValues == nil {
            //When it's empty, just make the entire array the first time
            prevValues = [time]
        } else {
            prevValues?.append(time)
        }
        
        primingVisitTimestamps.updateValue(prevValues!, forKey: tag)
    }
    
    // Stores the slideValues once an image is judged
    func didJudgeImage(tag: Int, value: Float, counter: Double) {
        
        print("index: \(tag), value: \(value)")
        slideValues[tag] = value
    }
    
    
    // MARK : Once a session is finished, this is where all of the raw data points get prepared to be sent to firebase.
    
    func didFinishSession() {
        //resets all data to avoid duplicate measurements.
        
        print("all facial data: \(facialData)")
        
        sadnessData.removeAll()
        joyData.removeAll()
        angerData.removeAll()
        surpriseData.removeAll()

//
//        for i in 0..<timeData.count {
//            facialData["\(timeData[i])"] = timeSensitiveEmotionData[i]
//        }
//
//        let newSession = Session.init(
//                userID: self.currentUserID!,
//                sessionLength: self.timeData.last!,
//                facialData: self.facialData,
//                slideData: self.slideData,
//                primingData: self.primingData)
//
//        self.createSession(session: newSession)
//
        
//        for tuple in facialData {
//            let dict = tuple.1
//            for KVPair in dict {
//                switch(KVPair.key) {
//                case "sadness":
//                    sadnessData.append(KVPair.value.doubleValue)
//                case "joy":
//                    joyData.append(KVPair.value.doubleValue)
//                case "anger":
//                    angerData.append(KVPair.value.doubleValue)
//                case "surprise":
//                    surpriseData.append(KVPair.value.doubleValue)
//                default:
//                    break
//                }
//            }
//        }
//
        
    }

}

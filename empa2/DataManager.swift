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
    var startDateTime: Date!
    
                    //Time stamp
    var facialData = [ String :
            //Emotion : JSON
            [String: AnyObject]
            ]()
    
    var slideData = [ String :
            //timeStamp,
            //visitTimeStamps
            //slideScore
            //imageURL
            [ String: Any ]
        
        ]()
    
    var averageScore: Double!
    
    var primingData = [ String: Any ]()
    
    /***********************************/
    /***********************************/
    /***********************************/
    
    
    // MARK: Helper variables for intermediate data processing.
    
    // These maintain the values of the sliders according the indexpath.row
    var slideValues = [Int: Float]()

    //Time stamps to be fed into slide data and priming data in post processing
    //Do you need these?
    var slideVisitTimestamps = [ String : [ Double ] ]()
    var primingVisitTimestamps = [ String : [ Double ] ]()

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
    // FIXME: don't use an intermediary session data strucutre anymore
    //just directly access the intermediate data strcutres present in the manager
    
    func createSession(session: Session) {
        
        let currentSession = sessionsRef.child(session.sessionID)
        
        currentSession.child("userID").setValue(session.userID)
        currentSession.child("sessionID").setValue(session.sessionID)
        currentSession.child("sessionLength").setValue(session.sessionLength)
        currentSession.child("startDateTimeString").setValue(session.startDateTimeString)
        currentSession.child("averageScore").setValue(session.averageScore)
        
        //Facial data
        let facialData = currentSession.child("facialData")
        
        for timestamp in session.facialData.keys {
            
            let adjustedStamp = timestamp.replacingOccurrences(of: ".", with: "_")
            let currentTime = facialData.child(adjustedStamp)
            
            for (emotion, value) in session.facialData[timestamp]! {
                currentTime.child(emotion).setValue(value)
            }
        }
        
        // Slide data
        
        let slideData = currentSession.child("slideData")
        
        for slideNumber in session.slideData.keys {

            let currentSlide = slideData.child("\(slideNumber)")
            currentSlide.child("timestamps").setValue(slideVisitTimestamps[slideNumber])
            
            let score = session.slideData[slideNumber]!["score"]
            currentSlide.child("score").setValue(score)
        }
        
        
        // Priming data
        let primingData = currentSession.child("primingData")
        primingData.child("primingLength").setValue(self.primingData["primingLength"])
        primingData.child("testGroup").setValue(self.primingData["testGroup"])
        
        //Setting the user
//        let currentSubject = testSubjectRef.child(currentUserID!).child
        
    }
    
    func deleteSession(id: String) {
        sessionsRef.child(id).removeValue()
    }
    
    func clearAllData() {
        timeData.removeAll()
        facialData.removeAll()
        slideData.removeAll()
        primingData.removeAll()
        slideValues.removeAll()
        slideVisitTimestamps.removeAll()
        primingVisitTimestamps.removeAll()
        averageScore = 0
    }
    
}

// MARK: Gameplay methods
extension DataManager {
    
    // MARK: Once a session is finished, this is where all of the raw data points get prepared to be sent to firebase.
    
    func getAverageScore() -> Double {
        
        var totalScore: Float = 0
        var numScores = Double(slideData.keys.count)

        for slide in slideData.keys {
            
            let data = slideData[slide]!["score"]! as! [String: Any]
            let value = data["value"]!
            
            totalScore += value as! Float
        }
        
        return Double(totalScore)/numScores
    }
    
    func didFinishSession() {
        
        //calcualte average score once done
        self.averageScore = getAverageScore()
        
        let newSession = Session.init(
            userID:self.currentUserID!,
            startDateTimeString: self.startDateTime.description,
            sessionLength: self.timeData.last!,
            facialData: self.facialData,
            slideData: self.slideData,
            primingData: self.primingData,
            averageScore: self.averageScore)
        
        self.createSession(session: newSession)
    
    }
    
    // MARK: Time data
    
    func didUpdateTime( time: Double ) {
        timeData.append(time)
    }
    
    // MARK: Facial data
    
        func didUpdateFacialData(data: [String: AnyObject], time: Double) {
            facialData["\(time)"] = data
        }
    
    
    // MARK: Slide data
    
        func didRecordSlideTimestamp(tag: Int, time: Double) {
            
            var prevValues = slideVisitTimestamps["\(tag)"]
            
            if prevValues == nil {
                //When it's empty, just make the entire array the first time
                prevValues = [time]
            } else {
                prevValues?.append(time)
            }
            
            print("recording slide timestamps: \(prevValues!)")
            slideVisitTimestamps.updateValue(prevValues!, forKey: "\(tag)")
            
        }
    
    
        func didJudgeImage(tag: Int, value: Float, counter: Double) {
            
            //FIXME: create a nondestructive way of updating both values under the key
            slideData.updateValue( [ "score" : [ "timestamp" : counter ,  "value" : value  ] ], forKey: "\(tag)")
        
        }
    
    
    /*
     
     "tag":
         "timestamps"
 */

    // MARK: Priming data
    
        func didRecordPrimingTimestamp(tag: Int, time: Double) {
            
            var prevValues = primingVisitTimestamps["\(tag)"]
            
            if prevValues == nil {
                //When it's empty, just make the entire array the first time
                prevValues = [time]
            } else {
                prevValues?.append(time)
            }
            
            primingData["timestamps"] = primingVisitTimestamps
            
        }
    
        func didRecordPrimingTestSubject(testGroup: Int) {
            primingData["testGroup"] = testGroup
        }
    
        func didFinishPriming(time: Double) {
            primingData["primingLength"] = time
        }
    
}

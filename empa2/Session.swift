//
//  Session.swift
//  empa2
//
//  Created by Tyler Angert on 12/28/16.
//  Copyright © 2016 Tyler Angert. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase

class Session: BaseModel {
    
    var userID: String!
    var sessionID: String!
    
    var startDateTimeString: String!
	var sessionLength: Double!

    
                    //Time stamp
    var facialData: [ String:
                        //Emotion : value
                        [String: Any]
                    ]!

    
                    //Tag
    var slideData: [ String :

                        //timeStamps
                        //slideScore
                        //imageURL
                        [ String: Any ]
                    ]!
    
    var averageScore: Double!

    
    /*
     //if the testGroup is not 0:
     "primingResults": [
         "primingLength": 0,
         "emoji/TestGroup": happy/sad,
         //Here reference the timeStamps from all the facial data
         "timeStamps": []
         ]
     */
    
                        //primingLength
                        //
    var primingData: [ String: Any ]!
    
    
    func toString(){
        print("userID: \(userID)")
        print("sessionID: \(sessionID)")
        print("sessionLength: \(sessionLength)")
    }
    
    //Initializer from DataManager creation
    init(userID: String,
         startDateTimeString: String,
         sessionLength: Double,
         facialData:[String: [String: Any]],
         slideData:[String: [String: Any]],
         primingData: [String: Any],
         averageScore: Double) {
        
        self.sessionID = "\(userID)_\(startDateTimeString)"
        self.userID = userID
        self.startDateTimeString = startDateTimeString
        self.sessionLength = sessionLength
        self.facialData = facialData
        self.slideData = slideData
        self.primingData = primingData
        self.averageScore = averageScore
        
    }
    
    //Initializer from a Firebase Snapshot
    init(snapshot: DataSnapshot) {
        
        let _ = snapshot.ref
        let _ = snapshot.key
        
        guard let sessionData = snapshot.value as? [String: AnyObject] else {
            return
        }
        
        
        self.sessionID = sessionData["sessionID"] as? String
        self.userID = sessionData["userID"] as? String
        self.sessionLength = sessionData["sessionLength"] as? Double
        self.facialData = sessionData["facialData"] as? [String: [String: Any]]
        self.slideData = sessionData["slideData"] as? [String: [String: Any]]
        self.primingData = sessionData["primingData"] as? [String: Any]
        self.startDateTimeString = sessionData["startDateTimeString"] as? String
        self.averageScore = sessionData["averageScore"] as? Double
        
    }

}

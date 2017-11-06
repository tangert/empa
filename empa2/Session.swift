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
    
    var userID: String?
    var sessionID: String?
    
	var sessionLength: Double?

    
                    //Time stamp
    var facialData: [ Double:
                        //Emotion : value
                        [String: Any]
                    ]?

    
                    //Tag
    var slideData: [ String:

                        //timeStamps
                        //slideScore
                        //imageURL
                        [ String: Any ]
                    ]?

    
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
    var primingData: [ String: Any ]?
    
    //Initializer from DataManager creation
    init(userID: String,
         sessionLength: Double,
         facialData:[Double: [String: Any]],
         slideData:[String: [String: Any]],
         primingData: [String: Any]) {
        
        self.userID = userID
        self.sessionLength = sessionLength
        self.facialData = facialData
        self.slideData = slideData
        self.primingData = primingData
        
    }
    
    //Initializer from a Firebase Snapshot
    init(snapshot: DataSnapshot) {
        
        let _ = snapshot.ref
        let _ = snapshot.key
        
        guard let sessionData = snapshot.value as? [String: AnyObject] else {
            return
        }
        
        self.userID = sessionData["userID"] as? String
        self.sessionLength = sessionData["length"] as? Double
        self.facialData = sessionData["facialData"] as? [Double: [String: Any]]
        self.slideData = sessionData["slideData"] as? [String: [String: Any]]
        self.primingData = sessionData["primingData"] as? [String: Any]
        
    }

}

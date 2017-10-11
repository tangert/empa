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

	var sessionLength: Double?
    var emotionData: Array<[String: AnyObject]>?
    var sadnessData: [Double]?
    var joyData: [Double]?
    var angerData: [Double]?
    var surpriseData: [Double]?
    
    init(sessionLength: Double?, emotionData: Array<[String: AnyObject]>?, sadnessData: [Double]?, joyData: [Double]?, angerData: [Double]?, surpriseData: [Double]?) {
        self.sessionLength = sessionLength
        self.emotionData = emotionData
        self.sadnessData = sadnessData
        self.joyData = joyData
        self.angerData = angerData
        self.surpriseData = surpriseData
    }

}

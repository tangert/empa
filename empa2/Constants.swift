//
//  Constants.swift
//  empa2
//
//  Created by Tyler Angert on 10/10/17.
//  Copyright © 2017 Tyler Angert. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase
import UIKit

//Colors
let EMPA_BLUE = UIColor.init(red: 135/255, green: 206/255, blue: 250/255, alpha: 1.0)
let SUCCESS_GREEN = UIColor.init(red: 134/255, green: 255/255, blue: 136/255, alpha: 1.0)
let FAILURE_RED = UIColor.init(red: 255/255, green: 115/255, blue: 111/255, alpha: 1.0)

//Shadows
let DROP_SHADOW_OPACITY: Float = 0.1

//Firebase references
let rootRef = Database.database().reference()
let testSubjectRef = rootRef.child("testSubjects")
let sessionsRef = rootRef.child("sessions")

//Subject Type
enum subjectType {
    case control
    case happy
    case sad
}

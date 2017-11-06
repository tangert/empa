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

let EMPA_BLUE = UIColor.init(red: 135/255, green: 206/255, blue: 250/255, alpha: 1.0)
let rootRef = Database.database().reference()
let testSubjectRef = rootRef.child("testSubjects")
let sessionsRef = rootRef.child("sessions")

enum subjectType {
    case control
    case happy
    case sad
}

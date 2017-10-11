//
//  Admin.swift
//  empa2
//
//  Created by Tyler Angert on 10/10/17.
//  Copyright © 2017 Tyler Angert. All rights reserved.
//

import Foundation
import Firebase
import FirebaseAuth

class Admin: BaseModel {
    
    let uid: String!
    let email: String!
    
    init(authData: User ) {
        uid = authData.uid
        email = authData.email!
    }
    
    init(uid: String, email: String) {
        self.uid = uid
        self.email = email
    }
}

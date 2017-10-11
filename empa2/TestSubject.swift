//
//  TestSubject.swift
//  empa2
//
//  Created by Tyler Angert on 12/28/16.
//  Copyright © 2016 Tyler Angert. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase

class TestSubject: BaseModel {
	
    var id: String!
    var fname: String!
    var lname: String!
    var DOBString: String!
    var age: Int!
    var sex: String!
    var testGroup: Int!
    var ASD: Bool!
    
    init(fname: String,
         lname: String,
         sex: String,
         DOB: Date!,
         testGroup: Int,
         ASD: Bool) {
        
        self.id = UUID().uuidString
        self.fname = fname
        self.lname = lname
        self.sex = sex
        self.DOBString = DOB.description
        self.age = DOB.calculateAge()
        self.testGroup = testGroup
        self.ASD = ASD
    }
    
    init(snapshot: DataSnapshot) {
        
        let _ = snapshot.ref
        let _ = snapshot.key
        
        guard let testSubjectData = snapshot.value as? [String: AnyObject] else {
            return
        }
        
        self.id = testSubjectData["id"] as! String
        self.fname = testSubjectData["fname"] as! String
        self.lname = testSubjectData["lname"] as! String
        self.DOBString = testSubjectData["DOBString"] as! String
        self.age = testSubjectData["age"] as! Int
        self.sex = testSubjectData["sex"] as! String
        self.testGroup = testSubjectData["testGroup"] as! Int
        self.ASD = testSubjectData["ASD"] as! Bool
        
    }

}

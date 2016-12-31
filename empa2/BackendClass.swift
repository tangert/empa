//
//  BackendClass.swift
//  empa2
//
//  Created by Tyler Angert on 12/28/16.
//  Copyright © 2016 Tyler Angert. All rights reserved.
//

import Foundation
import UIKit

class BackendClass: NSObject {
    
    let api = RESTAPIClient.sharedInstance
    let baseURL = "http://empa-research.herokuapp.com"
    
    //Login and logout
    func login() {
    }
    
    func logout() {
    }
    
    //Patient functions
    func getPatient() {
    }
    
    func editPatient() {
    }
    
    func createPatient() {
    }
    
    func deletePatient() {
    }
    
    //Session functions
    func getSession() {
    }
    
    func editSession() {
    }
    
    func createSession() {
    }
    
    func deleteSession() {
    }
    
}

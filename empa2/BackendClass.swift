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
    func getPatient(firstName: String?, lastName: String?) {
        
        guard let first = firstName else {
            print("No first name")
            return
        }
        
        guard let last = lastName else {
            print("No last name")
            return
        }
        
        return api.get(baseURL: baseURL, section: "/patients/\(first)\(last)")
        
    }
    
    func editPatient(firstName: String?, lastName: String?) {
        
        guard let first = firstName else {
            print("No first name")
            return
        }
        
        guard let last = lastName else {
            print("No last name")
            return
        }
        
        return api.put(baseURL: baseURL, section: "/patients/\(first)\(last)/edit")
    }
    
    func createPatient(firstName: String?, lastName: String?) {
        
        guard let first = firstName else {
            print("No first name")
            return
        }
        
        guard let last = lastName else {
            print("No last name")
            return
        }
        
        return api.post(baseURL: baseURL, section: "/patients/create/\(first)\(last)")
    }
    
    func deletePatient(firstName: String?, lastName: String?) {
        
        guard let first = firstName else {
            print("No first name")
            return
        }
        
        guard let last = lastName else {
            print("No last name")
            return
        }
        
        return api.delete(baseURL: baseURL, section: "/patients/\(first)\(last)/delete")
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

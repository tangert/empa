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
    
    let api = RESTAPIClient()
    let baseURL = "http://empa-research.herokuapp.com"
    
    //Login and logout
    func login() {
    }
    
    func logout() {
    }
    
/* place this right before each function is called
 
        guard let firstName = firstName else {
            print("No first name")
            return
        }
 
        guard let lastName = lastName else {
            print("No last name")
            return
        }
 
 */
    
    //Patient functions
    func createPatient(firstName: String, lastName: String) {
        return api.post(
            baseURL: baseURL,
            section: "/patients/create/\(firstName)_\(lastName)")
       }
    
    func getPatient(firstName: String, lastName: String) {
        return api.get(
            baseURL: baseURL,
            section: "/patients/\(firstName)_\(lastName)")
    }
    
    func editPatient(firstName: String, lastName: String) {
        return api.put(
            baseURL: baseURL,
            section: "/patients/\(firstName)_\(lastName)/edit")
    }
    
    func deletePatient(firstName: String, lastName: String) {
        return api.delete(
            baseURL: baseURL,
            section: "/patients/\(firstName)_\(lastName)/delete")
    }
    
    //Session functions
    func createSession(firstName: String, lastName: String, sessionNumber: Int) {
        return api.post(
            baseURL: baseURL,
            section: "/patients/\(firstName)_\(lastName)/sessions/create/\(sessionNumber)")
    }
    
    func getSession(firstName: String, lastName: String, sessionNumber: Int) {
        return api.get(
            baseURL: baseURL,
            section: "/patients/\(firstName)_\(lastName)/sessions/\(sessionNumber)")
    }
    
    func editSession(firstName: String, lastName: String, sessionNumber: Int) {
        return api.put(
            baseURL: baseURL,
            section: "/patients/\(firstName)_\(lastName)/sessions/\(sessionNumber)/edit")
    }
    
    func deleteSession(firstName: String, lastName: String, sessionNumber: Int) {
         return api.delete(
            baseURL: baseURL,
            section: "/patients/\(firstName)_\(lastName)/sessions/\(sessionNumber)/delete")
    }
    
}

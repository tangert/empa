//
//  RESTAPIClient.swift
//  empa2
//
//  Created by Tyler Angert on 12/28/16.
//  Copyright © 2016 Tyler Angert. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

class RESTAPIClient: NSObject {
    
    static var sharedInstance = RESTAPIClient()
    
    func get(baseURL: String, section: String) {
        let url = URL(fileURLWithPath: "\(baseURL)\(section)")
        Alamofire.request(
                url,
                method: HTTPMethod.get,
                parameters: nil,
                encoding: URLEncoding.default,
                headers: nil)
                .validate()
                .responseData { (response) in
                print("Retrieved!")
        }
    }
    
    func put(baseURL: String, section: String) {
        let url = URL(fileURLWithPath: "\(baseURL)\(section)")
        Alamofire.request(
            url,
            method: HTTPMethod.put,
            parameters: nil,
            encoding: URLEncoding.default,
            headers: nil)
            .validate()
            .responseData { (response) in
                print("Retrieved!")
        }
    }
    
    func post(baseURL: String, section: String) {
        let url = URL(fileURLWithPath: "\(baseURL)\(section)")
        Alamofire.request(
            url,
            method: HTTPMethod.post,
            parameters: nil,
            encoding: URLEncoding.default,
            headers: nil)
            .validate()
            .responseData { (response) in
                print("Retrieved!")
        }
    }
    
    func delete(baseURL: String, section: String) {
        let url = URL(fileURLWithPath: "\(baseURL)\(section)")
        Alamofire.request(
            url,
            method: HTTPMethod.delete,
            parameters: nil,
            encoding: URLEncoding.default,
            headers: nil)
            .validate()
            .responseData { (response) in
                print("Retrieved!")
        }
    }
    
}

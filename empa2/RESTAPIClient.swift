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
    let headers = ["Content-Type": "application/json"]
    
    func get(baseURL: String, section: String, parameters: [String: String], completion: @escaping ([String]) -> Void) {
        let url = URL(fileURLWithPath: "\(baseURL)\(section)")
        Alamofire.request(
                url,
                method: HTTPMethod.get,
                parameters: parameters,
                encoding: URLEncoding.default,
                headers: headers)
                .validate()
                .responseJSON { (response) in
                    
                    guard response.result.isSuccess else {
                        print("Error while fetching tags: \(response.result.error)")
                        completion([String]())
                        return
                    }
                    
                    guard let responseJSON = response.result.value as? [String: AnyObject] else {
                        print("Invalid tag information received from service")
                        completion([String]())
                        return
                    }
                    print(responseJSON)
                    completion([String]())
        }
        }
    }
    
    func put(baseURL: String, section: String, parameters: [String: String], completion: @escaping ([String]) -> Void) {
        let url = URL(fileURLWithPath: "\(baseURL)\(section)")
        Alamofire.request(
            url,
            method: HTTPMethod.put,
            parameters: parameters,
            encoding: URLEncoding.default,
            headers: headers)
            .validate()
            .responseJSON { (response) in
                
                guard response.result.isSuccess else {
                    print("Error while fetching tags: \(response.result.error)")
                    completion([String]())
                    return
                }
                
                guard let responseJSON = response.result.value as? [String: AnyObject] else {
                    print("Invalid tag information received from service")
                    completion([String]())
                    return
                }
                print(responseJSON)
                completion([String]())
        }
    }

    func post(baseURL: String, section: String, parameters: [String: String], completion: @escaping ([String]) -> Void) {
        let url = URL(fileURLWithPath: "\(baseURL)\(section)")
        Alamofire.request(
            url,
            method: HTTPMethod.post,
            parameters: parameters,
            encoding: URLEncoding.default,
            headers: headers)
            .validate()
            .responseJSON { (response) in
                
                guard response.result.isSuccess else {
                    print("Error while fetching tags: \(response.result.error)")
                    completion([String]())
                    return
                }
                
                guard let responseJSON = response.result.value as? [String: AnyObject] else {
                    print("Invalid tag information received from service")
                    completion([String]())
                    return
                }
                print(responseJSON)
                completion([String]())
        }
    }

    func delete(baseURL: String, section: String, parameters: [String: String], completion: ([String]) -> Void) {
        let url = URL(fileURLWithPath: "\(baseURL)\(section)")
        Alamofire.request(
            url,
            method: HTTPMethod.delete,
            parameters: parameters,
            encoding: URLEncoding.default,
            headers: headers)
            .validate()
            .responseJSON { (response) in
                
                guard response.result.isSuccess else {
                    print("Error while fetching tags: \(response.result.error)")
                    completion([String]())
                    return
                }
                
                guard let responseJSON = response.result.value as? [String: AnyObject] else {
                    print("Invalid tag information received from service")
                    completion([String]())
                    return
                }
                print(responseJSON)
                completion([String]())
        }
    }

}

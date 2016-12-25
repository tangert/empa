//
//  Extensions.swift
//  empa2
//
//  Created by Tyler Angert on 12/24/16.
//  Copyright © 2016 Tyler Angert. All rights reserved.
//

import Foundation

extension String {
    //converting JSON string to Dictionary.
    func convertToDictionary() -> [String:AnyObject]? {
        if let data = self.data(using: String.Encoding.utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String:AnyObject]
            } catch let error as NSError {
                print(error)
            }
        }
        print("Cannot convert JSON to Dictionary.")
        return nil
    }
    
}

//extension Double {
//    func roundToDecimalPlace(place: Int) -> Double {
//        let decimalPlace = (pow(10,place))
//        return Double(round(decimalPlace*self)/decimalPlace)
//    }
//    
//}

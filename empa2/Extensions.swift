//
//  Extensions.swift
//  empa2
//
//  Created by Tyler Angert on 12/24/16.
//  Copyright © 2016 Tyler Angert. All rights reserved.
//

import Foundation
import UIKit

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

extension UIView {
    
    func animateOpacity(alpha: CGFloat) {
        UIView.animate(withDuration: 0.25) {
            self.alpha = alpha
        }
    }
}

extension UIColor {
    
    func fromHex(hexString: String, alpha:CGFloat? = 1.0) -> UIColor {
        
        func intFromHexString(hexStr: String) -> UInt32 {
            var hexInt: UInt32 = 0
            // Create scanner
            let scanner: Scanner = Scanner(string: hexStr)
            // Tell scanner to skip the # character
            scanner.charactersToBeSkipped = NSCharacterSet(charactersIn: "#") as CharacterSet
            // Scan hex value
            scanner.scanHexInt32(&hexInt)
            return hexInt
        }

        // Convert hex string to an integer
        let hexint = Int(intFromHexString(hexStr: hexString))
        let red = CGFloat((hexint & 0xff0000) >> 16) / 255.0
        let green = CGFloat((hexint & 0xff00) >> 8) / 255.0
        let blue = CGFloat((hexint & 0xff) >> 0) / 255.0
        let alpha = alpha!
        
        // Create color object, specifying alpha as well
        return UIColor(red: red, green: green, blue: blue, alpha: alpha)
    }
    
}

extension Double {
    func fixedFractionDigits(digits: Int) -> String {
        return String(format: "%.\(digits)f", self)
    }
    
    func toString() -> String {
        return String(format: "%.1f",self)
    }
    
    //regex expression for cutting off decimals at the first place. for some reason using mod didnt work.
    func firstDecimal() -> Double {
        var regex = try! NSRegularExpression(pattern: "^\\d[0-9]*(?:\\.\\d)?$", options: NSRegularExpression.Options.allowCommentsAndWhitespace)
        var counterString = self.toString()
        let range = NSMakeRange(0, counterString.characters.count)
        let modString = regex.stringByReplacingMatches(in: counterString, options: [], range: range, withTemplate: counterString)
        return Double(modString)!
    }
}

extension Float {
    func firstDecimal() -> Double {
        var regex = try! NSRegularExpression(pattern: "^\\d[0-9]*(?:\\.\\d)?$", options: NSRegularExpression.Options.allowCommentsAndWhitespace)
        var counterString = self.description
        let range = NSMakeRange(0, counterString.characters.count)
        let modString = regex.stringByReplacingMatches(in: counterString, options: [], range: range, withTemplate: counterString)
        return Double(modString)!
    }
}

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

extension Int {
    
    func subjectType() -> subjectType {
        switch(self){
        case 0:
            return .control
        case 1:
            return .happy
        case 2:
            return .sad
        default:
            return .control
        }
    }
    
}

extension UIView {
    
    func animateOpacity(alpha: CGFloat) {
        UIView.animate(withDuration: 0.25) {
            self.alpha = alpha
        }
    }
    
    func dropShadow(radius: CGFloat) {
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.075
        self.layer.shadowOffset = CGSize(width: -5, height: -5)
        self.layer.shadowRadius = radius
        self.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        self.layer.shouldRasterize = true
        
        self.layer.rasterizationScale = UIScreen.main.scale
        
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
    
    var redValue: CGFloat{ return CIColor(color: self).red }
    var greenValue: CGFloat{ return CIColor(color: self).green }
    var blueValue: CGFloat{ return CIColor(color: self).blue }
    var alphaValue: CGFloat{ return CIColor(color: self).alpha }
    
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

extension Date {
    /// Returns the amount of years from another date
    func years(from date: Date) -> Int {
        return Calendar.current.dateComponents([.year], from: date, to: self).year ?? 0
    }
    /// Returns the amount of months from another date
    func months(from date: Date) -> Int {
        return Calendar.current.dateComponents([.month], from: date, to: self).month ?? 0
    }
    /// Returns the amount of weeks from another date
    func weeks(from date: Date) -> Int {
        return Calendar.current.dateComponents([.weekOfMonth], from: date, to: self).weekOfMonth ?? 0
    }
    /// Returns the amount of days from another date
    func days(from date: Date) -> Int {
        return Calendar.current.dateComponents([.day], from: date, to: self).day ?? 0
    }
    /// Returns the amount of hours from another date
    func hours(from date: Date) -> Int {
        return Calendar.current.dateComponents([.hour], from: date, to: self).hour ?? 0
    }
    /// Returns the amount of minutes from another date
    func minutes(from date: Date) -> Int {
        return Calendar.current.dateComponents([.minute], from: date, to: self).minute ?? 0
    }
    /// Returns the amount of seconds from another date
    func seconds(from date: Date) -> Int {
        return Calendar.current.dateComponents([.second], from: date, to: self).second ?? 0
    }
    /// Returns the a custom time interval description from another date
    func offset(from date: Date) -> String {
        if years(from: date)   > 0 { return "\(years(from: date))y"   }
        if months(from: date)  > 0 { return "\(months(from: date))M"  }
        if weeks(from: date)   > 0 { return "\(weeks(from: date))w"   }
        if days(from: date)    > 0 { return "\(days(from: date))d"    }
        if hours(from: date)   > 0 { return "\(hours(from: date))h"   }
        if minutes(from: date) > 0 { return "\(minutes(from: date))m" }
        if seconds(from: date) > 0 { return "\(seconds(from: date))s" }
        return ""
    }
    
    
    func calculateAge() -> Int {
        
        let dateComponentsFormatter = DateComponentsFormatter()
        dateComponentsFormatter.allowedUnits = [.year,.month,.weekOfYear,.day,.hour,.minute,.second]
        dateComponentsFormatter.maximumUnitCount = 1
        dateComponentsFormatter.unitsStyle = .full
        dateComponentsFormatter.string(from: Date(), to: Date(timeIntervalSinceNow: 4000000))
        
        let date = Date()
        let calendar = Calendar.current
        let currentYear = calendar.component(.year, from: date)
        let fromYear = calendar.component(.year, from: self)
        
        return currentYear - fromYear
    }
}



// TimeOut and Interval methods a la JavaScript

/**
 setTimeout()
 
 Shorthand method for create a delayed block to be execute on started Thread.
 
 This method returns ``Timer`` instance, so that user may execute the block
 within immediately or keep the reference for further cancelation by calling
 ``Timer.invalidate()``
 
 Example:
 let timer = setTimeout(0.3) {
 // do something
 }
 timer.invalidate()      // cancel it.
 */
func setTimeout(_ delay:TimeInterval, block:@escaping ()->Void) -> Timer {
    return Timer.scheduledTimer(timeInterval: delay, target: BlockOperation(block: block), selector: #selector(Operation.main), userInfo: nil, repeats: false)
}

/**
 setInternval()
 
 Similar to setTimeout() this method will return ``Timer`` instance however, this
 method will execute repeatedly.
 
 Warning using this method with caution, it is recommended that the block to utilise
 this method should call [unowned self] or [weak self] to announce OS that it should not
 hold strong reference to this block.
 
 In addition, ``Timer`` returned should kept as member variable, and call invalidated()
 when the block no longer required. such as deinit, or viewDidDisappear()
 */
func setInterval(_ interval:TimeInterval, block:@escaping ()->Void) -> Timer {
    return Timer.scheduledTimer(timeInterval: interval, target: BlockOperation(block: block), selector: #selector(Operation.main), userInfo: nil, repeats: true)
}

func colorInBetween(color1: UIColor, color2: UIColor, percent: CGFloat) -> UIColor {
    
    let resultRed = color1.redValue + percent * (color2.redValue - color1.redValue)
    let resultGreen = color1.greenValue + percent * (color2.greenValue - color1.greenValue)
    let resultBlue = color1.blueValue + percent * (color2.blueValue - color1.blueValue)
    
    return UIColor.init(red: resultRed, green: resultGreen, blue: resultBlue, alpha: 1)
    
}


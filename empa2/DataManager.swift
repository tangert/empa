//
//  DataManager.swift
//  empa2
//
//  Created by Tyler Angert on 12/25/16.
//  Copyright © 2016 Tyler Angert. All rights reserved.
//

import Foundation
import UIKit
import Affdex

//collect all available data here from SessionViewController, then send to DataViewController.
class DataManager {
    
    static var sharedInstance = DataManager()
    
    var emotionData = Array<[String: AnyObject]?>()
    var timeData = Array<Double>()
    var chartData = Array<[Double: [String: AnyObject]?]>()
    
    init() {
        
    }
    
}

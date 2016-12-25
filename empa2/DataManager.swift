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
import ResearchKit

//collect all available data here from SessionViewController, then send to DataViewController.
class DataManager {
    
    static var sharedInstance = DataManager()
    var dataManagerDelegate: DataManagerDelegate?
    var timeData = Array<Double>()
    var emotionData = Array<[String: AnyObject]>()
    var timeSensitiveEmotionData = Array<[String: AnyObject]>()
    
    var chartDictionary = [Double: [String: AnyObject]]()
    var chartArray = Array<(Double, [String: AnyObject])>()
    
    init() {
        SessionViewController.dataManagerDelegate = self
    }
    
}

extension DataManager: DataManagerDelegate {
    
    func didExportData() {
        print("Exported data from SessionViewController to DataManager.")
        
        print(emotionData)
        print(timeData)
        
        var keyValCount = 0
        for (key, val) in zip(timeData, emotionData) {
            keyValCount+=1
            chartDictionary[key] = val
        }
        
        let chartArray = Array(zip(timeData, timeSensitiveEmotionData))
        
        print ("Key val count: \(keyValCount)")
        print("Chart array count: \(chartArray.count)")
        print("Chart array: \(chartArray)")
        
    }
    
    func didUpdateTimer(counter: Double) {
        timeData.append(counter)
        timeSensitiveEmotionData.append(emotionData.last!)
    }

}

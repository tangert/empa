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
class DataManager: DataManagerDelegate {
    
    static var sharedInstance = DataManager()
    var dataManagerDelegate: DataManagerDelegate?
    var timeData = Array<Double>()
    var emotionData = Array<[String: AnyObject]>()
    var chartDictionary = [Double: [String: AnyObject]]()
    var chartArray = Array<(Double, [String: AnyObject])>()
    
    init() {
        //populates the chart data with time and corresponding emotion data.
        SessionViewController.dataManagerDelegate = self
    }
    
    
    func didExportData() {
        print("Exported data from SessionViewController to DataManager.")
        
        print(emotionData)
        print(timeData)
        
        var keyValCount = 0
        for (key, val) in zip(timeData, emotionData) {
            keyValCount+=1
            chartDictionary[key] = val
        }
        
        var chartArray = Array(zip(timeData, emotionData))
        
        print ("Key val count: \(keyValCount)")
        print("Chart array count: \(chartArray.count)")
        print("Chart array: \(chartArray)")
        
    }
    
}

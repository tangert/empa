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
    
    func didUpdateTimer(counter: Double) {
        timeData.append(counter)
        timeSensitiveEmotionData.append(emotionData.last!)
    }
    
    func didExportData() {
        
        //resets all data to avoid duplicate measurements.
        let allData = GraphDataSource.sharedInstance
        allData.sadnessData.removeAll()
        allData.joyData.removeAll()
        allData.angerData.removeAll()
        
        allData.plotPoints[0].removeAll()
        allData.plotPoints[1].removeAll()
        allData.plotPoints[2].removeAll()
        
        print(emotionData)
        print(timeData)
        
        var keyValCount = 0
        for (key, val) in zip(timeData, emotionData) {
            keyValCount+=1
            chartDictionary[key] = val
        }
        
        chartArray = Array(zip(timeData, timeSensitiveEmotionData))
        
        for tuple in chartArray {
            let dict = tuple.1
            for KVPair in dict {
                switch(KVPair.key) {
                case "sadness":
                    //removes all data previously then appends everything else
                    allData.sadnessData.append(KVPair.value)
                case "joy":
                    allData.joyData.append(KVPair.value)
                case "anger":
                    allData.angerData.append(KVPair.value)
                default:
                    break
                }
            }
        }
        
        for score in allData.sadnessData {
            allData.plotPoints[0].append(ORKValueRange(value: score.doubleValue))
        }
        
        for score in allData.joyData {
            allData.plotPoints[1].append(ORKValueRange(value: score.doubleValue))
        }
        
        for score in allData.angerData {
            allData.plotPoints[2].append(ORKValueRange(value: score.doubleValue))
        }
        
    }
}

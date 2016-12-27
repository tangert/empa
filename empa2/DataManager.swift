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
    var slideValue: Float?
    
    var sadnessData = [Double]()
    var joyData = [Double]()
    var angerData = [Double]()
    var surpriseData = [Double]()
    
    var plotPoints = Array(repeating: Array<Double>(), count: 4)
    var slideAdjustedPlotPoints = Array(repeating: Array<Double>(), count: 4)
    var slideCount = 0
    
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
        sadnessData.removeAll()
        joyData.removeAll()
        angerData.removeAll()
        surpriseData.removeAll()
        
        plotPoints[0].removeAll()
        plotPoints[1].removeAll()
        plotPoints[2].removeAll()
        plotPoints[3].removeAll()
        
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
                    sadnessData.append(KVPair.value.doubleValue)
                case "joy":
                    joyData.append(KVPair.value.doubleValue)
                case "anger":
                    angerData.append(KVPair.value.doubleValue)
                case "surprise":
                    surpriseData.append(KVPair.value.doubleValue)
                default:
                    break
                }
            }
        }
        
        for score in sadnessData {
            plotPoints[0].append(score)
        }
        
        for score in joyData {
            plotPoints[1].append(score)
        }
        
        for score in angerData {
            plotPoints[2].append(score)
        }
        
        for score in surpriseData {
            plotPoints[3].append(score)
        }
        
    }
}

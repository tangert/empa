//
//  LineGraphDataSource.swift
//  empa2
//
//  Created by Tyler Angert on 12/25/16.
//  Copyright © 2016 Tyler Angert. All rights reserved.
//

import Foundation
import UIKit
import ResearchKit

class GraphDataSource: NSObject, ORKValueRangeGraphChartViewDataSource, UISliderDelegate {
    
    static var sharedInstance = GraphDataSource()
    var chartDictionary = [Double: [String: AnyObject]?]()
    var chartArray = Array<(Double, [String: AnyObject])>()
    
    
    var sadnessData = [AnyObject]()
    var joyData = [AnyObject]()
    var angerData = [AnyObject]()
    var slideValue: Float?
    
    var plotPoints = Array(repeating: [ORKValueRange](), count: 3)
    var slideAdjustedPlotPoints = Array(repeating: [ORKValueRange](), count: 3)


    override init() {
        super.init()
        DataViewController.sliderDelegate = self
    }
    
    var slideCount = 0
    // MARK: UISliderDelegate
    func sliderDidChange(value: Float) {
        slideCount+=1
        slideAdjustedPlotPoints[0].removeAll()
        slideAdjustedPlotPoints[1].removeAll()
        slideAdjustedPlotPoints[2].removeAll()
        
        slideValue = value
        print("Integer slide val: \(Int(slideValue!))")
        
        //adjusts the plot points
        for plot in 0..<plotPoints.count {
            for point in 0..<(Int(slideValue!)) {
                if (Int(slideValue!) > Int(DataManager.sharedInstance.timeData.last!)) {
                    slideAdjustedPlotPoints[plot].append(plotPoints[plot][point])
                } else if point != 0  {
                    slideAdjustedPlotPoints[plot].remove(at: point)
                }
            }
        }
        
        print("New plot point count: \(slideAdjustedPlotPoints[0].count)")
    }
    
    // MARK: ORKGraphChartViewDataSource
    
    func numberOfPlots(in graphChartView: ORKGraphChartView) -> Int {
        return plotPoints.count
    }
    
    func graphChartView(_ graphChartView: ORKGraphChartView, dataPointForPointIndex pointIndex: Int, plotIndex: Int) -> ORKValueRange {
        
        //need to update the values displayed in real time according to the slider
            return plotPoints[plotIndex][pointIndex]
    
    }
    
    func graphChartView(_ graphChartView: ORKGraphChartView, numberOfDataPointsForPlotIndex plotIndex: Int) -> Int {
        
        
            return plotPoints[plotIndex].count

    }
    
    func maximumValue(for graphChartView: ORKGraphChartView) -> Double {
        return 100
    }
    
    func minimumValue(for graphChartView: ORKGraphChartView) -> Double {
        return 0
    }
    
    func graphChartView(_ graphChartView: ORKGraphChartView, titleForXAxisAtPointIndex pointIndex: Int) -> String? {
        
//        guard pointIndex <= Int(slideValue!) else {
//            return nil
//        }
        
        guard pointIndex%10 == 0 else {
            return nil
        }

        guard pointIndex < DataManager.sharedInstance.timeData.count else {
            return nil
        }
        
        //shows the label as the respective time point for each data point.
        //throws an index out of range error on second click.
        return "\(DataManager.sharedInstance.timeData[pointIndex])s"
    }
}



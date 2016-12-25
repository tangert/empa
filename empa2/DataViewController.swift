//
//  DataViewController.swift
//  empa2
//
//  Created by Tyler Angert on 12/25/16.
//  Copyright © 2016 Tyler Angert. All rights reserved.
//

import Foundation
import UIKit
import Affdex
import ResearchKit

class DataViewController: UIViewController {

    @IBOutlet weak var graphChart: ORKLineGraphChartView!
    static var chartData = Array<[Double: [String: AnyObject]?]>()

    override func viewDidLoad() {
        super.viewDidLoad()
//        print(DataViewController.chartData)
        
        graphChart.dataSource = self as? ORKValueRangeGraphChartViewDataSource
        graphChart.delegate = self
    }
    
    
    
}

extension DataViewController: ORKGraphChartViewDelegate, ORKGraphChartViewDataSource {

    public func numberOfPlots(in graphChartView: ORKGraphChartView) -> Int {
        return 7
    }
    
    func graphChartView(_ graphChartView: ORKGraphChartView, numberOfDataPointsForPlotIndex plotIndex: Int) -> Int {
        return DataManager.sharedInstance.timeData.count
    }
    
}

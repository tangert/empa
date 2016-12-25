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
    static var chartDictionary = [Double: [String: AnyObject]?]()
    static var chartArray = Array<(Double, [String: AnyObject])>()

    override func viewDidLoad() {
        super.viewDidLoad()
        print("DataViewController chartData count: \(DataViewController.chartDictionary.count)")
        
        graphChart.dataSource = self as? ORKValueRangeGraphChartViewDataSource
        graphChart.delegate = self
    }
    
}

extension DataViewController: ORKGraphChartViewDelegate, ORKGraphChartViewDataSource {
    
    public func numberOfPlots(in graphChartView: ORKGraphChartView) -> Int {
        return 1
    }
    
    func graphChartView(_ graphChartView: ORKGraphChartView, numberOfDataPointsForPlotIndex plotIndex: Int) -> Int {
        return DataViewController.chartArray.count
    }
    
}

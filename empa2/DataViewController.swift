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

    let graphDataSource = GraphDataSource.sharedInstance

    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("DataViewController chartData count: \(DataViewController.chartDictionary.count)")
        
        graphChart.dataSource = graphDataSource
        graphChart.delegate = self
    }
    
}

extension DataViewController: ORKGraphChartViewDelegate {
    
    
    
}


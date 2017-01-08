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
import Charts

class DataViewController: UIViewController {
    
    //Charts
    @IBOutlet weak var lineChart: LineChartView!
    var combinedChart: CombinedChartView?

    //Switches
    @IBOutlet weak var sadnessSwitch: UISwitch!
    @IBOutlet weak var joySwitch: UISwitch!
    @IBOutlet weak var angerSwitch: UISwitch!
    @IBOutlet weak var surpriseSwitch: UISwitch!
    
    //Labels
    @IBOutlet weak var sadnessLabel: UILabel!
    @IBOutlet weak var joyLabel: UILabel!
    @IBOutlet weak var angerLabel: UILabel!
    @IBOutlet weak var surpriseLabel: UILabel!
    
    var chartArray = Array<(Double, [String: AnyObject])>()
    
    //Chart variables
    //original data
    let sadnessData = DataManager.sharedInstance.sadnessData
    let joyData = DataManager.sharedInstance.joyData
    let angerData = DataManager.sharedInstance.angerData
    let surpriseData = DataManager.sharedInstance.surpriseData
    
    //processed data for data sets
    var sadnessDataEnumerated: [ChartDataEntry]?
    var joyDataEnumerated: [ChartDataEntry]?
    var angerDataEnumerated : [ChartDataEntry]?
    var surpriseDataEnumerated : [ChartDataEntry]?
    
    //datasets for charts
    var ds1: LineChartDataSet?
    var ds2: LineChartDataSet?
    var ds3: LineChartDataSet?
    var ds4: LineChartDataSet?
    
    let chartData = LineChartData()
    
    //colors
    let blue = UIColor.init(red: 114/255, green: 226/255, blue: 255/255, alpha: 1.0)
    let green = UIColor.init(red: 114/255, green: 255/255, blue: 135/255, alpha: 1.0)
    let red = UIColor.init(red: 255/255, green: 114/255, blue: 114/255, alpha: 1.0)
    let yellow = UIColor.init(red: 255/255, green: 222/255, blue: 114/255, alpha: 1.0)
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        print("DataViewController chartData count: \(DataManager.sharedInstance.chartDictionary.count)")
        print("Sadness data: \(DataManager.sharedInstance.sadnessData)")
        print("Joy data: \(DataManager.sharedInstance.joyData)")
        print("Anger data: \(DataManager.sharedInstance.angerData)")
        
        lineChart.delegate = self
        sadnessDataEnumerated = sadnessData.enumerated().map { x, y in return ChartDataEntry(x: Double(x), y: y) }
        joyDataEnumerated = joyData.enumerated().map { x, y in return ChartDataEntry(x: Double(x), y: y) }
        angerDataEnumerated = angerData.enumerated().map { x, y in return ChartDataEntry(x: Double(x), y: y) }
        surpriseDataEnumerated = surpriseData.enumerated().map { x, y in return ChartDataEntry(x: Double(x), y: y) }
        
        //switch initialization
        sadnessSwitch.tag = 1
        joySwitch.tag = 2
        angerSwitch.tag = 3
        surpriseSwitch.tag = 4
        
        sadnessSwitch.onTintColor = blue
        joySwitch.onTintColor = green
        angerSwitch.onTintColor = red
        surpriseSwitch.onTintColor = yellow
        
        setUpChart()
        
    }
    
    func setUpChart() {
        
        //chart data setup
        ds1 = LineChartDataSet(values: sadnessDataEnumerated, label: nil)
        setupDataSet(ds: ds1!, color: self.blue, radius: 7.5)
        
        ds2 = LineChartDataSet(values: joyDataEnumerated, label: nil)
        setupDataSet(ds: ds2!, color: self.green, radius: 7.5)
        
        ds3 = LineChartDataSet(values: angerDataEnumerated, label: nil)
        setupDataSet(ds: ds3!, color: self.red, radius: 7.5)
        
        ds4 = LineChartDataSet(values: surpriseDataEnumerated, label: nil)
        setupDataSet(ds: ds4!, color: self.yellow, radius: 7.5)
        
        //line chart visual setup
        lineChart.data = chartData
        lineChart.gridBackgroundColor = UIColor.white
        lineChart.drawGridBackgroundEnabled = false
        lineChart.scaleYEnabled = false
        lineChart.borderColor = UIColor.clear
       
        //axis setup
        lineChart.xAxis.labelPosition = .bottom
        lineChart.leftAxis.gridColor = UIColor.lightGray.withAlphaComponent(0.3)
        lineChart.rightAxis.gridColor = UIColor.lightGray.withAlphaComponent(0.3)
        lineChart.xAxis.gridColor = UIColor.lightGray.withAlphaComponent(0.3)
        
        lineChart.xAxis.granularity = 1.0
        lineChart.rightAxis.drawAxisLineEnabled = false
        lineChart.chartDescription?.text = "Emotion data"

    }
    
    //set up visuals for the dataset
    func setupDataSet(ds: LineChartDataSet, color: UIColor, radius: CGFloat) {
        ds.circleRadius = radius
        ds.circleHoleRadius = radius/2
        ds.cubicIntensity = 0.8
        ds.circleColors = [color.withAlphaComponent(0.6)]
        
        ds.colors = [color]
        ds.lineWidth = 3
        ds.mode = .horizontalBezier
        
        chartData.addDataSet(ds)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.lineChart.animate(xAxisDuration: 0.5, yAxisDuration: 1.0)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        print("Time data count: \(DataManager.sharedInstance.timeData.count)")
        print("Sadness data count: \(DataManager.sharedInstance.sadnessData.count)")
    }
    
    //Adjusting which data sets are visible
    @IBAction func switchPressed(sender: UISwitch) {
        switch(sender.tag) {
            case 1:
                if sender.isOn == false {
                    sadnessLabel.animateOpacity(alpha: 0.5)
                    updateGraph(action: "remove", dataSet: ds1!)
                } else {
                    sadnessLabel.animateOpacity(alpha: 1.0)
                    updateGraph(action: "add", dataSet: ds1!)
                }
            case 2:
                if sender.isOn == false {
                    joyLabel.animateOpacity(alpha: 0.5)
                    updateGraph(action: "remove", dataSet: ds2!)
                } else {
                    joyLabel.animateOpacity(alpha: 1.0)
                    updateGraph(action: "add", dataSet: ds2!)
                }
            case 3:
                if sender.isOn == false {
                    angerLabel.animateOpacity(alpha: 0.5)
                    updateGraph(action: "remove", dataSet: ds3!)
                } else {
                    angerLabel.animateOpacity(alpha: 1.0)
                    updateGraph(action: "add", dataSet: ds3!)
                }
            case 4:
                if sender.isOn == false {
                    surpriseLabel.animateOpacity(alpha: 0.5)
                    updateGraph(action: "remove", dataSet: ds4!)
                } else {
                    surpriseLabel.animateOpacity(alpha: 1.0)
                    updateGraph(action: "add", dataSet: ds4!)
                }
            default:
                break
        }
    }
    
    func updateGraph(action: String, dataSet: LineChartDataSet) {
        if action == "remove" {
            self.chartData.removeDataSet(dataSet)
        } else if action == "add" {
            self.chartData.addDataSet(dataSet)
        } else {
            print("Sorry no luck")
        }
        
        self.lineChart.notifyDataSetChanged()
        self.lineChart.animate(yAxisDuration: 0.25)
    }
}

extension DataViewController: ChartViewDelegate {
    
    func chartValueSelected(chartView: ChartViewBase, entry: ChartDataEntry, dataSetIndex: Int, highlight: Highlight) {
        print("Data set index: \(dataSetIndex)")
    }
    
}

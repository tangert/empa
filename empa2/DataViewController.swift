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

    @IBOutlet weak var lineChart: LineChartView!
    
    @IBOutlet weak var sadnessSwitch: UISwitch!
    @IBOutlet weak var joySwitch: UISwitch!
    @IBOutlet weak var angerSwitch: UISwitch!
    @IBOutlet weak var surpriseSwitch: UISwitch!
    
    @IBOutlet weak var sadnessLabel: UILabel!
    @IBOutlet weak var joyLabel: UILabel!
    @IBOutlet weak var angerLabel: UILabel!
    @IBOutlet weak var surpriseLabel: UILabel!
    
    var chartArray = Array<(Double, [String: AnyObject])>()
    
    //Chart variables
    let ys1 = DataManager.sharedInstance.sadnessData
    let ys2 = DataManager.sharedInstance.joyData
    let ys3 = DataManager.sharedInstance.angerData
    let ys4 = DataManager.sharedInstance.surpriseData
    
    var yse1: [ChartDataEntry]?
    var yse2: [ChartDataEntry]?
    var yse3 : [ChartDataEntry]?
    var yse4 : [ChartDataEntry]?
    
    var ds1: LineChartDataSet?
    var ds2: LineChartDataSet?
    var ds3: LineChartDataSet?
    var ds4: LineChartDataSet?
    
    let chartData = LineChartData()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        print("DataViewController chartData count: \(DataManager.sharedInstance.chartDictionary.count)")
        print("Sadness data: \(DataManager.sharedInstance.sadnessData)")
        print("Joy data: \(DataManager.sharedInstance.joyData)")
        print("Anger data: \(DataManager.sharedInstance.angerData)")
        
        lineChart.delegate = self
        
        yse1 = ys1.enumerated().map { x, y in return ChartDataEntry(x: Double(x), y: y) }
        yse2 = ys2.enumerated().map { x, y in return ChartDataEntry(x: Double(x), y: y) }
        yse3 = ys3.enumerated().map { x, y in return ChartDataEntry(x: Double(x), y: y) }
        yse4 = ys4.enumerated().map { x, y in return ChartDataEntry(x: Double(x), y: y) }
        
        //switch initialization
        sadnessSwitch.tag = 1
        joySwitch.tag = 2
        angerSwitch.tag = 3
        surpriseSwitch.tag = 4
        
        sadnessSwitch.onTintColor = UIColor.blue
        joySwitch.onTintColor = UIColor.green
        angerSwitch.onTintColor = UIColor.red
        surpriseSwitch.onTintColor = UIColor.yellow
        
        setUpChart()
    }
    
    func setUpChart() {
        //Setting up the chart
        ds1 = LineChartDataSet(values: yse1, label: nil)
        ds1?.circleColors = [UIColor.blue]
        ds1?.circleRadius = 2
        ds1?.colors = [UIColor.blue]
        chartData.addDataSet(ds1)
        
        ds2 = LineChartDataSet(values: yse2, label: nil)
        ds2?.circleColors = [UIColor.green]
        ds2?.circleRadius = 2
        ds2?.colors = [UIColor.green]
        chartData.addDataSet(ds2)
        
        ds3 = LineChartDataSet(values: yse3, label: nil)
        ds3?.circleColors = [UIColor.red]
        ds3?.circleRadius = 2
        ds3?.colors = [UIColor.red]
        chartData.addDataSet(ds3)
        
        ds4 = LineChartDataSet(values: yse4, label: nil)
        ds4?.circleColors = [UIColor.yellow]
        ds4?.circleRadius = 2
        ds4?.colors = [UIColor.yellow]
        chartData.addDataSet(ds4)
        
        self.lineChart.data = chartData
        self.lineChart.gridBackgroundColor = NSUIColor.white
        self.lineChart.chartDescription?.text = "Emotion data"
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        print("Time data count: \(DataManager.sharedInstance.timeData.count)")
        print("Sadness data count: \(DataManager.sharedInstance.sadnessData.count)")
    }


//    func addNewFormattedData(data: LineChartDataSet, color: UIColor, radius: Int) {
//        
//        ds3 = LineChartDataSet(values: yse3, label: nil)
//        ds3?.circleColors = [UIColor.red]
//        ds3?.circleRadius = 2
//        ds3?.colors = [UIColor.red]
//        chartData.addDataSet(ds3)
//        
//    }
    
    //Adjusting which data sets are visible
    @IBAction func switchPressed(sender: UISwitch) {
        switch(sender.tag) {
            case 1:
                if sender.isOn == false {
                    sadnessLabel.animateOpacity(alpha: 0.5)
                    self.chartData.removeDataSet(ds1)
                    self.lineChart.notifyDataSetChanged()
                } else {
                    sadnessLabel.animateOpacity(alpha: 1.0)
                    self.chartData.addDataSet(ds1)
                    self.lineChart.notifyDataSetChanged()
                }
            case 2:
                if sender.isOn == false {
                    joyLabel.animateOpacity(alpha: 0.5)
                    self.chartData.removeDataSet(ds2)
                    self.lineChart.notifyDataSetChanged()
                } else {
                    joyLabel.animateOpacity(alpha: 1.0)
                    self.chartData.addDataSet(ds2)
                    self.lineChart.notifyDataSetChanged()
                }
            case 3:
                if sender.isOn == false {
                    angerLabel.animateOpacity(alpha: 0.5)
                    self.chartData.removeDataSet(ds3)
                    self.lineChart.notifyDataSetChanged()
                } else {
                    angerLabel.animateOpacity(alpha: 1.0)
                    self.chartData.addDataSet(ds3)
                    self.lineChart.notifyDataSetChanged()
                }
            case 4:
                if sender.isOn == false {
                    surpriseLabel.animateOpacity(alpha: 0.5)
                    self.chartData.removeDataSet(ds4)
                    self.lineChart.notifyDataSetChanged()
                } else {
                    surpriseLabel.animateOpacity(alpha: 1.0)
                    self.chartData.addDataSet(ds4)
                    self.lineChart.notifyDataSetChanged()
                }
            default:
                break
        }
        
    }
}

extension DataViewController: ChartViewDelegate {
    
    func chartValueSelected(chartView: ChartViewBase, entry: ChartDataEntry, dataSetIndex: Int, highlight: Highlight) {
    }
    
}

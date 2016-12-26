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

    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var graphChart: ORKLineGraphChartView!
    
    @IBOutlet weak var sadnessSwitch: UISwitch!
    @IBOutlet weak var joySwitch: UISwitch!
    @IBOutlet weak var angerSwitch: UISwitch!
    
    @IBOutlet weak var sadnessLabel: UILabel!
    @IBOutlet weak var joyLabel: UILabel!
    @IBOutlet weak var angerLabel: UILabel!
    static var sliderDelegate: UISliderDelegate?
    
    let graphDataSource = GraphDataSource.sharedInstance
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        print("DataViewController chartData count: \(DataManager.sharedInstance.chartDictionary.count)")
        
        print("Sadness data: \(GraphDataSource.sharedInstance.sadnessData)")
        print("Joy data: \(GraphDataSource.sharedInstance.joyData)")
        print("Anger data: \(GraphDataSource.sharedInstance.angerData)")
        
        //switch initialization
        sadnessSwitch.tag = 1
        joySwitch.tag = 2
        angerSwitch.tag = 3
        
        //nice orange: UIColor().fromHex(hexString: "FFA470", alpha: 1.0)
        sadnessSwitch.onTintColor = UIColor.blue
        joySwitch.onTintColor = UIColor.green
        angerSwitch.onTintColor = UIColor.red
        
        graphChart.dataSource = graphDataSource
        graphChart.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        slider.maximumValue = Float(Double(DataManager.sharedInstance.timeData.count)/(10.0))
        slider.value = (slider.maximumValue/2)
        
        print("Time data count: \(DataManager.sharedInstance.timeData.count)")
        print("Sadness data count: \(GraphDataSource.sharedInstance.sadnessData.count)")
        
    }
    @IBAction func sliderValueChanged(_ sender: UISlider) {
        let value = sender.value
        DataViewController.sliderDelegate?.sliderDidChange(value: (value*10))
    }
    
    //some visual stuff
    @IBAction func switchPressed(sender: UISwitch) {
        switch(sender.tag) {
            case 1:
                if sender.isOn == false {
                    sadnessLabel.animateOpacity(alpha: 0.5)
                } else {
                    sadnessLabel.animateOpacity(alpha: 1.0)
                }
            case 2:
                if sender.isOn == false {
                    joyLabel.animateOpacity(alpha: 0.5)
                } else {
                    joyLabel.animateOpacity(alpha: 1.0)
                }
            case 3:
                if sender.isOn == false {
                    angerLabel.animateOpacity(alpha: 0.5)
                } else {
                    angerLabel.animateOpacity(alpha: 1.0)
                }
            default:
                break
        }
        
    }
    
}

extension DataViewController: ORKGraphChartViewDelegate {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
}


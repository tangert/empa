//
//  AddPatientViewController.swift
//  empa2
//
//  Created by Tyler Angert on 12/30/16.
//  Copyright © 2016 Tyler Angert. All rights reserved.
//

import Foundation
import UIKit

let INSETS = UIEdgeInsetsMake(5,5,5,5)

class CreateTestSubjectViewController: UITableViewController {
    
    // MARK: IBOutlets
    // Basic info
    @IBOutlet weak var firstNameEntry: UITextField!
    @IBOutlet weak var lastNameEntry: UITextField!
    
    @IBOutlet weak var sexLabel: UILabel!
    @IBOutlet weak var sexPicker: UISwitch! {
        didSet {
            sexPicker.backgroundColor = EMPA_BLUE.withAlphaComponent(0.8)
            sexPicker.onTintColor = UIColor.red.withAlphaComponent(0.75)
            sexPicker.layer.cornerRadius = 16.0
        }
    }
    
    @IBOutlet weak var DOBLabel: UILabel!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    // Experimental data
    @IBOutlet weak var neuroDevLabel: UILabel!
    @IBOutlet weak var neuroDevPicker: UISwitch!
    
    @IBOutlet weak var testGroupLabel: UILabel!
    @IBOutlet weak var controlBtn: UIButton! {
        didSet {
            controlBtn.layer.cornerRadius = 10
            controlBtn.tag = 0
            controlBtn.layer.borderColor = EMPA_BLUE.cgColor
            controlBtn.layer.borderWidth = 1
            controlBtn.contentEdgeInsets = INSETS
        }
    }
    @IBOutlet weak var exp1Btn: UIButton! {
        didSet {
            exp1Btn.layer.cornerRadius = 10
            exp1Btn.tag = 1
            exp1Btn.layer.borderColor = EMPA_BLUE.cgColor
            exp1Btn.layer.borderWidth = 1
            exp1Btn.contentEdgeInsets = INSETS
        }
    }
    @IBOutlet weak var exp2Btn: UIButton! {
        didSet {
           exp2Btn.layer.cornerRadius = 10
           exp2Btn.tag = 2
           exp2Btn.layer.borderColor = EMPA_BLUE.cgColor
           exp2Btn.layer.borderWidth = 1
           exp2Btn.contentEdgeInsets = INSETS
        }
    }
    @IBOutlet weak var exp3Btn: UIButton! {
        didSet {
            exp3Btn.layer.cornerRadius = 10
            exp3Btn.tag = 3
            exp3Btn.layer.borderColor = EMPA_BLUE.cgColor
            exp3Btn.layer.borderWidth = 1
            exp3Btn.contentEdgeInsets = INSETS
        }
    }
    
    @IBOutlet weak var createTestSubjectBtn: UIButton! {
        didSet{
           createTestSubjectBtn.layer.cornerRadius = 10
        }
    }
    
    // MARK: Other properties
    var fname: String!
    var lname: String!
    var chosenSex: String!
    var chosenDOB: Date!
    var chosenTestGroup: Int!
    var ASD: Bool!
    
    var currentButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Loaded CreateTestSubject VC")
        
        // Variable initialization
        fname = ""
        lname = ""
        chosenSex = "F"
        chosenDOB = datePicker.date
        chosenTestGroup = 0
        ASD = neuroDevPicker.isOn
        
        currentButton = controlBtn
    }
    
    // MARK: IBActions
    
    @IBAction func createTestSubjectPressed(_ sender: Any) {
        print("About to create test subject")
        
        guard nameFieldsValid() else {
            return
        }
        
        let testSubject = TestSubject(fname: fname,
                                      lname: lname,
                                      sex: chosenSex,
                                      DOB: chosenDOB,
                                      testGroup: chosenTestGroup,
                                      ASD: ASD)
        
        DataManager.sharedInstance.createTestSubject(testSubject: testSubject)
    }
    
    @IBAction func firstNameEditEnd(_ sender: UITextField) {
        fname = sender.text!
    }
    
    @IBAction func lastNameEditEnd(_ sender: UITextField) {
        lname = sender.text!
    }
    
    @IBAction func sexChanged(_ sender: UISwitch) {
        if(sender.isOn) {
            chosenSex = "F"
        } else {
            chosenSex = "M"
        }
    }
    
    @IBAction func DOBChanged(_ sender: UIDatePicker) {
        chosenDOB = sender.date
    }
    
    @IBAction func neuroDevChanged(_ sender: UISwitch) {
        if(sender.isOn) {
            ASD = true
        } else {
            ASD = false
        }
    }
    
    @IBAction func testGroupButtonPressed(_ sender: UIButton) {
        
        turnOffStyle(button: currentButton)
        turnOnStyle(button: sender)
        
        chosenTestGroup = sender.tag
        currentButton = sender
    }
    
    
    // MARK: Helper methods
    // Buttons
    func turnOnStyle(button: UIButton) {
        UIView.animate(withDuration: 0.2) {
            button.backgroundColor = EMPA_BLUE
            button.setTitleColor(UIColor.white, for: .normal)
        }
        
    }
    
    func turnOffStyle(button: UIButton) {
        UIView.animate(withDuration: 0.2) {
            button.backgroundColor = UIColor.white
            button.setTitleColor(EMPA_BLUE, for: .normal)
        }
    }
    
    // Field Validation
    
    func nameFieldsValid() -> Bool {
        guard firstNameEntry.text != "" else {
            return false
        }
        
        guard lastNameEntry.text != "" else {
            return false
        }
        
        print("Valid")
        return true
    }
}

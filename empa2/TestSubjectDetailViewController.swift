//
//  TestSubjectDetailViewController.swift
//  empa2
//
//  Created by Tyler Angert on 10/10/17.
//  Copyright © 2017 Tyler Angert. All rights reserved.
//

import Foundation
import UIKit

class TestSubjectDetailViewController: UIViewController {
    
    var testSubject: TestSubject?
    
    // MARK: IBOutlets
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var sexLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var ASDLabel: UILabel!
    @IBOutlet weak var testGroupLabel: UILabel!
    @IBOutlet weak var testGroupNumberLabel: UILabel! {
        didSet {
            testGroupNumberLabel.layer.cornerRadius = 5
            testGroupNumberLabel.backgroundColor = EMPA_BLUE
            testGroupNumberLabel.textColor = UIColor.white
        }
    }
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var startNewSessionBtn: UIButton! {
        didSet {
            startNewSessionBtn.layer.cornerRadius = 10
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let testSubject = testSubject {
            nameLabel.text = "\(testSubject.fname!) \(testSubject.lname!)"
            sexLabel.text = "Sex: \(testSubject.sex!)"
            ageLabel.text = "Age: \(testSubject.age!)"
            ASDLabel.text = testSubject.ASD! == true ? "ASD" : "NTD"
            testGroupNumberLabel.text = "\(testSubject.testGroup)"
        }
    }
    
}

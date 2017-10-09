//
//  AddPatientViewController.swift
//  empa2
//
//  Created by Tyler Angert on 12/30/16.
//  Copyright © 2016 Tyler Angert. All rights reserved.
//

import Foundation
import UIKit

class AddPatientViewController: UIViewController {
    
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var firstNameText: UITextField!
    @IBOutlet weak var lastNameText: UITextField!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    var newSubject: TestSubject?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard firstNameText.text != nil else {
            print("Please put in a firstname")
            return
        }
        
         newSubject = TestSubject.init(firstName: firstNameText.text!, lastName: lastNameText.text!)
        
    
    }
    
    @IBAction func savePatient(_ sender: Any) {
        newSubject?.firstName = firstNameText.text
        newSubject?.lastName = lastNameText.text
    }
    
}

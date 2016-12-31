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
    
    var newPatient: Patient?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard firstNameText.text != nil else {
            print("Please put in a firstname")
            return
        }
        
         newPatient = Patient.init(firstName: firstNameText.text!, lastName: lastNameText.text!)
        
    
    }
    
    @IBAction func savePatient(_ sender: Any) {
        newPatient?.firstName = firstNameText.text
        newPatient?.lastName = lastNameText.text
    }
    
}

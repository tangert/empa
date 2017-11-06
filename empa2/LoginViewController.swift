//
//  LoginViewController.swift
//  empa2
//
//  Created by Tyler Angert on 10/9/17.
//  Copyright © 2017 Tyler Angert. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseAuth

class LoginViewController: UIViewController {
    
    // MARK: Constants
    let login = "loginToTestSubjects"

    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var loginButton: UIButton! {
        didSet {
            loginButton.layer.cornerRadius = 10
        }
    }
    
    @IBAction func pressLogin(_ sender: Any) {
        Auth.auth().signIn(withEmail: emailField.text!,
                               password: passwordField.text!)

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Loaded login")
        
        Auth.auth().addStateDidChangeListener { (auth, user) in
            if user != nil {
                self.performSegue(withIdentifier: self.login, sender: nil)
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.passwordField.text = ""
    }
    
    
}

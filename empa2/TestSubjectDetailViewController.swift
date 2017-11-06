//
//  TestSubjectDetailViewController.swift
//  empa2
//
//  Created by Tyler Angert on 10/10/17.
//  Copyright © 2017 Tyler Angert. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase
import UIKit

class TestSubjectDetailViewController: UIViewController {
    
    // MARK: Unique identifiers
    var testSubject: TestSubject!
    var sessions: [Session]! = []
    var sessionNib: UINib? = UINib(nibName: "SessionCell", bundle: nil)

    // MARK: IBOutlets
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var sexLabel: UILabel! {
        didSet {
            
            sexLabel.textColor = UIColor.white
            
            if testSubject.sex == "F" {
                sexLabel.backgroundColor = UIColor.red.withAlphaComponent(0.5)
            } else {
                sexLabel.backgroundColor = EMPA_BLUE.withAlphaComponent(0.5)
            }
            
            sexLabel.layer.cornerRadius = 5
            sexLabel.clipsToBounds = true
            
         }
    }
    @IBOutlet weak var ageLabel: UILabel! {
        didSet {
            ageLabel.layer.cornerRadius = 5
            ageLabel.clipsToBounds = true
        }
    }
    @IBOutlet weak var ASDLabel: UILabel! {
        didSet {
            ASDLabel.layer.cornerRadius = 5
            ASDLabel.clipsToBounds = true
        }
    }
    @IBOutlet weak var testGroupLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var startNewSessionBtn: UIButton! {
        didSet {
            startNewSessionBtn.layer.cornerRadius = 10
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sessionsRef.observe(.value, with: { (snapshot) in
            
            guard snapshot.exists() else {
                //For edge case when removed all nodes
                self.sessions.removeAll()
                self.tableView?.reloadData()
                return
            }
            
            
            for child in snapshot.children.allObjects {
                
                let session = child as! DataSnapshot
                let newSession = Session.init(snapshot: session)
                self.sessions.append(newSession)
            }
            
            
//           self.sessions = newSessions
            self.tableView.reloadData()
        })
        
        
        if let testSubject = testSubject {
            nameLabel.text = "\(testSubject.fname!) \(testSubject.lname!)"
            sexLabel.text = "\(testSubject.sex!)"
            ageLabel.text = "Age: \(testSubject.age!)"
            ASDLabel.text = testSubject.ASD! == true ? "ASD" : "NTD"
            
            var groupLabelText:String = ""
            
            switch(testSubject.testGroup.subjectType()){
            case .control:
                groupLabelText = "Control"
            case .happy:
                groupLabelText = "☺️"
            case .sad:
                groupLabelText = "😞"
            default:
                groupLabelText = "Control"
            }
            
            testGroupLabel.text = "Test Group: \(groupLabelText)"
        }
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(sessionNib, forCellReuseIdentifier: "sessionCell")
    }
    
    // MARK: IBActions
    
    @IBAction func startNewSessionPress(_ sender: Any) {
        performSegue(withIdentifier: "sessionViewControllerSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if(segue.identifier == "sessionViewControllerSegue") {
            let dest = segue.destination as! SessionViewController
            
            if let testSubject = self.testSubject {
                dest.testSubject = testSubject
            }
        }
    }
    
    // MARK: Unwind
    
    @IBAction func unwindToPrevWithSegue(_ segue: UIStoryboardSegue) {
        print("Back in the FirstViewController")
    }
    
}

extension TestSubjectDetailViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: SessionCell = tableView.dequeueReusableCell(withIdentifier: "sessionCell", for: indexPath) as! SessionCell
        //How to initialize the session?
        cell.selectionStyle = .none
        cell.sessionNumberLabel.text = "Session: \(indexPath.row + 1)"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
}

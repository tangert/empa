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
    @IBOutlet weak var testGroupLabel: UILabel! {
        didSet {
            testGroupLabel.layer.cornerRadius = 5
            testGroupLabel.clipsToBounds = true
        }
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var startNewSessionBtn: UIButton! {
        didSet {
            startNewSessionBtn.layer.cornerRadius = 10
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        //remove observers
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        sessionsRef.observeSingleEvent(of: .value, with: { (snapshot) in
            
            guard snapshot.exists() else {
                //For edge case when removed all nodes
                self.sessions.removeAll()
                self.tableView?.reloadData()
                return
            }
            
            var newSessions: [Session] = []
            
            for child in snapshot.children.allObjects {
                
                let session = child as! DataSnapshot
                let newSession = Session.init(snapshot: session)
                
                print("new session: \(newSession.toString())")
                
                if newSession.userID == self.testSubject.id {
                    newSessions.append(newSession)
                }
                
            }
            
            self.sessions = newSessions
            self.tableView.reloadData()
            
        })
        
//        sessionsRef.observeSingleEvent(of: .childRemoved, with: { (snapshot) in
//
//            print("child removing")
//
//            guard snapshot.exists() else {
//                return
//            }
//
////            print("REMOVAL SNAPSHOT: \(snapshot)")
//
//            var removedIDs: [String] = []
//
//            for child in snapshot.children.allObjects {
//
//                let session = child as! DataSnapshot
//                let sessionToRemove = Session.init(snapshot: session)
//
//
//                print("session to remove: \(sessionToRemove.toString())")
//
//                removedIDs.append(sessionToRemove.sessionID)
//
//            }
//
//            let filteredSessions = self.sessions.filter({ (session:Session) -> Bool in
//                return !removedIDs.contains(session.sessionID)
//            })
//
//            print("filtered: \(filteredSessions)")
//
//            self.sessions = filteredSessions
//            self.tableView.reloadData()
//
//        })
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        
        DataManager.sharedInstance.didFinishSession()

    }
    
}

extension TestSubjectDetailViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // FIXME: Session count
        return self.sessions.count
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if (editingStyle == UITableViewCellEditingStyle.delete) {
            DataManager.sharedInstance.deleteSession(id: sessions[indexPath.row].sessionID!)
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: SessionCell = tableView.dequeueReusableCell(withIdentifier: "sessionCell", for: indexPath) as! SessionCell
        //How to initialize the session?
        cell.selectionStyle = .none
        cell.sessionNumberLabel.text = "Session: \(indexPath.row + 1)"
        cell.sessionLengthLabel.text = "Length: \(sessions[indexPath.row].sessionLength!.rounded())s"
        
        cell.averageRatingLabel.text = "No scores"
        
        if let avgScore = sessions[indexPath.row].averageScore {
            cell.averageRatingLabel.text = "Average: \(avgScore.rounded())"
            cell.averageRatingLabel.textColor = colorInBetween(color1: FAILURE_RED, color2: EMPA_BLUE, percent: CGFloat(avgScore/100))
        }
        
        cell.timestampLabel.text = "\(sessions[indexPath.row].startDateTimeString!)"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
}

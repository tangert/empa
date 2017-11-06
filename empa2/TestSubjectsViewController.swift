//
//  AllPatientsViewController.swift
//  empa2
//
//  Created by Tyler Angert on 12/30/16.
//  Copyright © 2016 Tyler Angert. All rights reserved.
//

import Foundation
import UIKit
import FirebaseAuth
import Firebase
import FirebaseDatabase

class TestSubjectsViewController: UICollectionViewController {
    
    var testSubjects: [TestSubject]! = []
    var selectedTestSubject: TestSubject!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        testSubjectRef.observe(.value, with: { (snapshot) in
            
            guard snapshot.exists() else {
                //For edge case when removed all nodes
                self.testSubjects.removeAll()
                self.collectionView?.reloadData()
                return
            }
            
            var newSubjects: [TestSubject] = []
            
            for child in snapshot.children.allObjects {
                
                let testSubject = child as! DataSnapshot
                let newTestSubject = TestSubject.init(snapshot: testSubject)
                newSubjects.append(newTestSubject)
            }
            
            self.testSubjects = newSubjects
            self.collectionView?.reloadData()
            print("Test Subjects: \(self.testSubjects)")
        })
        
        
        let width = collectionView!.frame.width
        let itemWidth = width/3
        let inset = width/4 - itemWidth/2
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: inset*1.5, bottom: 0, right: inset*1.5)
        layout.itemSize = CGSize(width: itemWidth, height: itemWidth*1.25)
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = inset
        collectionView!.collectionViewLayout = layout
        collectionView!.contentInset = UIEdgeInsetsMake(inset, 0, 0, 0)
    }
    
    // MARK: Unwind
    
    @IBAction func unwindToPrevWithSegue(_ segue: UIStoryboardSegue) {
        print("Back in the FirstViewController")
    }
    
    //MARK: UICollectionView DataSource + Delegate
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return testSubjects.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell: TestSubjectCell = collectionView.dequeueReusableCell(withReuseIdentifier: "testSubjectCell", for: indexPath) as! TestSubjectCell
        
        let testSubject = testSubjects[indexPath.row]
        
        //FIXME: Format date into age
        cell.testSubject = testSubject
        cell.delegate = self
        cell.nameLabel.text! = "\(testSubject.fname!) \(testSubject.lname!)"
        cell.ASDLabel.text! = testSubject.ASD == true ? "ASD" : "NTD"

        let testGroup: String!
        
        switch(testSubject.testGroup.subjectType()){
            case .control:
            testGroup = "Control"
            case .happy:
            testGroup = "☺️"
            case .sad:
            testGroup = "😞"
            default:
            testGroup = "Control"
        }
        
        cell.testGroupLabel.text! = testGroup
        
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedTestSubject = testSubjects[indexPath.row]
        performSegue(withIdentifier: "testSubjectDetailSegue", sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("CURRENT: \(selectedTestSubject)")
        
        if(segue.identifier == "testSubjectDetailSegue") {
            let testSubjectDetail = segue.destination as! TestSubjectDetailViewController
            testSubjectDetail.testSubject = selectedTestSubject
        }
    }
    
    // MARK: IBActions
    @IBAction func logoutPress(_ sender: Any) {
        do {
            try Auth.auth().signOut()
            self.presentingViewController?.dismiss(animated: true, completion: nil)
        } catch {
            print("Couldn't sign out")
        }
    }
    
}

extension TestSubjectsViewController: TestSubjectCellDelegate {
    func showAlert(title: String, message: String, testSubject: TestSubject) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { (action) in
            DataManager.sharedInstance.deleteTestSubject(id: testSubject.id)
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
        self.collectionView?.viewController?.present(alert, animated: true, completion: nil)
    }
}

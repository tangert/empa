//
//  AllPatientsViewController.swift
//  empa2
//
//  Created by Tyler Angert on 12/30/16.
//  Copyright © 2016 Tyler Angert. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseDatabase

class TestSubjectsViewController: UICollectionViewController {
    
    var testSubjects: [TestSubject]! = []
    var selectedTestSubject: TestSubject!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        testSubjectRef.observe(.value, with: { (snapshot) in
            
            guard snapshot.exists() else {
                return
            }
            
            if snapshot.childrenCount > 0 {
                
                var newSubjects: [TestSubject] = []
                for child in snapshot.children.allObjects {
                    
                    let testSubject = child as! DataSnapshot
                    let newTestSubject = TestSubject.init(snapshot: testSubject)
                    newSubjects.append(newTestSubject)
                }
                
                self.testSubjects = newSubjects
                self.collectionView?.reloadData()
                
                print("Test Subjects: \(self.testSubjects)")
                
            } else {
                print("No children!")
            }
        })
        
        
        let width = collectionView!.frame.width
        let inset = width/4 - width/6
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: inset, bottom: 0, right: inset)
        layout.itemSize = CGSize(width: width/3, height: width/3)
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = width/3
        collectionView!.collectionViewLayout = layout
        collectionView!.contentInset = UIEdgeInsetsMake(inset, 0, 0, 0)
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
        
        cell.nameLabel.text! = "\(testSubject.fname!) \(testSubject.lname!)"
        cell.testGroupLabel.text! = "Test Group: \(testSubject.testGroup!)"
        cell.ASDLabel.text! = testSubject.ASD == true ? "ASD" : "NTD"
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = collectionView.frame.width
        return CGSize(width: width/2.5, height: width/2)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
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
    
}

extension TestSubjectsViewController: UICollectionViewDelegateFlowLayout {
    
}

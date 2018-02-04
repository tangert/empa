//
//  TestSubjectCell.swift
//  empa2
//
//  Created by Tyler Angert on 10/9/17.
//  Copyright © 2017 Tyler Angert. All rights reserved.
//

import Foundation
import UIKit

class TestSubjectCell: UICollectionViewCell {
    
    var testSubject: TestSubject!
    var delegate: TestSubjectCellDelegate?
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var testGroupLabel: UILabel!
    @IBOutlet weak var ASDLabel: UILabel!
    @IBOutlet weak var deleteButton: UIButton! {
        
        didSet {
            deleteButton.layer.cornerRadius = deleteButton.frame.width/2
            deleteButton.backgroundColor = UIColor.red.withAlphaComponent(0.75)
            deleteButton.dropShadow(radius: 10)
            
            deleteButton.layer.opacity = 0
            deleteButton.isUserInteractionEnabled = false
            
        }
        
    }
    
    override func awakeFromNib() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.showDeleteButton), name: NSNotification.Name(rawValue: "editingTestSubjects"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.hideDeleteButton), name: NSNotification.Name(rawValue: "savingTestSubjects"), object: nil)

        
        self.layer.opacity = 0

        UIView.animate(withDuration: 0.2) {
            self.layer.opacity = 1
        }
        
        self.layer.cornerRadius = 10
        self.layer.backgroundColor = UIColor.white.cgColor
        self.layer.borderColor = UIColor.black.withAlphaComponent(0.05).cgColor
        self.layer.borderWidth = 2
        self.layer.dropShadow(radius: 10)

    }
    
    func showDeleteButton() {
        UIView.animate(withDuration: 0.2) {
            self.deleteButton.layer.opacity = 1
            self.deleteButton.isUserInteractionEnabled = true
        }
    }
    
    func hideDeleteButton() {
        UIView.animate(withDuration: 0.2) {
            self.deleteButton.layer.opacity = 0
            self.deleteButton.isUserInteractionEnabled = false
        }
    }
    
    func handleTap(sender: UITapGestureRecognizer? = nil) {
        // handling code
    }
    
    @IBAction func deletePress(_ sender: Any) {
        delegate?.showAlert(title: "Delete Test Subject", message: "Are you sure you want to delete this test subject and all of their data?", testSubject: self.testSubject)
    }

}

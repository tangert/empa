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
        }
    }
    
    override func awakeFromNib() {
        
        self.layer.opacity = 0

        UIView.animate(withDuration: 0.2) {
            self.layer.opacity = 1
        }
        
        self.layer.cornerRadius = 10
        self.layer.backgroundColor = UIColor.white.cgColor
        self.dropShadow(radius: 7.5)
    }
    
    func handleTap(sender: UITapGestureRecognizer? = nil) {
        // handling code
    }
    
    @IBAction func deletePress(_ sender: Any) {
        delegate?.showAlert(title: "Delete Test Subject", message: "Are you sure you want to delete this test subject and all of their data?", testSubject: self.testSubject)
    }

}

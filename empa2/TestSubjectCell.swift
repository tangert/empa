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
        
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var testGroupLabel: UILabel!
    @IBOutlet weak var ASDLabel: UILabel!
    
    override func awakeFromNib() {
        self.layer.borderColor = EMPA_BLUE.cgColor
        self.layer.borderWidth = 2
        self.layer.cornerRadius = 10
    }
    
}

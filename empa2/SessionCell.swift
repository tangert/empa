//
//  SessionCell.swift
//  empa2
//
//  Created by Tyler Angert on 12/30/16.
//  Copyright © 2016 Tyler Angert. All rights reserved.
//

import Foundation
import UIKit

class SessionCell: UITableViewCell {
    
    var session: Session!
    
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var sessionNumberLabel: UILabel! {
        didSet {
            sessionNumberLabel.layer.cornerRadius=5
            sessionNumberLabel.clipsToBounds = true
        }
    }
    @IBOutlet weak var sessionLengthLabel: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!
    @IBOutlet weak var averageRatingLabel: UILabel! {
        didSet {
            averageRatingLabel.layer.cornerRadius = 5
            averageRatingLabel.clipsToBounds = true
        }
    }
    
    override func awakeFromNib() {
        self.bgView.layer.cornerRadius = 10
        self.bgView.dropShadow(radius: 10)
        
        self.layer.opacity = 0
        
        UIView.animate(withDuration: 0.2) {
            self.layer.opacity = 1
        }
    }
    
}

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
    @IBOutlet weak var sessionNumberLabel: UILabel!
    @IBOutlet weak var sessionLengthLabel: UILabel!
    @IBOutlet weak var timeStampLabel: UILabel!
    
    @IBOutlet weak var joyCountLabel: UILabel!
    @IBOutlet weak var sadCountLabel: UILabel!
    @IBOutlet weak var angerCountLabel: UILabel!
    @IBOutlet weak var confusionCountLabel: UILabel!
    
    override func awakeFromNib() {
        self.bgView.layer.cornerRadius = 10
        self.bgView.dropShadow(radius: 10)
        //here is when you intiialize each parameter with the session data.
    }
    
}

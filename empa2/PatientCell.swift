//
//  PatientCell.swift
//  empa2
//
//  Created by Tyler Angert on 12/30/16.
//  Copyright © 2016 Tyler Angert. All rights reserved.
//

import Foundation
import UIKit

class PatientCell: UICollectionViewCell {
    
    @IBOutlet weak var background: UIVisualEffectView!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var patientNameLabel: UILabel!
    @IBOutlet weak var sessionTimeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        image.layer.cornerRadius = image.frame.width/2
        
        background.layer.cornerRadius = 5
        background.clipsToBounds = true
    }
    
}

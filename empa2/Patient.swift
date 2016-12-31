//
//  Patient.swift
//  empa2
//
//  Created by Tyler Angert on 12/28/16.
//  Copyright © 2016 Tyler Angert. All rights reserved.
//

import Foundation
import UIKit

struct Patient {
	
    var image: UIImage?
    var firstName: String?
    var lastName: String?
    
    init(firstName: String, lastName: String) {
        self.firstName = firstName
        self.lastName = lastName
    }

}

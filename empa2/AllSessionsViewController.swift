//
//  AllSessionsViewController.swift
//  empa2
//
//  Created by Tyler Angert on 12/30/16.
//  Copyright © 2016 Tyler Angert. All rights reserved.
//

import Foundation
import UIKit

class AllSessionsViewController: UITableViewController {
    
    var sessionCellNib: UINib? = UINib(nibName: "SessionCell", bundle: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.register(sessionCellNib, forCellReuseIdentifier: "sessionCell")
    }
}

//
//  Timer.swift
//  empa2
//
//  Created by Tyler Angert on 12/24/16.
//  Copyright © 2016 Tyler Angert. All rights reserved.
//

import Foundation

protocol GameTimerDelegate {
    func gameTimerDidFinish()
}

class GameTimer: Timer {
    
    var delegate: GameTimerDelegate?
    
}

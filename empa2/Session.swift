//
//  Session.swift
//  empa2
//
//  Created by Tyler Angert on 12/28/16.
//  Copyright © 2016 Tyler Angert. All rights reserved.
//

import Foundation

class Session {

	var sessionLength: Double?
	var emotionData = Array<[String: AnyObject]>()
	var sadnessData = [Double]()
    var joyData = [Double]()
    var angerData = [Double]()
    var surpriseData = [Double]()

}
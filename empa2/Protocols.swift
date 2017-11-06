//
//  Protocols.swift
//  empa2
//
//  Created by Tyler Angert on 12/25/16.
//  Copyright © 2016 Tyler Angert. All rights reserved.
//

import Foundation
import UIKit

protocol DataManagerDelegate {
    func didGetEmotionData(data: [String: AnyObject])
    func didGetExpressionData(data: [String: AnyObject])
    func didExportData()
    func didUpdateTimer(counter: Double)
}

protocol UpdateCameraFeedDelegate {
    func willUpdateCameraFeed(image: UIImage)
    func willUpdateProgress(type: subjectType, data: [String: AnyObject])
}

protocol UpdateScoreDelegate {
    func scoreDidChange(direction: String)
}
protocol TestSubjectCellDelegate {
    func showAlert(title: String, message: String, testSubject: TestSubject)
}

//this is to signify when a specific instance has loaded.
protocol LoadNibInstanceDelegate {
    func nibInstanceDidLoad()
}

protocol UISliderDelegate {
    func sliderDidChange(value: Float)
}

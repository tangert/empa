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
    func willUpdateEmojiLabel(input: String)
    func willUpdateFaceLabel(input: String)
}

protocol UpdateScoreDelegate {
    func scoreDidChange(direction: String)
}

//this is to signify when a specific instance has loaded.
protocol LoadNibInstanceDelegate {
    func nibInstanceDidLoad()
}

protocol UISliderDelegate {
    func sliderDidChange(value: Float)
}

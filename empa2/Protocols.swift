//
//  Protocols.swift
//  empa2
//
//  Created by Tyler Angert on 12/25/16.
//  Copyright © 2016 Tyler Angert. All rights reserved.
//

import Foundation
import UIKit

protocol UpdateCameraFeedDelegate {
    func willUpdateCameraFeed(image: UIImage)
    func willUpdateEmojiLabel(input: String)
    func willUpdateFaceLabel(input: String)
}

protocol DataManagerDelegate {
    //notifies the datamanager when to consolidate all data
    func didExportData()
}

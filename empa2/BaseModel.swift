//
//  BaseModel.swift
//  empa2
//
//  Created by Tyler Angert on 10/10/17.
//  Copyright © 2017 Tyler Angert. All rights reserved.
//

import Foundation

class BaseModel {
    func JSON() -> Any {
        let mirroredObject = Mirror(reflecting: self)
        var JSON: [AnyHashable: Any] = [:]
    
        for (index, attr) in mirroredObject.children.enumerated() {
            if let property_name = attr.label as String! {
            JSON[property_name] = attr.value
            }
        }
    
        return JSON
    }
}

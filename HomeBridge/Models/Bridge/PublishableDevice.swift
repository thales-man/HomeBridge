//  PublishableDevice.swift
//  HomeBridge
//
//  Created by colin on 28/04/2020.
//  Copyright © 2020 the striped lawn company. All rights reserved.
import Foundation

struct PublishableDevice: Codable {
    let id: String
    let name: String
    let type: String
    let subType: String
    let advertisedType: AdvertisedType
    let lowBatteryAlertLevel: Float
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case type
        case subType
        case advertisedType
        case lowBatteryAlertLevel
    }
    
    init(device: ManageableDevice) {
        id = device.id
        name = device.name
        type = device.type
        subType = device.subType
        advertisedType = device.advertisedType
        lowBatteryAlertLevel = device.lowBatteryAlertLevel
    }
}

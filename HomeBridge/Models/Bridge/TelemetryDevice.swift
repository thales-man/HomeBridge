//  TelemetryDevice.swift
//  HomeBridge
//
//  Created by colin on 27/04/2020.
//  Copyright © 2020 the striped lawn company. All rights reserved.
import Foundation

struct TelemetryDevice: Decodable {
    // note:
    // as the telemetry from domoticz is sorely wanting
    // i only use the id to trigger a device update
    let id: Int
    
    enum CodingKeys: String, CodingKey {
        case id = "idx"
    }
}

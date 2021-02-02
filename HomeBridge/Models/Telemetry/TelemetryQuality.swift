//  TelemetryQuality.swift
//  HomeBridge
//
//  Created by colin on 27/04/2020.
//  Copyright © 2020 the striped lawn company. All rights reserved.
import Foundation

enum TelemetryQuality: UInt8 {
    case atMostOnce = 0x0
    case atLeastOnce = 0x01
    case exactlyOnce = 0x02
}

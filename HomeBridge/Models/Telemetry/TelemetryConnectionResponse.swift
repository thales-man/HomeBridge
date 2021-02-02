//  TelemetryConnectionResponse.swift
//  HomeBridge
//
//  Created by colin on 27/04/2020.
//  Copyright © 2020 the striped lawn company. All rights reserved.
import Foundation

enum TelemetryConnectionResponse: UInt8, Error {
    case connectionAccepted = 0x00
    case badProtocol = 0x01
    case clientIDRejected = 0x02
    case serverUnavailable = 0x03
    case badUsernameOrPassword = 0x04
    case notAuthorized = 0x05
}

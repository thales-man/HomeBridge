//  TelemetryPacketType.swift
//  HomeBridge
//
//  Created by colin on 26/04/2020.
//  Copyright © 2020 the striped lawn company. All rights reserved.
import Foundation

enum TelemetryPacketType: UInt8 {
    case connect = 0x01
    case connectAcknowledgement = 0x02
    case publish = 0x03
    case publishAcknowledgement = 0x04
    // we don't do this, so we aren't interested...
    // case publishReceived = 0x05
    // case publishRelease = 0x06
    // case publishComplete = 0x07
    case subscribe = 0x08
    case subscribeAcknowledgement = 0x09
    case unSubscribe = 0x0A
    case unSubscribeAcknowledgement = 0x0B
    case pingRequest = 0x0C
    case pingAcknowledgement = 0x0D
    case disconnect = 0x0E
}

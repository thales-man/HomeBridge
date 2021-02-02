//  DisconnectTelemetryPacket.swift
//  SwiftTelemetry
//
//  Created by colin on 27/04/2020.
//  Copyright © 2020 the striped lawn company. All rights reserved.
import Foundation

class DisconnectTelemetryPacket: TelemetryPacket {
    
    init() {
        super.init(header: TelemetryPacketHeader(packetType: .disconnect, flags: 0))
    }
}

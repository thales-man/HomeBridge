//  TelemetryPacketHeader.swift
//  HomeBridge
//
//  Created by colin on 26/04/2020.
//  Copyright © 2020 the striped lawn company. All rights reserved.
import Foundation

struct TelemetryPacketHeader {
    
    let packetType: TelemetryPacketType
    let flags: UInt8
    
    init(packetType: TelemetryPacketType, flags: UInt8) {
        self.packetType = packetType
        self.flags = flags
    }
    
    init(networkByte: UInt8) {
        packetType = TelemetryPacketType(rawValue: networkByte >> 4)!
        flags = networkByte & 0x0F
    }
    
    func networkPacket() -> Data {
        var headerFirstByte = (0x0F & flags) | (packetType.rawValue << 4)
        return Data(bytes: &headerFirstByte, count: 1)
    }
}

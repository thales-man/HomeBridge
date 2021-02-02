//  SubscribeTelemetryPacket.swift
//  HomeBridge
//
//  Created by colin on 27/04/2020.
//  Copyright © 2020 the striped lawn company. All rights reserved.
import Foundation

class SubscribeTelemetryPacket: TelemetryPacket {
    
    let topics: [String: TelemetryQuality]
    let messageID: UInt16
    
    init(topics: [String: TelemetryQuality], messageID: UInt16) {
        self.topics = topics
        self.messageID = messageID
        super.init(header: TelemetryPacketHeader(packetType: .subscribe, flags: 0x02))
    }
    
    override func variableHeader() -> Data {
        var variableHeader = Data()
        variableHeader.telemetryAppend(messageID)
        return variableHeader
    }
    
    override func payload() -> Data {
        var payload = Data(capacity: 1024)
        for (key, value) in topics {
            payload.telemetryAppend(key)
            let qos = value.rawValue & 0x03
            payload.telemetryAppend(qos)
        }
        return payload
    }
}

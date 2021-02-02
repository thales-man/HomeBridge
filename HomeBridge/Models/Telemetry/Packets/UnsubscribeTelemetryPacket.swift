//  UnsubscribeTelemetryPacket.swift
//  HomeBridge
//
//  Created by colin on 26/04/2020.
//  Copyright © 2020 the striped lawn company. All rights reserved.
import Foundation

class UnsubscribeTelemetryPacket: TelemetryPacket {
    
    let topics: [String]
    let messageID: UInt16
    
    init(topics: [String], messageID: UInt16) {
        self.topics = topics
        self.messageID = messageID
        super.init(header: TelemetryPacketHeader(packetType: .unSubscribe, flags: 0x02))
    }
    
    override func variableHeader() -> Data {
        var variableHeader = Data()
        variableHeader.telemetryAppend(messageID)
        return variableHeader
    }
    
    override func payload() -> Data {
        var payload = Data(capacity: 1024)
        for topic in topics {
            payload.telemetryAppend(topic)
        }
        return payload
    }
}

//  PublishAcknowledgementTelemetryPacket.swift
//  HomeBridge
//
//  Created by colin on 27/04/2020.
//  Copyright © 2020 the striped lawn company. All rights reserved.
import Foundation

class PublishAcknowledgementTelemetryPacket: TelemetryPacket {
    
    let messageID: UInt16
    
    init(messageID: UInt16) {
        self.messageID = messageID
        super.init(header: TelemetryPacketHeader(packetType: TelemetryPacketType.publishAcknowledgement, flags: 0))
    }
    
    override func variableHeader() -> Data {
        var variableHeader = Data()
        variableHeader.telemetryAppend(messageID)
        return variableHeader
    }
}

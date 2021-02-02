//  IncomingTelemetryMessage.swift
//  HomeBridge
//
//  Created by colin on 26/04/2020.
//  Copyright © 2020 the striped lawn company. All rights reserved.
import Foundation

struct IncomingTelemetryMessage {
    
    let topic: String
    let payload: Data
    let id: UInt16
    let retain: Bool
    
    init(publishPacket: PublishTelemetryPacket) {
        self.topic = publishPacket.message.topic
        self.payload = publishPacket.message.payload
        self.id = publishPacket.messageID
        self.retain = publishPacket.message.retain
    }
    
    var stringRepresentation: String? {
        return String(data: self.payload, encoding: .utf8)
    }
}

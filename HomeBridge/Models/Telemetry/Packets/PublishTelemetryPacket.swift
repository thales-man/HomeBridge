//  PublishTelemetryPacket.swift
//  HomeBridge
//
//  Created by colin on 27/04/2020.
//  Copyright © 2020 the striped lawn company. All rights reserved.
import Foundation

final class PublishTelemetryPacket: TelemetryPacket {
    
    let messageID: UInt16
    let message: OutgoingTelemetryMessage
    
    init(theMessageID: UInt16, theMessage: OutgoingTelemetryMessage) {
        messageID = theMessageID
        message = theMessage
        super.init(header: TelemetryPacketHeader(packetType: .publish, flags: PublishTelemetryPacket.fixedHeaderFlags(for: message)))
    }
    
    init(header: TelemetryPacketHeader, networkData: Data) {
        let topicLength = 256 * Int(networkData[0]) + Int(networkData[1])
        let topicData = networkData.subdata(in: 2..<topicLength+2)
        let topic = String(data: topicData, encoding: .utf8)!
        
        var payload = networkData.subdata(in: 2+topicLength..<networkData.endIndex)
        
        let qos = TelemetryQuality(rawValue: header.flags & 0x06)!
        
        if qos != .atMostOnce {
            messageID = 256 * UInt16(payload[0]) + UInt16(payload[1])
            payload = payload.subdata(in: 2..<payload.endIndex)
        } else {
            messageID = 0
        }
        
        message = OutgoingTelemetryMessage(theTopic: topic, thePayload: payload)
        
        super.init(header: header)
    }
    
    override func variableHeader() -> Data {
        var variableHeader = Data(capacity: 1024)
        variableHeader.telemetryAppend(message.topic)
        
        if message.QoS != .atMostOnce {
            variableHeader.telemetryAppend(messageID)
        }
        
        return variableHeader
    }
    
    override func payload() -> Data {
        return message.payload
    }

    fileprivate static func fixedHeaderFlags(for message: OutgoingTelemetryMessage) -> UInt8 {
        var flags = UInt8(0)
        
        if message.retain {
            flags |= 0x01
        }
        
        flags |= message.QoS.rawValue << 1
        
        return flags
    }
}

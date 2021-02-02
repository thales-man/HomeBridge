//  ConnectTelemetryPacket.swift
//  HomeBridge
//
//  Created by colin on 27/04/2020.
//  Copyright © 2020 the striped lawn company. All rights reserved.
import Foundation

class ConnectTelemetryPacket: TelemetryPacket {
    
    let protocolName: String = "MQTT"
    let protocolLevel: UInt8 = 0x04
    
    var cleanSession: Bool
    var keepAlive: UInt16
    var clientID: String
    let username: String?
    let password: String?
    let lastWillMessage: OutgoingTelemetryMessage?
    
    init(clientID: String, cleanSession: Bool, keepAlive: UInt16, username: String?, password: String?, lastWillMessage: OutgoingTelemetryMessage? ) {
        self.cleanSession = cleanSession
        self.keepAlive = keepAlive
        self.clientID = clientID
        self.username = username
        self.password = password
        self.lastWillMessage = lastWillMessage
        
        super.init(header: TelemetryPacketHeader(packetType: .connect, flags: 0))
    }
    
    func encodedConnectFlags() -> UInt8 {
        var flags = UInt8(0)
        if cleanSession {
            flags |= 0x02
        }
        
        if let message = lastWillMessage {
            flags |= 0x04
            
            if message.retain {
                flags |= 0x20
            }
            let qos = message.QoS.rawValue
            flags |= qos << 3
        }
        
        if username != nil {
            flags |= 0x80
        }
        
        if password != nil {
            flags |= 0x40
        }
        
        return flags
    }
    
    override func variableHeader() -> Data {
        var variableHeader = Data(capacity: 1024)
        
        variableHeader.telemetryAppend(protocolName)
        variableHeader.telemetryAppend(protocolLevel)
        variableHeader.telemetryAppend(encodedConnectFlags())
        variableHeader.telemetryAppend(keepAlive)
        
        return variableHeader
    }
    
    override func payload() -> Data {
        var payload = Data(capacity: 1024)
        payload.telemetryAppend(clientID)
        
        if let message = lastWillMessage {
            payload.telemetryAppend(message.topic)
            payload.telemetryAppend(message.payload)
        }
        
        if let username = username {
            payload.telemetryAppend(username)
        }
        
        if let password = password {
            payload.telemetryAppend(password)
        }
        
        return payload
    }
}

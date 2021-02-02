//  ConnectAcknowledgementTelemetryPacket.swift
//  HomeBridge
//
//  Created by colin on 27/04/2020.
//  Copyright © 2020 the striped lawn company. All rights reserved.
import Foundation

class ConnectAcknowledgementTelemetryPacket: TelemetryPacket {
    
    let sessionPresent: Bool
    let response: TelemetryConnectionResponse
    
    init(header: TelemetryPacketHeader, networkData: Data) {
        sessionPresent = (networkData[0] & 0x01) == 0x01
        response = TelemetryConnectionResponse(rawValue: networkData[1])!
        
        super.init(header: header)
    }
}

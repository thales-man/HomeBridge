//  UnsubcribeAcknowledgementTelemetryPacket.swift
//  HomeBridge
//
//  Created by colin on 26/04/2020.
//  Copyright © 2020 the striped lawn company. All rights reserved.
import Foundation

class UnsubcribeAcknowledgementTelemetryPacket: TelemetryPacket {
    
    let messageID: UInt16
    
    init(header: TelemetryPacketHeader, networkData: Data) {
        messageID = (UInt16(networkData[0]) * UInt16(256)) + UInt16(networkData[1])
        super.init(header: header)
    }
}

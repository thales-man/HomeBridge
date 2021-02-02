//  TelemetryPacket.swift
//  HomeBridge
//
//  Created by colin on 27/04/2020.
//  Copyright © 2020 the striped lawn company. All rights reserved.
import Foundation

class TelemetryPacket {
    
    let header: TelemetryPacketHeader
    
    init(header: TelemetryPacketHeader) {
        self.header = header
    }

    // note: overrides
    func variableHeader() -> Data {
        return Data()
    }
    
    // note: overrides
    func payload() -> Data {
        return Data()
    }
    
    func networkPacket() -> Data {
        return finalPacket(variableHeader(), payload: payload())
    }
    
    // creates the packet to be sent using fixed header, variable header and payload
    // automatically encodes any remaining length
    private func finalPacket(_ variableHeader: Data, payload: Data) -> Data {
        var remainingData = variableHeader
        remainingData.append(payload)
        
        var finalPacket = Data(capacity: 1024)
        finalPacket.append(header.networkPacket())
        finalPacket.telemetryEncodeRemaining(length: remainingData.count)
        finalPacket.append(remainingData)
        
        return finalPacket
    }
}

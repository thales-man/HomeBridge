//  TelemetryRelay.swift
//  HomeBridge
//
//  Created by colin on 18/04/2020.
//  Copyright © 2020 the striped lawn company. All rights reserved.
import Foundation

final class TelemetryRelay {
    
    func send(_ packet: TelemetryPacket, write: StreamWriter) -> Bool {
        let networkPayload = packet.networkPacket()
        return networkPayload.write(to: write)
    }
    
    func parse(_ read: StreamReader) -> TelemetryPacket? {
        
        var headerByte: UInt8 = 0
        let len = read(&headerByte, 1)
        guard len > 0 else { return nil }
                
        if let packetLength = Data.readPackedLength(from: read) {
            
            let header = TelemetryPacketHeader(networkByte: headerByte)
            let data = packetLength > 0
                ? Data(len: packetLength, from: read)
                : Data()
            
            let manager = packetFactory.getTheParameterManager()
            manager.add(theHeader: header)
            manager.add(theData: data!)

            return packetFactory.createPacket(packetType: header.packetType, params: manager)
        } else {
            return nil
        }
    }
}

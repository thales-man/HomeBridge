//  BridgingTelemetryDelegate.swift
//  HomeBridge
//
//  Created by colin on 26/04/2020.
//  Copyright © 2020 the striped lawn company. All rights reserved.
import Foundation
import Logging

class BridgingTelemetryDelegate: TelemetrySessionDelegate {

    func didReceive(message: IncomingTelemetryMessage, from session: TelemetrySession) {
        if let telemetryCandidate = message.stringRepresentation {
            mediator.publish(.telemetryCandidate, theInfo: [message.topic: telemetryCandidate])
        }
        
        post(theMessage: "data received on topic \(message.topic) message \(message.stringRepresentation ?? "<>")")
    }

    func didDisconnect(session: TelemetrySession, error: TelemetryError) {
        post(theMessage: "Telemetry session disconnected.")
        
        if error != .none {
            post(theMessage: error.description)
            mediator.publish(.telemetryReset, theInfo: [:])
        }
    }

    func didAcknowledgePing(from theSession: TelemetrySession) {
        post(theMessage: "Telemetry heartbeat acknowledged.")
    }
    
    func post(theMessage: String) {
        mediator.publish(.addToConsole, theInfo: [Logger.Level.info: theMessage])
    }
}

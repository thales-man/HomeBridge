//  TelemetryService.swift
//  HomeBridge
//
//  Created by colin on 26/04/2020.
//  Copyright © 2020 the striped lawn company. All rights reserved.
import Foundation
import Logging

final class TelemetryService {
    
    private var telemetrySession: TelemetrySession
    private let sessionDelegate: BridgingTelemetryDelegate
    
    let host: String
    let channel: String
    
    init(theHost: String, theChannel: String, theTimeout: Double) {
        host = theHost
        channel = theChannel
        
        telemetrySession = TelemetrySession(host: host, connectionTimeout: theTimeout)
        sessionDelegate = BridgingTelemetryDelegate()
        telemetrySession.delegate = sessionDelegate
        
        NotificationCenter.default.addObserver(self, selector: #selector(resetConnection), name: .telemetryReset, object: nil)
        
        post(theMessage: "Initialising the telemetry service...")
    }
    
    func connectToBroker() {
        telemetrySession.connect { (error) in
            if error == .none {
                self.post(theMessage: "Telemetry connected.")
                self.subscribeTo(theChannel: self.channel)
            } else {
                self.post(theMessage: "Error occurred during telemetry connection:")
                self.post(theMessage: error.description)

                self.post(theMessage: "Telemetry connection will reset in 60 seconds")
                self.telemetrySession.disconnect()
                _ = Timer.scheduledTimer(timeInterval: 60, target: self, selector: #selector(self.fireReset), userInfo: nil, repeats: false)
            }
        }
    }
    
    func disconnect() {
        telemetrySession.disconnect()
    }
    
    func subscribeTo(theChannel: String) {
        telemetrySession.subscribe(to: theChannel, delivering: .atLeastOnce) { (error) in
            if error == .none {
                self.post(theMessage: "Telemetry subscribed to \(theChannel)")
            } else {
                self.post(theMessage: "Telemetry error occurred during subscription:")
                self.post(theMessage: error.description)
                mediator.publish(.telemetryWarning, theInfo: [:])
            }
        }
    }
    
    func ping() {
        telemetrySession.ping()
    }
    
    private func post(theMessage: String) {
        mediator.publish(.addToConsole, theInfo: [Logger.Level.info: theMessage])
    }
    
    @objc func fireReset()
    {
        resetConnection()
    }
    
    @objc func resetConnection() {
        post(theMessage: "Resetting telemetry connection..")
        mediator.publish(.telemetryWarning, theInfo: [:])

        telemetrySession = TelemetrySession(host: host)
        connectToBroker()
    }
}

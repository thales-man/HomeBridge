//  TelemetryCoordinator.swift
//  HomeBridge
//
//  Created by colin on 26/04/2020.
//  Copyright © 2020 the striped lawn company. All rights reserved.
import Foundation
import Logging

final class TelemetryCoordinator {
    private let decoder = JSONDecoder()
    private let telemetry: TelemetryService
    
    @Published var isRunning: Bool = false
    
    init() {
        telemetry = TelemetryService(theHost: configProvider.telemetryHost,
                                     theChannel: configProvider.telemetryTopic,
                                     theTimeout: configProvider.sessionTimeout)
        
        mediator.subscribe(.telemetryCandidate, theObserver: self, selector: #selector(processCandidate(_:)))
    }
    
    func start() {
        isRunning = true
        telemetry.connectToBroker()
    }
    
    func stop() {
        isRunning = false
        telemetry.disconnect()
    }
    
    func ping() {
        telemetry.ping()
    }
    
    func post(theMessage: String) {
        mediator.publish(.addToConsole, theInfo: [Logger.Level.info: theMessage])
    }
    
    @objc func processCandidate(_ notification: Notification) {
        if let data = notification.userInfo as? [String: String]
        {
            for (topic, candidate) in data
            {
                let jsonData = candidate.data(using: .utf8)!
                let device = try! decoder.decode(TelemetryDevice.self, from: jsonData)
                
                if let original = deviceProvider.devices.first(where: { $0.id == "\(device.id)" }) {
                    mediator.publish(.telemetryReceived, theInfo: [original.id: original])
                    deviceProvider.loadDevice(deviceID: "\(original.id)")
                    post(theMessage: "(\(topic)), update request for: \(original.name), id: \(original.id)")
                }
            }
        }
    }
}

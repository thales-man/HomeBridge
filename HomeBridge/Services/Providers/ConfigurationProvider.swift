//  ConfigurationProvider.swift
//  HomeBridge
//
//  Created by colin on 28/04/2020.
//  Copyright © 2020 the striped lawn company. All rights reserved.
import Foundation
import HAP

final class ConfigurationProvider: ObservableObject {
    @Published var planID: String = "2"
    @Published var automationAddress: String = "http://your_domoticz_server:here"
    @Published var relayMessageAddress: String = "http://your_relay_message_server:here/"
    @Published var useRelayMessaging: Bool = true
    @Published var telemetryHost: String = "your_mqtt_server:here"
    @Published var telemetryTopic: String = "domoticz/out"
//    @Published var setupCode: String = "123-45-432"
    @Published var sessionTimeout: Double = 60 // 60 seconds
    @Published var reportSize: Double = 10 // equates to 10 minutes
    @Published var interestedParties: [String] = ["fred", "betty"]
    
    let bridgeInfo: Service.Info
    
    private let storage = ConfigFileStorage(filename: "configuration.json")
    private let decoder = JSONDecoder()
    private let encoder = JSONEncoder()
    
    @Published var content: ConfigurationItems? = nil
    
    init() {
        bridgeInfo = Service.Info(
            name: "Home Bridge",
            serialNumber: "00001",
            manufacturer: "the striped lawn company ltd",
            model: "SwiftBridge",
            firmwareRevision: "1.0")
        
        if !storage.exists() {
            self.save()
        }
        
        if let content = try? self.load() {
            try? self.loadFrom(content: content)
        }
    }
    
    func load() throws -> ConfigurationItems {
        guard let config = try? decoder.decode(ConfigurationItems.self, from: storage.read())
            else {
                throw BridgeError.fileNotFound
        }

        return config
    }
    
    func loadFrom(content: ConfigurationItems) throws -> Void {
        planID = content.planID
        automationAddress = content.automationAddress
        relayMessageAddress = content.relayMessageAddress
        useRelayMessaging = content.useRelayMessaging
        telemetryHost = content.telemetryHost
        telemetryTopic = content.telemetryTopic
//        setupCode = content.setupCode
        sessionTimeout = content.sessionTimeout
        reportSize = content.reportSize
        interestedParties = content.interestedParties

        if(content == self.content) {
            throw BridgeError.configurationNotSet
        }

        self.content = content
    }
    
    func save() {
        let config = ConfigurationItems(
            planID: planID,
            automationAddress: automationAddress,
            relayMessageAddress: relayMessageAddress,
            useRelayMessaging: useRelayMessaging,
            telemetryHost: telemetryHost,
            telemetryTopic: telemetryTopic,
//            setupCode: setupCode,
            sessionTimeout: sessionTimeout,
            reportSize: reportSize,
            interestedParties: interestedParties)
        
        if let configData = try? encoder.encode(config) {
            try? storage.write(configData)
        }
    }
}

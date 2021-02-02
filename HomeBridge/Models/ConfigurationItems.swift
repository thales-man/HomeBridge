//  ConfigurationItems.swift
//  HomeBridge
//
//  Created by colin on 28/04/2020.
//  Copyright © 2020 the striped lawn company. All rights reserved.
import Foundation

struct ConfigurationItems: Codable, Equatable {
    var planID: String
    var automationAddress: String
    var relayMessageAddress: String
    var useRelayMessaging: Bool
    var telemetryHost: String
    var telemetryTopic: String
//    var setupCode: String
    var sessionTimeout: Double
    var reportSize: Double
    var interestedParties: [String]
    
    enum CodingKeys: String, CodingKey {
        case planID
        case automationAddress
        case relayMessageAddress
        case useRelayMessaging
        case telemetryHost
        case telemetryTopic
//        case setupCode
        case sessionTimeout
        case reportSize
        case interestedParties
    }
}

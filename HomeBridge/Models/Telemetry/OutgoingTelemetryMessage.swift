//  OutgoingTelemetryMessage.swift
//  HomeBridge
//
//  Created by colin on 26/04/2020.
//  Copyright © 2020 the striped lawn company. All rights reserved.
import Foundation

struct OutgoingTelemetryMessage {
    
    let topic: String
    let payload: Data
    let retain: Bool = true
    let QoS: TelemetryQuality = .atLeastOnce
    
    init(theTopic: String, thePayload: Data) {
        topic = theTopic
        payload = thePayload
    }
}

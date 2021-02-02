//  RelayMessageCoordinator.swift
//  HomeBridge
//
//  Created by colin on 15/05/2020.
//  Copyright © 2020 the striped lawn company. All rights reserved.
import Foundation

final class RelayMessageCoordinator {
    
    func start() {
        mediator.subscribe(.lowBatteryWarning, theObserver: self, selector: #selector(lowBatteryMessage(_:)))
        mediator.subscribe(.telemetryWarning, theObserver: self, selector: #selector(telemetryAttentionMessage))
    }
    
    @objc func lowBatteryMessage(_ notification: Notification) {
        if let data = notification.userInfo as? [String: Int]
        {
            for (deviceName, batteryLevel) in data
            {
                let message = "'\(deviceName)' is showing a low battery level (\(batteryLevel)%)"
                
                for person in configProvider.interestedParties {
                    messageRelay.relayMessage(userID: person, message: message, finished: { _ in })
                }
            }
        }
    }
    
    @objc func telemetryAttentionMessage() {
        let message = "you might want to take a look at mosquitto and the bridge"
        
        for person in configProvider.interestedParties {
            messageRelay.relayMessage(userID: person, message: message, finished: { _ in })
        }
    }
}

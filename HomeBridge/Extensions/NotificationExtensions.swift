//  NotificationExtensions.swift
//  HomeBridge
//
//  Created by colin on 25/04/2020.
//  Copyright © 2020 the striped lawn company. All rights reserved.
import Foundation

extension Notification.Name {
    static let addToConsole = Notification.Name("addToConsole")

    static let telemetryReset = Notification.Name("telemetryReset")
    static let telemetryCandidate = Notification.Name("telemetryCandidate")
    static let telemetryReceived = Notification.Name("telemetryReceived")

    static let bridgeReceived = Notification.Name("bridgeReceived")
    static let bridgePaired = Notification.Name("bridgePaired")
    static let bridgeSubscription = Notification.Name("bridgeSubscription")

    static let devicePublication = Notification.Name("devicePublication")

    static let lowBatteryWarning = Notification.Name("lowBatteryWarning")
    static let telemetryWarning = Notification.Name("telemetryWarning")
    
    static let preferences = Notification.Name("preferences")
}


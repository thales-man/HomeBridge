//  TelemetrySessionDelegate.swift
//  HomeBridge
//
//  Created by colin on 27/04/2020.
//  Copyright © 2020 the striped lawn company. All rights reserved.
import Foundation

protocol TelemetrySessionDelegate: class {
    func didReceive(message: IncomingTelemetryMessage, from session: TelemetrySession)
    func didAcknowledgePing(from session: TelemetrySession)
    func didDisconnect(session: TelemetrySession, error: TelemetryError)
}

//  TelemetrySessionStreamDelegate.swift
//  HomeBridge
//
//  Created by colin on 27/04/2020.
//  Copyright © 2020 the striped lawn company. All rights reserved.
import Foundation

protocol TelemetrySessionStreamDelegate: class {
    func telemetryReady(_ ready: Bool, in stream: TelemetrySessionStream)
    func telemetryErrorOccurred(in stream: TelemetrySessionStream, error: Error?)
    func telemetryReceived(in stream: TelemetrySessionStream, _ read: StreamReader)
}

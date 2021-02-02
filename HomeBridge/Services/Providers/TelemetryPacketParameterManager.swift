//  TelemetryPacketParameterManager.swift
//  HomeBridge
//
//  Created by colin on 02/05/2020.
//  Copyright © 2020 the striped lawn company. All rights reserved.
import Foundation

protocol TelemetryPacketParameterManager: TelemetryPacketParameterProvider {
    func add(theHeader: TelemetryPacketHeader)
    func add(theData: Data)
    func add(theTopics: [String : TelemetryQuality])
    func add(theTopics: [String])
    func add(theMessageID: UInt16)
    func add(theMessage: OutgoingTelemetryMessage)

    func add(theCleanSession: Bool)
    func addTheKeepAlive(_ theKeepAlive: UInt16)
    func add(theClientID: String)
    func addTheUsername(_ theUserName: String?)
    func addThePassword(_ thePassword: String?)
    func add(theLastWillMessage: OutgoingTelemetryMessage?)
}

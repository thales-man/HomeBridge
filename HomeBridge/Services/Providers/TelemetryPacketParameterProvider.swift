//  TelemetryPacketParameterProvider.swift
//  HomeBridge
//
//  Created by colin on 02/05/2020.
//  Copyright © 2020 the striped lawn company. All rights reserved.
import Foundation

protocol TelemetryPacketParameterProvider {
    func getTheHeader() -> TelemetryPacketHeader
    func getTheData() -> Data
    func getTheTopics() -> [String : TelemetryQuality]
    func getTheUnSubscribeTopics() -> [String]
    func getTheMessageID() -> UInt16
    func getTheMessage() -> OutgoingTelemetryMessage

    func getTheCleanSession() -> Bool
    func getTheKeepAlive() -> UInt16
    func getTheClientID() -> String
    func getTheUsername() -> String?
    func getThePassword() -> String?
    func getTheLastWillMessage() -> OutgoingTelemetryMessage?
}

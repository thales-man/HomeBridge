//  TelemetryPacketFactory.swift
//  HomeBridge
//
//  Created by colin on 18/04/2020.
//  Copyright © 2020 the striped lawn company. All rights reserved.
import Foundation

final class TelemetryPacketFactory {
    
    func createPacket(packetType: TelemetryPacketType, params: TelemetryPacketParameterProvider) -> TelemetryPacket {
        switch(packetType) {
        case .connect:
            return ConnectTelemetryPacket(clientID: params.getTheClientID(), cleanSession: params.getTheCleanSession(), keepAlive: params.getTheKeepAlive(), username: params.getTheUsername(), password: params.getThePassword(), lastWillMessage: params.getTheLastWillMessage())
        case .connectAcknowledgement:
            return ConnectAcknowledgementTelemetryPacket(header: params.getTheHeader(), networkData: params.getTheData())
        case .disconnect:
            return DisconnectTelemetryPacket()
        case .pingRequest:
            return PingTelemetryPacket()
        case .pingAcknowledgement:
            return PingAcknowledgementTelemetryPacket(header: params.getTheHeader())
        case .publish:
            // incoming message
            if let theData = params.getTheData() as Data? {
                return PublishTelemetryPacket(header: params.getTheHeader(), networkData: theData)
            }

            // outgoing message
            return PublishTelemetryPacket(theMessageID: params.getTheMessageID(), theMessage: params.getTheMessage())
        case .publishAcknowledgement:
            return PublishAcknowledgementTelemetryPacket(messageID: params.getTheMessageID())

        // we don't use this.
        // case .publishReceived:
        // case .publishRelease:
        // case .publishComplete:

        case .subscribe:
            return SubscribeTelemetryPacket(topics: params.getTheTopics(), messageID: params.getTheMessageID())
        case .subscribeAcknowledgement:
            return SubscribeAcknowledgementTelemetryPacket(header: params.getTheHeader(), networkData: params.getTheData())
        case .unSubscribe:
            return UnsubscribeTelemetryPacket(topics: params.getTheUnSubscribeTopics(), messageID: params.getTheMessageID())
        case .unSubscribeAcknowledgement:
            return UnsubcribeAcknowledgementTelemetryPacket(header: params.getTheHeader(), networkData: params.getTheData())
        }
    }
    
    func getTheParameterManager() -> TelemetryPacketParameterManager {
        return ParameterManager()
    }
}

fileprivate final class ParameterManager: TelemetryPacketParameterManager {
    private var header: TelemetryPacketHeader? = nil
    private var data: Data? = nil
    private var topics: [String : TelemetryQuality]? = nil
    private var unsubcribetopics: [String]? = nil
    private var messageID: UInt16? = nil
    private var message: OutgoingTelemetryMessage?
    
    private var clientID: String = "\(UUID())"
    private var cleanSession: Bool = true
    private var keepAlive: UInt16 = 60
    private var username: String? = nil
    private var password: String? = nil
    private var lastWillMessage: OutgoingTelemetryMessage? = nil

    func add(theHeader: TelemetryPacketHeader) {
        header = theHeader
    }

    func add(theData: Data) {
        data = theData
    }

    func add(theTopics: [String : TelemetryQuality]) {
        topics = theTopics
    }
    
    func add(theTopics: [String]) {
        unsubcribetopics = theTopics
    }

    func add(theMessageID: UInt16) {
        messageID = theMessageID
    }

    func add(theMessage: OutgoingTelemetryMessage) {
        message = theMessage
    }

    func add(theCleanSession: Bool) {
        cleanSession = theCleanSession
    }
    
    func addTheKeepAlive(_ theKeepAlive: UInt16) {
        keepAlive = theKeepAlive
    }
    
    func add(theClientID: String) {
        clientID = theClientID
    }

    func addTheUsername(_ theUserName: String?) {
        username = theUserName
    }
    
    func addThePassword(_ thePassword: String?) {
        password = thePassword
    }

    func add(theLastWillMessage: OutgoingTelemetryMessage?) {
        lastWillMessage = theLastWillMessage
    }

    func getTheHeader() -> TelemetryPacketHeader {
        return header!
    }

    func getTheData() -> Data {
        return data!
    }
    
    func getTheTopics() -> [String : TelemetryQuality] {
        return topics!
    }

    func getTheUnSubscribeTopics() -> [String] {
        return unsubcribetopics!
    }

    func getTheMessageID() -> UInt16 {
        return messageID!
    }
    
    func getTheMessage() -> OutgoingTelemetryMessage {
        return message!
    }
    
    func getTheCleanSession() -> Bool {
        return cleanSession
    }
    
    func getTheKeepAlive() -> UInt16 {
        return keepAlive
    }
    
    func getTheClientID() -> String {
        return clientID
    }
    
    func getTheUsername() -> String? {
        return username
    }
    
    func getThePassword() -> String? {
        return password
    }
    
    func getTheLastWillMessage() -> OutgoingTelemetryMessage? {
        return lastWillMessage
    }
}

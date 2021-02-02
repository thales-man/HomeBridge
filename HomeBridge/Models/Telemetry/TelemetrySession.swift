//  TelemetrySession.swift
//  HomeBridge
//
//  Created by colin on 27/04/2020.
//  Copyright © 2020 the striped lawn company. All rights reserved.
import Foundation

final class TelemetrySession: TelemetrySessionStreamDelegate {
    let host: String
    let port: UInt16
    let connectionTimeout: TimeInterval
    let useSSL: Bool
    
    let cleanSession: Bool
    let keepAlive: UInt16
    let clientID: String

    var username: String?
    var password: String?
    var lastWillMessage: OutgoingTelemetryMessage?

    weak var delegate: TelemetrySessionDelegate?
    var delegateQueue = DispatchQueue.main

    private var connectionCompletionBlock: TelemetryCompletionBlock?
    private var messagesCompletionBlocks = [UInt16: TelemetryCompletionBlock]()
    private var factory: TelemetryPacketFactory
    
    private var stream: TelemetrySessionStream?

    private var messageID = UInt16(0)
    
    public init(
        host: String,
        keepAlive: UInt16 = 60,
        clientID: String = "\(UUID())",
        port: UInt16 = 1883,
        cleanSession: Bool = true,
        connectionTimeout: TimeInterval = 5.0,
        useSSL: Bool = false)
    {
        self.factory = TelemetryPacketFactory()
        self.host = host
        self.port = port
        self.connectionTimeout = connectionTimeout
        self.useSSL = useSSL
        self.clientID = clientID
        self.cleanSession = cleanSession
        self.keepAlive = keepAlive
    }
    
    deinit {
        delegate = nil
        disconnect()
    }
    
    func publish(_ data: Data, in topic: String, delivering qos: TelemetryQuality, retain: Bool, completion: TelemetryCompletionBlock?) {
        let msgID = nextMessageID()

        let manager = packetFactory.getTheParameterManager()
        manager.add(theMessageID: msgID)
        manager.add(theMessage: OutgoingTelemetryMessage(theTopic: topic, thePayload: data))
        
        let packet = packetFactory.createPacket(packetType: TelemetryPacketType.publish, params: manager)
        if send(packet) {
            messagesCompletionBlocks[msgID] = completion
            if qos == .atMostOnce {
                completion?(TelemetryError.none)
            }
        } else {
            completion?(TelemetryError.socketError)
        }
    }

    func subscribe(to topic: String, delivering qos: TelemetryQuality, completion: TelemetryCompletionBlock?) {
        subscribe(to: [topic: qos], completion: completion)
    }
    
    func subscribe(to topics: [String: TelemetryQuality], completion: TelemetryCompletionBlock?) {
        let msgID = nextMessageID()
        let manager = packetFactory.getTheParameterManager()

        manager.add(theMessageID: msgID)
        manager.add(theTopics: topics)

        let packet = packetFactory.createPacket(packetType: TelemetryPacketType.subscribe, params: manager)
        if send(packet) {
            messagesCompletionBlocks[msgID] = completion
            completion?(TelemetryError.none)
        } else {
            completion?(TelemetryError.socketError)
        }
    }

    func unSubscribe(from topic: String, completion: TelemetryCompletionBlock?) {
        unSubscribe(from: [topic], completion: completion)
    }
    
    func unSubscribe(from topics: [String], completion: TelemetryCompletionBlock?) {
        let msgID = nextMessageID()
        let manager = packetFactory.getTheParameterManager()

        manager.add(theMessageID: msgID)
        manager.add(theTopics: topics)

        let packet = packetFactory.createPacket(packetType: TelemetryPacketType.unSubscribe, params: manager)

        if send(packet) {
            messagesCompletionBlocks[msgID] = completion
            completion?(TelemetryError.none)
        } else {
            completion?(TelemetryError.socketError)
        }
    }
    
    func connect(completion: TelemetryCompletionBlock?) {
        connectionCompletionBlock = completion
        stream = TelemetrySessionStream(host: host, port: port, ssl: useSSL, timeout: connectionTimeout, delegate: self)
    }

    func disconnect() {
        let manager = packetFactory.getTheParameterManager()
        let packet = packetFactory.createPacket(packetType: TelemetryPacketType.disconnect, params: manager)
        send(packet)
        cleanupDisconnection(.none)
    }
    
    private func cleanupDisconnection(_ error: TelemetryError) {
        stream = nil
        delegateQueue.async { [weak self] in
            self?.delegate?.didDisconnect(session: self!, error: error)
        }
    }

    @discardableResult
    private func send(_ packet: TelemetryPacket) -> Bool {
        if let write = stream?.write {
            let didWriteSuccessfully = telemetryRelay.send(packet, write: write)

            if !didWriteSuccessfully {
                cleanupDisconnection(.socketError)
            }
            
            return didWriteSuccessfully
        }

        return false
    }
    
    private func handle(_ packet: TelemetryPacket) {

        switch packet {
        case let connAck as ConnectAcknowledgementTelemetryPacket:
            delegateQueue.async { [weak self] in
                if connAck.response == .connectionAccepted {
                    self?.connectionCompletionBlock?(TelemetryError.none)
                } else {
                    self?.connectionCompletionBlock?(TelemetryError.connectionError(connAck.response))
                }
                self?.connectionCompletionBlock = nil
            }
        case let subAck as SubscribeAcknowledgementTelemetryPacket:
            callSuccessCompletionBlock(for: subAck.messageID)
        case let unSubAck as UnsubcribeAcknowledgementTelemetryPacket:
            callSuccessCompletionBlock(for: unSubAck.messageID)
        case let pubAck as PublishAcknowledgementTelemetryPacket:
            callSuccessCompletionBlock(for: pubAck.messageID)
        case let publish as PublishTelemetryPacket:
            sendPubAck(for: publish.messageID)
            let message = IncomingTelemetryMessage(publishPacket: publish)
            delegateQueue.async { [weak self] in
                self?.delegate?.didReceive(message: message, from: self!)
            }
        case _ as PingAcknowledgementTelemetryPacket:
            delegateQueue.async { [weak self] in
                self?.delegate?.didAcknowledgePing(from: self!)
            }
        default:
            return
        }
    }
    
    private func sendPubAck(for messageID: UInt16) {
        let manager = packetFactory.getTheParameterManager()
        manager.add(theMessageID: messageID)

        let packet = packetFactory.createPacket(packetType: TelemetryPacketType.publishAcknowledgement, params: manager)
        send(packet)
    }
    
    private func callSuccessCompletionBlock(for messageId: UInt16) {
        delegateQueue.async { [weak self] in
            let completionBlock = self?.messagesCompletionBlocks.removeValue(forKey: messageId)
            completionBlock?(TelemetryError.none)
        }
    }
    
    func ping() {
        let manager = packetFactory.getTheParameterManager()
        let pingReq = packetFactory.createPacket(packetType: TelemetryPacketType.pingRequest, params: manager)
        send(pingReq)
    }
    
    private func nextMessageID() -> UInt16 {
        messageID += 1
        return messageID
    }
    
    func telemetryReady(_ ready: Bool, in stream: TelemetrySessionStream) {
        if ready {
            let manager = packetFactory.getTheParameterManager()

            manager.add(theClientID: clientID)
            manager.add(theCleanSession: cleanSession)
            manager.addTheKeepAlive(keepAlive)
            manager.addTheUsername(username)
            manager.addThePassword(password)
            manager.add(theLastWillMessage: lastWillMessage)

            let packet = packetFactory.createPacket(packetType: TelemetryPacketType.connect, params: manager)
            if send(packet) == false {
                delegateQueue.async { [weak self] in
                    self?.connectionCompletionBlock?(TelemetryError.socketError)
                    self?.connectionCompletionBlock = nil
                }
            }
        }
        else {
            cleanupDisconnection(.socketError)
            delegateQueue.async { [weak self] in
                self?.connectionCompletionBlock?(TelemetryError.socketError)
            }
        }
    }

    func telemetryReceived(in stream: TelemetrySessionStream, _ read: StreamReader) {
        if let packet = telemetryRelay.parse(read) {
            handle(packet)
        }
    }
    
    func telemetryErrorOccurred(in stream: TelemetrySessionStream, error: Error?) {
        cleanupDisconnection(.streamError(error))
    }
}

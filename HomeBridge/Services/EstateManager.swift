//  EstateManager.swift
//  HomeBridge
//
//  Created by colin on 25/04/2020.
//  Copyright © 2020 the striped lawn company. All rights reserved.
import Foundation
import Logging
import HAP
import SwiftUI

final class EstateManager: ObservableObject {
    static let estatePaired = "estatePaired"
    static let estateNotPaired = "estateNotPaired"
    static let estateTransmitting = "estateTransmitting"
    static let estateNotTransmitting = "estateNotTransmitting"
    static let estateSynchronised = "estateSynchronised"
    static let estateNotSynchronised = "estateNotSynchronised"
    
    private var publishedIDs: [String] = []
    private var subscribedIDs: [String] = []
    
    var selected: NavigationItem? = nil
    
    @Published var receivingTelemetry: Bool = false
    @Published var receivingHomekit: Bool = false
    @Published var telemetryHits: Array<Double> = Array<Double>()
    @Published var bridgeHits: Array<Double> = Array<Double>()
    @Published var publishedCount: Int = 0
    @Published var subscribedCount: Int = 0
    @Published var bridgeIsTransmittingImage: String = EstateManager.estateNotTransmitting
    @Published var bridgeIsSynchronisedImage: String = EstateManager.estateNotSynchronised
    @Published var bridgeIsPairedImage: String = EstateManager.estateNotPaired
    
    var bridgeIsPaired: Bool = false {
        didSet {
            bridgeIsPairedImage = bridgeIsPaired
                ? EstateManager.estatePaired
                : EstateManager.estateNotPaired
        }
    }
    
    var bridgeIsTransmitting: Bool = false {
        didSet {
            bridgeIsTransmittingImage = bridgeIsTransmitting
                ? EstateManager.estateTransmitting
                : EstateManager.estateNotTransmitting
        }
    }
    
    var bridgeIsSynchronised: Bool = false {
        didSet {
            bridgeIsSynchronisedImage = bridgeIsSynchronised
                ? EstateManager.estateSynchronised
                : EstateManager.estateNotSynchronised
        }
    }
    
    private var activityTimer: Timer?
    
    init() {
        mediator.subscribe(.devicePublication, theObserver: self, selector: #selector(devicePublication(_:)))
        mediator.subscribe(.bridgePaired, theObserver: self, selector: #selector(bridgePaired(_:)))
        mediator.subscribe(.bridgeReceived, theObserver: self, selector: #selector(bridgeReceived(_:)))
        mediator.subscribe(.bridgeSubscription, theObserver: self, selector: #selector(bridgeSubsciption(_:)))
        mediator.subscribe(.telemetryReceived, theObserver: self, selector: #selector(telemetryReceived(_:)))
        
        relayCoordinator.start()
    }
    
    // doh! temporal coupling...
    func compose(selected: NavigationItem) {
        self.selected = selected
    }
    
    func start() {
        for _ in 1...Int(configProvider.reportSize) {
            telemetryHits.enqueue(newElement: 0)
            bridgeHits.enqueue(newElement: 0)
        }
        
        activityTimer = Timer.scheduledTimer(timeInterval: configProvider.sessionTimeout,
                                             target: self,
                                             selector: #selector(increment),
                                             userInfo: nil,
                                             repeats: true)
        
        telemetryCoordinator.start()
    }
    
    func stop() {
        activityTimer?.invalidate()
        activityTimer = nil
        
        telemetryCoordinator.stop()
        advertisingService.stop()
        
        telemetryHits.removeAll()
        bridgeHits.removeAll()
        receivingTelemetry = false
        receivingHomekit = false
        subscribedCount = 0
    }
    
    private func updateTransmissionState() {
        receivingTelemetry = telemetryHits.contains { $0 > 0.0 }
        receivingHomekit = bridgeHits.contains { $0 > 0.0 }
        
        bridgeIsTransmitting = receivingTelemetry && receivingHomekit

        // once we are receiving telemetry, start advertising...
        if(receivingTelemetry && !advertisingService.isRunning) {
            advertisingService.start()
        }
    }
    
    private func updateSynchronisedState() {
        bridgeIsSynchronised  = publishedIDs.count == subscribedIDs.count
    }
    
    private func addSubscription(_ accessoryID: String) {
        if !subscribedIDs.contains(accessoryID) {
            subscribedIDs.append(accessoryID)
            subscribedCount += 1
            updateSynchronisedState()
        }
    }
    
    private func removeSubscription(_ accessoryID: String) {
        if subscribedIDs.contains(accessoryID) {
            if let index = subscribedIDs.firstIndex(of: accessoryID) {
                subscribedIDs.remove(at: index)
                subscribedCount -= 1
                updateSynchronisedState()
            }
        }
    }
    
    @objc func increment() {
        if(telemetryHits.last == 0) {
            telemetryCoordinator.ping()
        }
        
        telemetryHits.enqueue(newElement: 0)
        bridgeHits.enqueue(newElement: 0)
        
        if(telemetryHits.count > Int(configProvider.reportSize)) {
            _ = telemetryHits.dequeue()
            _ = bridgeHits.dequeue()
        }
    }
    
    @objc private func devicePublication(_ notification: Notification) {
        if let data = notification.userInfo as? [String: ManageableDevice]
        {
            for (accessoryID, _) in data
            {
                if !publishedIDs.contains(accessoryID) {
                    publishedIDs.append(accessoryID.padToLeft(upTo: 5)) // bridge id
                    publishedCount += 1
                    updateSynchronisedState()
                }
            }
        }
    }
    
    @objc private func bridgePaired(_ notification: Notification) {
        if let data = notification.userInfo as? [Bool: String]
        {
            for (pairedState, barCodeInstructions) in data
            {
                bridgeIsPaired = pairedState
                if(!bridgeIsPaired) {
                    selected?.showQRCode(barCodeInstructions)
                }
            }
        }
    }
    
    @objc private func bridgeReceived(_ notification: Notification) {
        if let data = notification.userInfo as? [String: AccessoryType]
        {
            for (accessoryID, _) in data
            {
                if subscribedIDs.contains(accessoryID) {
                    bridgeHits.Increment()
                    updateTransmissionState()
                }
            }
        }
    }
    
    @objc private func bridgeSubsciption(_ notification: Notification) {
        if let data = notification.userInfo as? [String: Bool]
        {
            for (accessoryID, subscribed) in data
            {
                if(subscribed) {
                    addSubscription(accessoryID)
                    return
                }
                
                removeSubscription(accessoryID)
            }
        }
    }
    
    @objc private func telemetryReceived(_ notification: Notification) {
        if let data = notification.userInfo as? [String: ManageableDevice]
        {
            for (_, device) in data
            {
                if publishedIDs.contains(device.accessoryId) {
                    telemetryHits.Increment()
                    updateTransmissionState()
                }
            }
        }
    }
}

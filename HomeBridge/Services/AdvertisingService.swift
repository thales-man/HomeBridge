// AdvertisingService.swift
//  HomeBridge
//
//  Created by colin on 26/04/2020.
//  Copyright © 2020 the striped lawn company. All rights reserved.
import Foundation
import Logging
import HAP
import SwiftUI

final class AdvertisingService: ObservableObject {
    private let storage = FileStorage(filename: "pairinginformation.json")
    private let logger: Logger
    private let bridge: Device
    private var server: Server?
    private let  delegate: BridgingDeviceDelegate
    
    @Published var isRunning: Bool = false
    
    init(logHandler: (String) -> LogHandler) {
        
        logger = Logger(label: "bridge", factory: logHandler)

        bridge = Device(
            bridgeInfo: configProvider.bridgeInfo,
            storage: self.storage,
            accessories: [])
        
        delegate = BridgingDeviceDelegate(theLogger: logger, theDevice: bridge)
        bridge.delegate = delegate

        logInfo("Initializing the advertising server...")
    }
    
    func clearAccessories() {
        var tempSet: [Accessory] = []

        // the bridge has to be left in place.
        for item in bridge.accessories {
            if item.serialNumber != "00001" {
                tempSet.append(item)
            }
        }

        bridge.removeAccessories(tempSet, andForgetSerialNumbers: true)
    }
    
    func addAccessory(device: ManageableDevice) {
        let accessory = accessoryFactory.createAccessory(device: device)
        bridge.addAccessories([accessory])

        logInfo("accessory \(accessory.serialNumber) added to bridge")
    }
    
    func clearConfiguration() {
        logWarning("Dropping all pairings, keys and accessory information")
        try? storage.write(Data())
    }
    
    private func logWarning(_ message: String) {
        logger.warning("\(message)")
    }
    
    private func logInfo(_ message: String) {
        logger.info("\(message)")
    }
    
    func start() {
        if(isRunning) {
            return
        }

        logInfo("Starting the advertising server...")

        isRunning = true
        server = try? Server(device: bridge, listenPort: 8000)

        logInfo("Publishing \(bridge.accessories.count) accessories.")
        delegate.printPairingInstructions()
    }
    
    func stop() {
        if(!isRunning) {
            return
        }

        logInfo("Shutting down the advertising server...")

        isRunning = false
        try? server?.stop()
        server = nil
    }
}

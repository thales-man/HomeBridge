//  BridgingDeviceDelegate.swift
//  HomeBridge
//
//  Created by colin on 27/04/2020.
//  Copyright © 2020 the striped lawn company. All rights reserved.
import Foundation
import HAP
import Logging

final class BridgingDeviceDelegate: DeviceDelegate {
    let logger: Logger
    let device: Device
    
    init(theLogger: Logger, theDevice: Device) {
        logger = theLogger
        device = theDevice
    }
    
    func didRequestIdentificationOf(_ accessory: Accessory) {
        logInfo("Requested identification of accessory \(String(describing: accessory.info.name.value!))")
    }
    
    func logInfo(_ message: String) {
        logger.info("\(message)")
    }
    
    func characteristic<T>(_ characteristic: GenericCharacteristic<T>,
                           ofService service: Service,
                           ofAccessory accessory: Accessory,
                           didChangeValue newValue: T?) {

        mediator.publish(.bridgeReceived, theInfo: [accessory.serialNumber: accessory.type])
        logInfo("Seeking characteristic change for \(String(describing: accessory.info.name.value!))")
    }

    func characteristicListenerDidSubscribe(_ accessory: Accessory,
                                            service: Service,
                                            characteristic: AnyCharacteristic) {

        mediator.publish(.bridgeSubscription, theInfo: [accessory.serialNumber: true])
        mediator.publish(.bridgeReceived, theInfo: [accessory.serialNumber: accessory.type])
        logInfo("Seeking subscription for \(String(describing: accessory.info.name.value!))")
    }
    
    func characteristicListenerDidUnsubscribe(_ accessory: Accessory,
                                              service: Service,
                                              characteristic: AnyCharacteristic) {

        mediator.publish(.bridgeSubscription, theInfo: [accessory.serialNumber: false])
        logInfo("Seeking un-subscription for \(String(describing: accessory.info.name.value!))")
    }
    
    func didChangePairingState(from: PairingState, to: PairingState) {
        if to == .notPaired {
            printPairingInstructions()
        }
    }
    
    func printPairingInstructions() {
        let msg = (device.isPaired)
            ? "The device is paired, either unpair using your iDevice or remove the configuration file `pairinginformation.json`."
            : "\n Scan the following QR code using your \n iDevice to pair this bridge:\n\n\(device.setupQRCode.asText)\n \n The setup code is: \(device.setupCode)\n"
        logInfo(msg)

        mediator.publish(.bridgePaired, theInfo: [device.isPaired: msg])
    }
}

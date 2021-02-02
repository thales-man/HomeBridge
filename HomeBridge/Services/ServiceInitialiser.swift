//  ServiceInitialiser.swift
//  HomeBridge
//
//  Created by colin on 28/04/2020.
//  Copyright © 2020 the striped lawn company. All rights reserved.
import Foundation

// TODO: review global service initialisation
// wouldn't it be nice.... to have a container...
// probably needs another layer, view models as some code does presentational stuff...
let mediator = MediationService()
let configProvider = ConfigurationProvider()
let consoleTextProvider = ConsoleTextProvider()
let estateManager = EstateManager()
let accessoryFactory = BridgeAccessoryFactory()
let advertisingCoordinator = AdvertisingPublicationCoordinator()
let advertisingService = AdvertisingService(logHandler: AdvertisingServiceLogHandler.init)
let deviceProvider = ManageableDeviceProvider()
let packetFactory = TelemetryPacketFactory()
let telemetryRelay = TelemetryRelay()
let telemetryCoordinator = TelemetryCoordinator()
let messageRelay = RelayMessageService()
let relayCoordinator = RelayMessageCoordinator()

//  ManageableDeviceProvider.swift
//  HomeBridge
//
//  Created by colin on 21/04/2020.
//  Copyright © 2020 the striped lawn company. All rights reserved.
import Foundation
import HAP

final class ManageableDeviceProvider: ObservableObject {
    
    private let storage = FileStorage(filename: "publisheddevices.json")
    private let planService = PlanDeviceService()
    private let updateService = PlanDeviceUpdateService()
    private let decoder = JSONDecoder()
    private let encoder = JSONEncoder()

    @Published var devices: Array<ManageableDevice> = []
    @Published var isPublished: Bool = false
    
    init() {
//        loadFile()
    }
    
    func load(usingPlan: String) {
        planService.fetchPlanDevices(planID: usingPlan, withCompletion: updateDevice)
    }
    
    func loadDevice(deviceID: String) {
        planService.fetchPlanDeviceDetail(deviceID: deviceID, withCompletion: updateDevice)
    }
    
    func loadFile() {
        if let publishedFile = try? storage.read() {
            if let newItems = try? decoder.decode(Array<PublishableDevice>.self, from: publishedFile) {
                devices.removeAll()
                for item in newItems {
                    writeDevice(publishedDevice: item)
                }
            }
        }

        devices.sort { $0.name < $1.name }
        load(usingPlan: configProvider.planID)
    }
    
    func publish() {
        var publishedList = Array<PublishableDevice>()
        for device in devices {
            if device.confirmationState != .notConfirmed {
                let candidate = PublishableDevice(device: device)
                publishedList.append(candidate)
            }
        }
        
        if let deviceData = try? encoder.encode(publishedList) {
            try? storage.write(deviceData)
            isPublished = true
            loadFile()
        }
    }
    
    func checkForUnpublished() {
        isPublished = !(devices.first(where: { $0.confirmationState == .notConfirmed || $0.confirmationState == .newDevice  }) != nil)
    }
    
    func deviceNameUnique(_ candidate: String) -> Bool {
        return devices.isUnique(where: { $0.name == candidate })
    }
    
    private func writeDevice(publishedDevice: PublishableDevice) {
        devices.append(ManageableDevice(publishedDevice: publishedDevice, withSwitchState: updateState))
    }
    
    private func updateDevice(device: PlanDeviceDetail) {
        if let original = devices.first(where: { $0.id == device.id }) {
            let delta = ManageableDevice(planDevice: device, withSwitchState: updateState)
            original.updateDevice(delta: delta)
        }
        else {
            devices.insert(ManageableDevice(planDevice: device, withSwitchState: updateState), at: 0)
        }
        
        checkForUnpublished()
    }
    
    private func updateState(device: ManageableDevice, requestedState: String) -> Void {
        let deviceID = device.id
        updateService.switchDeviceState(deviceID: deviceID, newState: requestedState, finished: dummyReturn)

        checkForUnpublished()
    }
    
    private func dummyReturn(value: Bool) { }
}

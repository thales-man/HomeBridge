//  BridgeAccessoryFactory.swift
//  HomeBridge
//
//  Created by colin on 28/04/2020.
//  Copyright © 2020 the striped lawn company. All rights reserved.
import Foundation
import HAP

final class BridgeAccessoryFactory {
    let company = "the striped lawn company"
    let revision = "1.0"

    func createAccessory(device: ManageableDevice) -> Accessory {
        let serviceInfo = createServiceInfo(device: device)
        
        switch(device.advertisedType) {
            case .fan:
                return BridgedFan(info: serviceInfo, theParent: device)
            case.lightbulb:
                return BridgedLightbulb(info: serviceInfo, theParent: device)
            case.door:
                return BridgedDoor(info: serviceInfo, theParent: device)
            case.doorLock:
                return BridgedDoorLock(info: serviceInfo, theParent: device)
            case.outlet:
                return BridgedOutlet(info: serviceInfo, theParent: device)
            case.switch:
                return BridgedSwitch(info: serviceInfo, theParent: device)
            case.thermometer:
                return BridgedThermometer(info: serviceInfo, theParent: device)
            case.lightSensor:
                return Accessory.LightSensor(info: serviceInfo)
            case.motionSensor:
                return BridgedMotionSensor(info: serviceInfo, theParent: device)
            //    .sensor: Accessory.ContactSensor,
            //    .sensor: Accessory.AirQualitySensor,
            //    .sensor: Accessory.SmokeSensor,
            case.none:
                return Accessory.Lightbulb(info: serviceInfo)
        }
    }
    
    private func createServiceInfo(device: ManageableDevice) -> Service.Info {
        return Service.Info(name: device.name, serialNumber: device.accessoryId, manufacturer: company, model: "TSLC \(device.subType)", firmwareRevision: revision)
    }
}

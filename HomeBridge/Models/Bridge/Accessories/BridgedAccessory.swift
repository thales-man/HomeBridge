//  BridgedAccessory.swift
//  HomeBridge
//
//  Created by colin on 01/05/2020.
//  Copyright © 2020 the striped lawn company. All rights reserved.
import HAP

protocol BridgedAccessory {
    var parentDevice: ManageableDevice { get }
    
    func switchState(requestedState: String)
    func deviceIsActive(_ requestedState: String) -> Bool
    func getLowStatusBattery() -> Enums.StatusLowBattery
}

extension BridgedAccessory {
    
    func deviceIsActive(_ requestedState: String) -> Bool {
        return requestedState == parentDevice.advertisedType.activeForDevice
    }
    
    func getLowStatusBattery() -> Enums.StatusLowBattery {
        let batteryIsLow = parentDevice.batteryLevel <= Int(parentDevice.lowBatteryAlertLevel)
        if batteryIsLow {
            mediator.publish(.lowBatteryWarning, theInfo: [parentDevice.name:parentDevice.batteryLevel])
        }
        
        return  batteryIsLow
            ? Enums.StatusLowBattery.batteryLow
            : Enums.StatusLowBattery.batteryNormal
    }
}

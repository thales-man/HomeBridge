//  BridgedDoorLock.swift
//  HomeBridge
//
//  Created by colin on 01/05/2020.
//  Copyright © 2020 the striped lawn company. All rights reserved.
import HAP

class BridgedDoorLock: HAP.Accessory.LockMechanism, BridgedAccessory {
    let service = Service.BatteryService()
    let parentDevice: ManageableDevice

    init(info: Service.Info, theParent: ManageableDevice) {
        parentDevice = theParent
        
        if parentDevice.hasBattery {
            super.init(info: info, additionalServices: [service])
        } else {
            super.init(info: info)
        }
        
        theParent.bridgedDevice = self
        switchState(requestedState: parentDevice.state)
    }
    
    override func characteristic<T>(_ characteristic: GenericCharacteristic<T>,
                                    ofService service: Service,
                                    didChangeValue newValue: T?) {
        
        if characteristic === self.service.batteryLevel {
            setBatteryState()
        }
                
        if characteristic === lockMechanism.lockTargetState {
            let requestedChange = lockMechanism.lockTargetState.value! == Enums.LockTargetState.secured
                ? parentDevice.advertisedType.offForDevice
                : parentDevice.advertisedType.onForDevice
            
            lockMechanism.lockCurrentState.value! = lockMechanism.lockTargetState.value! == Enums.LockTargetState.secured
                ? Enums.LockCurrentState.secured
                : Enums.LockCurrentState.unsecured
            
            parentDevice.switchState(requestedState: requestedChange)
        }
        
        super.characteristic(characteristic, ofService: service, didChangeValue: newValue)
    }
    
    func switchState(requestedState: String) {
        lockMechanism.lockCurrentState.value = deviceIsActive(requestedState)
            ? Enums.LockCurrentState.unsecured
            : Enums.LockCurrentState.secured
        
        lockMechanism.lockTargetState.value = deviceIsActive(requestedState)
            ? Enums.LockTargetState.unsecured
            : Enums.LockTargetState.secured
        
        setBatteryState()
    }
    
    func setBatteryState() {
        self.service.batteryLevel.value = UInt8(parentDevice.batteryLevel)
        self.service.statusLowBattery.value =  getLowStatusBattery()
    }
}

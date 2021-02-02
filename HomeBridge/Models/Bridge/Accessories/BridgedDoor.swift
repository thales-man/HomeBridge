//  BridgedDoor.swift
//  HomeBridge
//
//  Created by colin on 01/05/2020.
//  Copyright © 2020 the striped lawn company. All rights reserved.
import HAP

class BridgedDoor: HAP.Accessory.ContactSensor, BridgedAccessory {
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
        
        if characteristic === contactSensor.contactSensorState {
            let requestedChange = contactSensor.contactSensorState.value == Enums.ContactSensorState.notdetected
                ? parentDevice.advertisedType.onForDevice
                : parentDevice.advertisedType.offForDevice
            
            parentDevice.switchState(requestedState: requestedChange)
        }
        
        if characteristic === self.service.batteryLevel {
            setBatteryState()
        }
        
        super.characteristic(characteristic, ofService: service, didChangeValue: newValue)
    }
    
    func switchState(requestedState: String) {
        contactSensor.contactSensorState.value = deviceIsActive(requestedState)
            ? Enums.ContactSensorState.notdetected
            : Enums.ContactSensorState.detected
        
        setBatteryState()
    }
    
    func setBatteryState() {
        contactSensor.statusLowBattery?.value = getLowStatusBattery()
        
        self.service.batteryLevel.value = UInt8(parentDevice.batteryLevel)
        self.service.statusLowBattery.value =  getLowStatusBattery()
    }
}

//  BridgedThermometer.swift
//  HomeBridge
//
//  Created by colin on 01/05/2020.
//  Copyright © 2020 the striped lawn company. All rights reserved.
import HAP

final class BridgedThermometer: HAP.Accessory.Thermometer, BridgedAccessory {
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
        
        if characteristic === temperatureSensor.currentTemperature {
            parentDevice.switchState(requestedState: parentDevice.advertisedType.onForDevice)
        }
        
        if characteristic === self.service.batteryLevel
            || characteristic === temperatureSensor.statusLowBattery {
            setBatteryState()
        }
        
        super.characteristic(characteristic, ofService: service, didChangeValue: newValue)
    }
    
    func switchState(requestedState: String) {
        if !parentDevice.data.isEmpty {
            let candidate = parentDevice.data
                .split(separator: "C")[0]
                .trimmingCharacters(in: .whitespacesAndNewlines)
            
            if !candidate.isEmpty {
                temperatureSensor.currentTemperature.value = candidate.asFloat()
            }
        }
        
        setBatteryState()
    }
    
    func setBatteryState() {
        temperatureSensor.statusLowBattery?.value = getLowStatusBattery()
        
        self.service.batteryLevel.value = UInt8(parentDevice.batteryLevel)
        self.service.statusLowBattery.value =  getLowStatusBattery()
    }
}

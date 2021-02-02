//  BridgedLightbulb.swift
//  HomeBridge
//
//  Created by colin on 01/05/2020.
//  Copyright © 2020 the striped lawn company. All rights reserved.
import HAP

class BridgedLightbulb: HAP.Accessory.Lightbulb, BridgedAccessory {
    let parentDevice: ManageableDevice

    init(info: Service.Info, theParent: ManageableDevice) {
        parentDevice = theParent
        super.init(info: info)
        
        theParent.bridgedDevice = self
        switchState(requestedState: parentDevice.state)
    }
    
    override func characteristic<T>(_ characteristic: GenericCharacteristic<T>,
                                    ofService service: Service,
                                    didChangeValue newValue: T?) {
        
        if characteristic === lightbulb.powerState {
            let requestedChange = lightbulb.powerState.value!
                ? parentDevice.advertisedType.onForDevice
                : parentDevice.advertisedType.offForDevice
            
            parentDevice.switchState(requestedState: requestedChange)
        }
        
        super.characteristic(characteristic, ofService: service, didChangeValue: newValue)
    }
    
    func switchState(requestedState: String) {
        lightbulb.powerState.value = deviceIsActive(requestedState)
    }
}

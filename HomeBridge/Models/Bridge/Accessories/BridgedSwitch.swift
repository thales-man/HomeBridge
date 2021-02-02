//  BridgedSwitch.swift
//  HomeBridge
//
//  Created by colin on 01/05/2020.
//  Copyright © 2020 the striped lawn company. All rights reserved.
import HAP

final class BridgedSwitch: HAP.Accessory.Switch, BridgedAccessory {
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
        
        if characteristic === `switch`.powerState {
            let requestedChange = `switch`.powerState.value!
                ? parentDevice.advertisedType.onForDevice
                : parentDevice.advertisedType.offForDevice
            
            parentDevice.switchState(requestedState: requestedChange)
        }
        
        super.characteristic(characteristic, ofService: service, didChangeValue: newValue)
    }
    
    func switchState(requestedState: String) {
        `switch`.powerState.value = deviceIsActive(requestedState)
    }
}

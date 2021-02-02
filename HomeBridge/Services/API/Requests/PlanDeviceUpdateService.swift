//  PlanDeviceUpdateService.swift
//  HomeBridge
//
//  Created by colin on 21/04/2020.
//  Copyright © 2020 the striped lawn company. All rights reserved.
import Foundation

struct PlanDeviceUpdateService {

    func switchDeviceState(deviceID: String, newState: String, finished: @escaping (Bool) -> Void) {
        let deviceRequest = BridgeVoidRequest(apiResource: SwitchDeviceStateVoidResource(deviceID: deviceID, newState: newState))
        
        deviceRequest.invoke(finished:  finished)
    }
}

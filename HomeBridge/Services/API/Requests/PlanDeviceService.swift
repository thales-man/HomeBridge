//  PlanDeviceService.swift
//  HomeBridge
//
//  Created by colin on 21/04/2020.
//  Copyright © 2020 the striped lawn company. All rights reserved.
import Foundation

struct PlanDeviceService {

    func fetchPlanDevices(planID: String, withCompletion completion: @escaping (PlanDeviceDetail) -> Void) {
        let deviceRequest = BridgeFetchRequest(apiResource: PlanDeviceFetchResource(planID: planID))
        
        deviceRequest.fetch {
            (planDevices: Array<PlanDevice>?) in
                guard let devices = planDevices
                else {
                    return
                }
            
            for device in devices {
                let deviceID = device.id
                self.fetchPlanDeviceDetail(deviceID: deviceID, withCompletion: completion)
            }
        }
    }

    func fetchPlanDeviceDetail(deviceID: String, withCompletion completion: @escaping (PlanDeviceDetail) -> Void) {
        let detailsRequest = BridgeFetchRequest(apiResource: PlanDeviceDetailFetchResource(deviceID: deviceID))

        detailsRequest.fetch {
            (newDetails: Array<PlanDeviceDetail>?) in
                guard let detail = newDetails?.first
                else {
                    return
                }

            completion(detail)
        }
    }
}


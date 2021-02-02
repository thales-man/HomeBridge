//  PlanDeviceFetchResource.swift
//  HomeBridge
//
//  Created by colin on 21/04/2020.
//  Copyright © 2020 the striped lawn company. All rights reserved.
import Foundation

struct PlanDeviceFetchResource: APIFetchResource {
    typealias ModelType = PlanDevice
    let methodPath = "/json.htm"
    let planID: String

    var url: URL {
        var components = URLComponents(string: configProvider.automationAddress)!
        components.path = methodPath
        components.queryItems = [
            URLQueryItem(name: "type", value: "command"),
            URLQueryItem(name: "param", value: "getplandevices"),
            URLQueryItem(name: "idx", value: planID)
        ]
        
        return components.url!
    }
}


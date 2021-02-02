//  PlanDeviceDetailFetchResource.swift
//  HomeBridge
//
//  Created by colin on 21/04/2020.
//  Copyright © 2020 the striped lawn company. All rights reserved.
import Foundation

struct PlanDeviceDetailFetchResource: APIFetchResource {
    typealias ModelType = PlanDeviceDetail
    let methodPath = "/json.htm"
    let deviceID: String

    var url: URL {
        var components = URLComponents(string: configProvider.automationAddress)!
        components.path = methodPath
        components.queryItems = [
            URLQueryItem(name: "type", value: "devices"),
            URLQueryItem(name: "rid", value: deviceID)
        ]

        return components.url!
    }
}

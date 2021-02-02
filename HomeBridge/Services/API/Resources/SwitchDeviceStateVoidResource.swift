//  SwitchDeviceStateVoidResource.swift
//  HomeBridge
//
//  Created by colin on 21/04/2020.
//  Copyright © 2020 the striped lawn company. All rights reserved.
import Foundation

struct SwitchDeviceStateVoidResource: APIVoidResource {
    typealias ModelType = PlanDeviceDetail
    let methodPath = "/json.htm"
    let deviceID: String
    let newState: String

    var url: URL {
        var components = URLComponents(string: configProvider.automationAddress)!
        components.path = methodPath
        components.queryItems = [
            URLQueryItem(name: "type", value: "command"),
            URLQueryItem(name: "param", value: "switchlight"),
            URLQueryItem(name: "idx", value: deviceID),
            URLQueryItem(name: "switchcmd", value: newState)
        ]

        return components.url!
    }
}

//  RelayMessageSendResource.swift
//  HomeBridge
//
//  Created by colin on 14/05/2020.
//  Copyright © 2020 the striped lawn company. All rights reserved.
import Foundation

struct RelayMessageVoidResource: APIVoidResource {
    typealias ModelType = PlanDeviceDetail
    let methodPath = "/json.htm"
    let userID: String
    let message: String

    // http://192.168.8.55:1026/api/colin/notify?theMessage=Turned%20stuff%20off%20for%20you%20:)
    var url: URL {
        var components = URLComponents(string: configProvider.automationAddress)!
        components.path = "/api/\(userID)/notify"
        components.queryItems = [
            URLQueryItem(name: "theMessage", value: message.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed))
        ]

        return components.url!
    }
}

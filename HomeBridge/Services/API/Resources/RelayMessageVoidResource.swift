//  RelayMessageVoidResource.swift
//  HomeBridge
//
//  Created by colin on 14/05/2020.
//  Copyright © 2020 the striped lawn company. All rights reserved.
import Foundation

struct RelayMessageVoidResource: APIVoidResource {
    typealias ModelType = PlanDeviceDetail
    let userID: String
    let message: String

    var url: URL {
        var components = URLComponents(string: configProvider.relayMessageAddress)!
        components.path = "/api/\(userID)/notify"
        components.queryItems = [URLQueryItem(name: "theMessage", value: message)]

        return components.url!
    }
}

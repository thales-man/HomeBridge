//  RelayMessageService.swift
//  HomeBridge
//
//  Created by colin on 15/05/2020.
//  Copyright © 2020 the striped lawn company. All rights reserved.
import Foundation

struct RelayMessageService {
    
    func relayMessage(userID: String, message: String, finished: @escaping (Bool) -> Void) {
        if !configProvider.useRelayMessaging {
            return
        }
        
        let deviceRequest = BridgeVoidRequest(apiResource: RelayMessageVoidResource(userID: userID, message: message))
        
        deviceRequest.invoke(finished:  finished)
    }
}

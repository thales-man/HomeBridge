//  AdvertisingPublicationCoordinator.swift
//  HomeBridge
//
//  Created by colin on 01/05/2020.
//  Copyright © 2020 the striped lawn company. All rights reserved.
import SwiftUI
import Logging

final class AdvertisingPublicationCoordinator {
    private var publishedIDs: [String] = []
    
    func startListening() {
        publishedIDs.removeAll()
        advertisingService.clearAccessories()
        mediator.subscribe(.devicePublication, theObserver: self, selector: #selector(processCandidate(_:)))
    }
    
    private func post(theMessage: String) {
        mediator.publish(.addToConsole, theInfo: [Logger.Level.info: theMessage])
    }

    @objc private func processCandidate(_ notification: Notification) {
        if let data = notification.userInfo as? [String: ManageableDevice]
        {
            for (accessoryID, candidate) in data
            {
                if !publishedIDs.contains(accessoryID) {
                    publishedIDs.append(accessoryID)
                    post(theMessage: "commencing publication of: (\(accessoryID))")
                    advertisingService.addAccessory(device: candidate)
                }
            }
        }
    }
}

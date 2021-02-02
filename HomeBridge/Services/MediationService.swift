//  MediationService.swift
//  HomeBridge
//
//  Created by colin on 10/05/2020.
//  Copyright © 2020 the striped lawn company. All rights reserved.
import Foundation

final class MediationService {
    let nc = NotificationCenter.default
    
    func publish(_ theNotification: Notification.Name, theInfo: [AnyHashable : Any]) {
        nc.post(name: theNotification, object: nil, userInfo: theInfo)
    }
    
    func subscribe(_ theNotification: NSNotification.Name, theObserver: Any, selector theSelector: Selector) {
        nc.addObserver(theObserver, selector: theSelector, name: theNotification, object: nil)
    }
}

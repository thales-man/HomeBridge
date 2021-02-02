//  ConsoletTextProvider.swift
//  HomeBridge
//
//  Created by colin on 25/04/2020.
//  Copyright © 2020 the striped lawn company. All rights reserved.
import Foundation
import Logging

final class ConsoleTextProvider: ObservableObject {
    @Published var consoleText: String
    
    init() {
        consoleText = "initialising console..."
        mediator.subscribe(.addToConsole, theObserver: self, selector: #selector(logToConsole(_:)))
    }
    
    @objc func logToConsole(_ notification: Notification) {
        if let data = notification.userInfo as? [Logger.Level: String]
        {
            for (level, message) in data
            {
                if self.consoleText.lengthOfBytes(using: .utf16) > 50000 {
                    self.consoleText = ""
                }
                
                self.consoleText += "\n(\(level)), \(message)"
            }
        }
    }
}

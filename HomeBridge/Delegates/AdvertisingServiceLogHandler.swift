//  AdvertisingServiceLogHandler.swift
//  HomeBridge
//
//  Created by colin on 26/04/2020.
//  Copyright © 2020 the striped lawn company. All rights reserved.
import Foundation
import Logging

// FIXME: do we need this?
struct AdvertisingServiceLogHandler: LogHandler {
    var metadata: Logger.Metadata = [:]
    var logLevel: Logger.Level = .info
    
    init(label: String) {
        // print("initialising my log handler...")
    }
    
    public func log(level: Logger.Level, message: Logger.Message, metadata: Logger.Metadata?,
                    file: String, function: String, line: UInt) {
        
        mediator.publish(.addToConsole, theInfo: [level: message.description])
    }
    
    public subscript(metadataKey metadataKey: String) -> Logger.Metadata.Value? {
        get {
            return self.metadata[metadataKey]
        }
        set(newValue) {
            self.metadata[metadataKey] = newValue
        }
    }
}

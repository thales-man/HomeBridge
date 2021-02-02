//  DeviceIdentifiers.swift
//  HomeBridge
//
//  Created by colin on 25/04/2020.
//  Copyright © 2020 the striped lawn company. All rights reserved.
import Foundation

struct DeviceIdentifiers {
    // type images
    static let motion: String = "motion"
    static let temperature: String = "temperature"
    static let lightBulb: String = "lightbulb"
    static let door: String = "door"
    static let doorContact: [String] = ["Open", "Closed"]

    // device icons
    static let heating: String = "Heating"
    static let phone: String = "Phone"
    static let tv: String = "TV"
    static let fan: String = "Fan"
    static let generic: String = "Generic"
    static let speaker: String = "Speaker"
    static let wallSocket: String = "WallSocket"
    static let media: String = "Media"
}

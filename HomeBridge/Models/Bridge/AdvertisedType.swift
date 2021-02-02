//  AdvertisedType.swift
//  HomeBridge
//
//  Created by colin on 25/04/2020.
//  Copyright © 2020 the striped lawn company. All rights reserved.
import Foundation
import HAP

enum AdvertisedType: Int, Identifiable, CaseIterable, Codable {
    
    // note: ths is not an exhaustive list of HAP Accessories
    // and is only the ones we are currently interested in
    case none, fan, lightbulb, doorLock, door, outlet, `switch`, thermometer, lightSensor, motionSensor
    // these things aren't covered yet
    // case airQualitySensor, contactSensor, smokeSensor, window, windowCovering, ipCamera, videoDoorbell, airDehumidifier
    
    // note: just in case we need to do someting like this again
    // static func usingLabel(_ label: String) -> AdvertisedType? {
    //     return self.allCases.first{ $0.name.capitalized == label.capitalized }
    // }
    
    var name: String {
        return "\(self)".map {
            $0.isUppercase ? " \($0)" : "\($0)"
        }
        .joined()
        .capitalized
    }
    
    var isSet: Bool {
        return self != .none
    }
    
    var offForDevice: String {
        switch(self) {
        case .door: return "Closed"
        case .doorLock: return "On"
        default: return "Off"
        }
    }
    
    var onForDevice: String {
        switch(self) {
        case .door: return "Open"
        case .doorLock: return "Off" // doors have inverted logic
        default: return "On"
        }
    }

    var inactiveForDevice: String {
        switch(self) {
        case .door: return "Closed"
        case .doorLock: return "Locked"
        default: return "Off"
        }
    }
    
    var activeForDevice: String {
        switch(self) {
        case .door: return "Open"
        case .doorLock: return "Unlocked"
        default: return "On"
        }
    }
    
    func isEqual(_ candidate: AdvertisedType) -> Bool {
        return self == candidate
    }
    
    var id: AdvertisedType { self }

    static func usingDevice(_ device: ManageableDevice) -> AdvertisedType {
        if let result = usingTypeImage(device) {
            return result
        }
        
        return usingImage(device)
    }
    
    private static func usingTypeImage(_ device: ManageableDevice) -> AdvertisedType? {
        switch(device.typeImage) {
        case DeviceIdentifiers.temperature:
            return .thermometer
        case DeviceIdentifiers.motion:
            return .motionSensor
        case DeviceIdentifiers.door:
            return DeviceIdentifiers.doorContact.contains(device.state)
                ? .door
                : .doorLock
        default:
            return nil
        }
    }
    
    private static func usingImage(_ device: ManageableDevice) -> AdvertisedType {
        switch(device.image) {
        case DeviceIdentifiers.wallSocket:
            return .outlet
        case DeviceIdentifiers.media:
            return .switch
        case DeviceIdentifiers.heating:
            return .thermometer
        case DeviceIdentifiers.phone:
            return .switch
        case DeviceIdentifiers.tv:
            return .switch
        case DeviceIdentifiers.generic:
            return .switch
        case DeviceIdentifiers.speaker:
            return .switch
        case DeviceIdentifiers.fan:
            return .fan
        default:
            return .lightbulb
        }
    }
}

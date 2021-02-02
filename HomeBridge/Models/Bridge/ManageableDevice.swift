//  ManageableDevice.swift
//  HomeBridge
//
//  Created by colin on 22/04/2020.
//  Copyright © 2020 the striped lawn company. All rights reserved.
import Foundation

final class ManageableDevice: ObservableObject, Identifiable, Equatable {
    
    @Published var id: String = "" {
        didSet {
            accessoryId = id.padToLeft(upTo: 5, using: "0")
        }
    }
    
    @Published var accessoryId: String = ""
    @Published var isAdvertised: Bool = true
    @Published var advertisedType: AdvertisedType = AdvertisedType.none
//        {
//        didSet {
//            confirmationState = .newDevice
//        }
//    }
    
    @Published var state: String = AdvertisedType.none.inactiveForDevice
    @Published var data: String = ""
    
    @Published var name: String = "" {
        didSet {
            confirmationState = .newDevice
        }
    }
    
    @Published var type: String = ""
    @Published var subType: String = ""
    @Published var image: String = ""
    @Published var typeImage: String = ""
    @Published var imageName: String = ""
    
    // 255 = 'no battery'
    @Published var batteryLevel: Int = 255
    @Published var lowBatteryAlertLevel: Float = 25
    @Published var lowBatteryAlert: Bool = false
    var hasBattery: Bool {
        return batteryLevel < 255
    }
    
    // FIXME: add proper support for dimmer types
    @Published var dimmerType: String = "none"
    @Published var supportsDimming: Bool = false
    @Published var dimmedPercentage: Int = 100
    @Published var dimmedLevel: Int = 100
    @Published var maxDimmedLevel: Int = 100
    
    @Published var lastUpdated: String
    @Published var confirmationState: DeviceConfirmedState = .newDevice
    
    var bridgedDevice: BridgedAccessory? = nil
    
    private let dateFormatter = DateFormatter()
    private var requestStateChange: (ManageableDevice, String) -> Void = { _,_ in }
    
    // note: only done so the 'navigation item' doesn't become 'optional'
    init() {
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .long
        
        lastUpdated = dateFormatter.string(from: Date())
    }
    
    init(planDevice: PlanDeviceDetail, withSwitchState switchState: @escaping (ManageableDevice, String) -> Void) {
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .long
        
        lastUpdated = dateFormatter.string(from: Date())
        
        id = planDevice.id
        name = planDevice.name
        
        if let _image = planDevice.image {
            image = _image
        }
        
        if let _state = planDevice.state {
            state = _state
        }
        
        type = planDevice.type
        subType = planDevice.subType
        typeImage = planDevice.typeImg
        requestStateChange = switchState
        batteryLevel = planDevice.batteryLevel
        data = planDevice.data
        
        if let _dimmerType = planDevice.dimmerType {
            dimmerType = _dimmerType
        }
        
        if let _haveDimmer = planDevice.haveDimmer {
            supportsDimming = _haveDimmer && dimmerType != "none"
        }
        
        if let _dimmedLevel = planDevice.levelInt {
            dimmedLevel = _dimmedLevel
        }
        
        if let _maxDimmedLevel = planDevice.maxDimLevel {
            maxDimmedLevel = _maxDimmedLevel
        }
        
        // "Level" : 96 <= is this the percentage from 'max'?
        //      (31 / 32) * 100 = 96.87 (rounding issue?)
        dimmedPercentage = (maxDimmedLevel == 0) ? 100 : Int(exactly: round(Double((dimmedLevel / maxDimmedLevel) * 100))) ?? 100
        
        advertisedType = AdvertisedType.usingDevice(self)
        imageName = getImageName()
    }
    
    init(publishedDevice: PublishableDevice, withSwitchState switchState: @escaping (ManageableDevice, String) -> Void) {
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .long
        
        lastUpdated = dateFormatter.string(from: Date())
        
        id = publishedDevice.id
        name = publishedDevice.name
        state = publishedDevice.advertisedType.inactiveForDevice
        type = publishedDevice.type
        subType = publishedDevice.subType
        requestStateChange = switchState
        lowBatteryAlertLevel = publishedDevice.lowBatteryAlertLevel
        
        advertisedType = publishedDevice.advertisedType
        imageName = getImageName()
        confirmationState = .notConfirmed
    }
    
    static func == (lhs: ManageableDevice, rhs: ManageableDevice) -> Bool {
        return lhs.id == rhs.id
            && lhs.state == rhs.state
            && lhs.data == rhs.data
            && lhs.batteryLevel == rhs.batteryLevel
    }
    
    func switchState(requestedState: String) {
        requestStateChange(self, requestedState)
    }
    
    func updateDevice(delta: ManageableDevice) {
        if self != delta {
            state = delta.state
            data = delta.data
            batteryLevel = delta.batteryLevel
            
            bridgedDevice?.switchState(requestedState: state)
        }
        
        if(confirmationState == .notConfirmed) {
            confirmationState = .confirmed
            
            image = delta.image
            typeImage = delta.typeImage
            dimmerType = delta.dimmerType
            supportsDimming = delta.supportsDimming
            dimmedLevel = delta.dimmedLevel
            maxDimmedLevel =  delta.maxDimmedLevel
            dimmedPercentage = delta.dimmedPercentage
            
            mediator.publish(.devicePublication, theInfo: [accessoryId: self])
        }
        
        imageName = getImageName()
        lastUpdated = dateFormatter.string(from: Date())
    }
    
    private func getImageName() -> String {
        return "\(advertisedType.name)\(state)"
    }
}

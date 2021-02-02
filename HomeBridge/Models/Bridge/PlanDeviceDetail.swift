//  PlanDeviceDetail.swift
//  HomeBridge
//
//  Created by colin on 21/04/2020.
//  Copyright © 2020 the striped lawn company. All rights reserved.
import Foundation

struct PlanDeviceDetail: Decodable {
    let name: String
    let id: String
    let customImage: Int
    let image: String?
    let state: String?
    let type: String
    let subType: String
    let typeImg: String
    let batteryLevel: Int
    let dimmerType: String?
    let haveDimmer: Bool?
    let protocolID: String
    let level: Int?
    let levelInt: Int?
    let maxDimLevel: Int?
    let data: String
    
    enum CodingKeys: String, CodingKey {
        case name = "Name"
        case id = "idx"
        case customImage = "CustomImage"
        case image = "Image"
        case state = "Status"
        case data = "Data"
        case type = "Type"
        case subType = "SubType"
        case typeImg = "TypeImg"
        case batteryLevel = "BatteryLevel"
        case dimmerType = "DimmerType"
        case haveDimmer = "HaveDimmer"
        case protocolID = "ID"
        case level = "Level"
        case levelInt = "LevelInt"
        case maxDimLevel = "MaxDimLevel"
    }
}

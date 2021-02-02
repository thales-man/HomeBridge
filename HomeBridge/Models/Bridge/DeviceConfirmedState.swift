//  DeviceConfirmedState.swift
//  HomeBridge
//
//  Created by colin on 28/04/2020.
//  Copyright © 2020 the striped lawn company. All rights reserved.
import SwiftUI

enum DeviceConfirmedState {
    case notConfirmed, confirmed, newDevice
    
    func color() -> Color {
        switch self {
        case .notConfirmed:
            return .statusAttentionColor
        case .newDevice:
            return .statusOKColor
        default:
            return .secondaryAccentColor
        }
    }
}

//  TelemetryError.swift
//  HomeBridge
//
//  Created by colin on 26/04/2020.
//  Copyright © 2020 the striped lawn company. All rights reserved.
import Foundation

enum TelemetryError: Error {
    case none
    case socketError
    case connectionError(TelemetryConnectionResponse)
    case streamError(Error?)
}

extension TelemetryError: Equatable {
    public static func ==(lhs: TelemetryError, rhs: TelemetryError) -> Bool {
        switch (lhs, rhs) {
        case (.none, .none), (.socketError, .socketError):
            return true
        case (.connectionError(let lhsResponse), .connectionError(let rhsResponse)):
            return lhsResponse == rhsResponse
        default:
            return false
        }
    }
}

extension TelemetryError: CustomStringConvertible {
    public var description: String {
        switch self {
        case .none:
            return "None"
        case .socketError:
            return "Socket Error"
        case .streamError:
            return "Stream Error"
        case .connectionError(let response):
            return "Connection Error: \(response.localizedDescription)"
        }
    }

    public var localizedDescription: String {
        return description
    }
}

typealias TelemetryCompletionBlock = (_ error: TelemetryError) -> Void

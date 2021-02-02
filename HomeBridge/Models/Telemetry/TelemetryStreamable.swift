//  TelemetryStreamable.swift
//  HomeBridge
//
//  Created by colin on 27/04/2020.
//  Copyright © 2020 the striped lawn company. All rights reserved.
import Foundation

protocol TelemetryStreamable {
    init?(len: Int, from read: StreamReader)
    func write(to write: StreamWriter) -> Bool
}

typealias StreamReader = (_ buffer: UnsafeMutablePointer<UInt8>, _ len: Int) -> Int
typealias StreamWriter = (_ buffer: UnsafePointer<UInt8>, _ len: Int) -> Int

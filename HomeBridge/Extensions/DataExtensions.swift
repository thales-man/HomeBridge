//  DataExtensions.swift
//  HomeBridge
//
//  Created by colin on 27/04/2020.
//  Copyright © 2020 the striped lawn company. All rights reserved.
import Foundation

extension Data: TelemetryStreamable {
    
    init?(len: Int, from read: StreamReader) {
        self.init(count: len)
        if self.read(from: read) == false {
            return nil
        }
    }
    
    mutating func read(from read: StreamReader) -> Bool {
        let totalLength = self.count
        var readLength: Int = 0
        self.withUnsafeBytes { (buffer: UnsafePointer<UInt8>) in
            repeat {
                let b = UnsafeMutablePointer(mutating: buffer) + readLength
                let bytesRead = read(b, totalLength - readLength)
                if bytesRead < 0 {
                    break
                }
                readLength += bytesRead
            } while readLength < totalLength
        }
        return readLength == totalLength
    }
    
    func write(to write: StreamWriter) -> Bool {
        let totalLength = self.count
        guard totalLength <= 128*128*128 else { return false }
        var writeLength: Int = 0
        self.withUnsafeBytes { (buffer: UnsafePointer<UInt8>) in
            repeat {
                let b = UnsafeMutablePointer(mutating: buffer) + writeLength
                let byteWritten = write(b, totalLength - writeLength)
                if byteWritten < 0 {
                    break
                }
                writeLength += byteWritten
            } while writeLength < totalLength
        }
        return writeLength == totalLength
    }
    
    mutating func telemetryEncodeRemaining(length: Int) {
        var lengthOfRemainingData = length
        
        repeat {
            var digit = UInt8(lengthOfRemainingData % 128)
            lengthOfRemainingData /= 128
            if lengthOfRemainingData > 0 {
                digit |= 0x80
            }
            append(&digit, count: 1)
        } while lengthOfRemainingData > 0
    }
    
    mutating func telemetryAppend(_ data: UInt8) {
        var varData = data
        append(&varData, count: 1)
    }
    
    // big endian appends two bytes
    mutating func telemetryAppend(_ data: UInt16) {
        let byteOne = UInt8(data / 256)
        let byteTwo = UInt8(data % 256)
        
        telemetryAppend(byteOne)
        telemetryAppend(byteTwo)
    }
    
    mutating func telemetryAppend(_ data: Data) {
        telemetryAppend(UInt16(data.count))
        append(data)
    }
    
    mutating func telemetryAppend(_ string: String) {
        telemetryAppend(UInt16(string.count))
        append(string.data(using: .utf8)!)
    }
    
    static func readPackedLength(from read: StreamReader) -> Int? {
        var multiplier = 1
        var length = 0
        var encodedByte: UInt8 = 0
        repeat {
            let _ = read(&encodedByte, 1)
            length += (Int(encodedByte) & 127) * multiplier
            multiplier *= 128
            if multiplier > 128*128*128 {
                return nil
            }
        } while ((Int(encodedByte) & 128) != 0)
        return length <= 128*128*128 ? length : nil
    }
}

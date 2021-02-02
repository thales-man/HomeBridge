//  ConfigFileStorage.swift
//  HomeBridge
//
//  Created by colin on 17/05/2020.
//  Copyright © 2020 the striped lawn company. All rights reserved.
import COperatingSystem
import Foundation
import HAP

final class ConfigFileStorage : Storage {
    let filename: String
    
    init(filename: String) {
        self.filename = filename
    }
    
    func read() throws -> Data {
        let fd = fopen(filename, "r")
        if fd == nil { try throwError() }
        try posix(fseek(fd, 0, COperatingSystem.SEEK_END))
        let size = ftell(fd)
        rewind(fd)
        var buffer = Data(count: size)

        _ = buffer.withUnsafeMutableBytes {
            COperatingSystem.fread($0, size, 1, fd)
        }

        fclose(fd)
        return buffer
    }
    
    func write(_ newValue: Data) throws {
        let fd = COperatingSystem.fopen(filename, "w")
        _ = newValue.withUnsafeBytes {
            COperatingSystem.fwrite($0, newValue.count, 1, fd)
        }

        fclose(fd)
    }

    // had to copy the whole 'file storage' class for this routine :(
    func exists() -> Bool {
        let fd = fopen(self.filename, "r")

        if fd == nil {
            return false
        }
        
        return true
    }
}

//  StringExtensions.swift
//  HomeBridge
//
//  Created by colin on 28/04/2020.
//  Copyright © 2020 the striped lawn company. All rights reserved.
import Foundation

extension String {
    func padToLeft(upTo length: Int, using element: Element = " ") -> String {
        return String(repeatElement(element, count: Swift.max(0, length-count)) + suffix(Swift.max(count, count-length)))
    }
    
    func asFloat() -> Float {
        return (self as NSString).floatValue
    }
}

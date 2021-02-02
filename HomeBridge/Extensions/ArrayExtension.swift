//  ArrayExtension.swift
//  HomeBridge
//
//  Created by colin on 10/05/2020.
//  Copyright © 2020 the striped lawn company. All rights reserved.
import Foundation

extension Array where Element == Double {
    
    mutating func enqueue(newElement: Double) {
        self.append(newElement)
    }
    
    mutating func dequeue() -> Double? {
        return self.remove(at: 0)
    }
    
    func peek() -> Double? {
        return self.first
    }
    
    mutating func Increment() {
        let lastPosition = self.count - 1
        var last = self.last!
        last += 1.0
        remove(at: lastPosition)
        append(last)
    }
}

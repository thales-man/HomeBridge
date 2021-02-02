//  CollectionExtension.swift
//  HomeBridge
//
//  Created by colin on 12/05/2020.
//  Copyright © 2020 the striped lawn company. All rights reserved.
import Foundation

extension Collection {
    func count(where test: (Element) throws -> Bool) rethrows -> Int {
        return try self.filter(test).count
    }

    func isUnique(where test: (Element) throws -> Bool) rethrows -> Bool {
        return try self.filter(test).count == 1
    }

    func hasAny(where test: (Element) throws -> Bool) rethrows -> Bool {
        return try self.filter(test).count > 0
    }
}

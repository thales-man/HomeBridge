//  APIFetchResource.swift
//  HomeBridge
//
//  Created by colin on 21/04/2020.
//  Copyright © 2020 the striped lawn company. All rights reserved.
import Foundation

protocol APIFetchResource: APIVoidResource {
    associatedtype ModelType: Decodable
}

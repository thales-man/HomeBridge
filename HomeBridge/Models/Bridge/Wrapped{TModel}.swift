//  Wrapper{TModelType}.swift
//  HomeBridge
//
//  Created by colin on 21/04/2020.
//  Copyright © 2020 the striped lawn company. All rights reserved.
import Foundation

// note: this class is a Json deserialisation mechanism only
struct Wrapped<T: Decodable>: Decodable {
    let listContainer: Array<T>
    
    enum CodingKeys: String, CodingKey {
        case listContainer = "result"
    }
}

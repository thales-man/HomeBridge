//  BridgeFetchRequest{TFetchResource}.swift
//  HomeBridge
//
//  Created by colin on 21/04/2020.
//  Copyright © 2020 the striped lawn company. All rights reserved.
import Foundation

final class BridgeFetchRequest<Resource: APIFetchResource>: APIFetchRequest {
    let resource: Resource
    
    init(apiResource: Resource) {
        resource = apiResource
    }

    func decode(_ data: Data) -> Array<Resource.ModelType>? {
        let wrapped = try! JSONDecoder().decode(Wrapped<Resource.ModelType>.self, from: data)
        return wrapped.listContainer
    }
    
    func fetch(withCompletion completion: @escaping (Array<Resource.ModelType>?) -> Void) {
        fetch(resource.url, withCompletion: completion)
    }
}

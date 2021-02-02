//  BridgeRequest{TPatchResource}.swift
//  HomeBridge
//
//  Created by colin on 21/04/2020.
//  Copyright © 2020 the striped lawn company. All rights reserved.
import Foundation

final class BridgeVoidRequest<Resource: APIVoidResource>: APIVoidRequest {
    let resource: Resource
    
    init(apiResource: Resource) {
        resource = apiResource
    }

    func invoke(finished: @escaping (Bool) -> Void) {
        invoke(resource.url, finished: finished)
    }
}

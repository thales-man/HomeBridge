//  APIPatchRequest.swift
//  HomeBridge
//
//  Created by colin on 21/04/2020.
//  Copyright © 2020 the striped lawn company. All rights reserved.
import Foundation

protocol APIVoidRequest: AnyObject {
    func invoke(finished: @escaping (Bool) -> Void)
}

extension APIVoidRequest {
    
    func invoke(_ url: URL, finished: @escaping (Bool) -> Void) {
        
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: .main)
        let task = session.dataTask(with: url) { (data, response, error) in
            guard
                let response = response,
                let httpResponse = response as? HTTPURLResponse
             else {
                return
            }

            finished(httpResponse.statusCode == 200)
        }

        task.resume()
    }
}

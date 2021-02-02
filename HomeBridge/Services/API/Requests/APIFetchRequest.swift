//  APIFetchRequest.swift
//  HomeBridge
//
//  Created by colin on 21/04/2020.
//  Copyright © 2020 the striped lawn company. All rights reserved.
import Foundation

protocol APIFetchRequest: AnyObject {
    associatedtype ModelType
    func decode(_ data: Data) -> ModelType?
    func fetch(withCompletion completion: @escaping (ModelType?) -> Void)
}

extension APIFetchRequest {
    
    func fetch(_ url: URL, withCompletion completion: @escaping (ModelType?) -> Void) {
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: .main)
        let task = session.dataTask(with: url, completionHandler: { [self] (data: Data?, response: URLResponse?, error: Error?) -> Void in
            guard
                let data = data
                else {
                    completion(nil)
                    return
                }

            completion(self.decode(data))
        })

        task.resume()
    }
}

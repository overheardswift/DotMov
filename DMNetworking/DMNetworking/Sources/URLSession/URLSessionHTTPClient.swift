//
//  URLSessionHTTPClient.swift
//  DMNetworking
//
//  Created by Bayu Kurniawan on 28/07/23.
//

import Foundation

public final class URLSessionHTTPClient: HTTPClient {
    
    public typealias Result = HTTPClient.Result
    
    private struct URLSessionTaskWrapper: HTTPClientTask {
        let wrapped: URLSessionTask
        func cancel() {
            wrapped.cancel()
        }
    }
    
    private struct UnexpectedValuesRepresentation: Error {}
    
    private let session: URLSession
    
    public init(session: URLSession = .shared) {
        self.session = session
    }
    
    public func fetch(_ request: URLRequest, completion: @escaping (Result) -> Void) -> HTTPClientTask {
        let task = session.dataTask(with: request) { data, response, error in
            completion(Result {
                if let error {
                   throw error
                } else if let data, let response = response as? HTTPURLResponse {
                    return (data, response)
                } else {
                   throw UnexpectedValuesRepresentation()
                }
            })
        }
        
        task.resume()
        return URLSessionTaskWrapper(wrapped: task)
    }
}

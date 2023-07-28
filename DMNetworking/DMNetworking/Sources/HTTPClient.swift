//
//  HTTPClient.swift
//  DMNetworking
//
//  Created by Bayu Kurniawan on 28/07/23.
//

import Foundation

public protocol HTTPClientTask {
    func cancel()
}

public protocol HTTPClient {
    typealias Result = Swift.Result<(data: Data, response: HTTPURLResponse), Error>
    
    @discardableResult
    func fetch(_ request: URLRequest, completion: @escaping (Result) -> Void) -> HTTPClientTask
}

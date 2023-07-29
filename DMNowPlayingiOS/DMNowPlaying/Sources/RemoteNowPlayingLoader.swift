//
//  RemoteNowPlayingLoader.swift
//  DMNowPlaying
//
//  Created by Bayu Kurniawan on 29/07/23.
//

import Foundation
import DMNetworking

public final class RemoteNowPlayingLoader: NowPlayingLoader {
    
    public enum Error: Swift.Error {
        case connectivity
        case invalidResponse
    }
    
    public typealias Result = NowPlayingLoader.Result
    
    private let baseURL: URL
    private let client: HTTPClient
    
    public init(
        baseURL: URL,
        client: HTTPClient
    ) {
        self.baseURL = baseURL
        self.client = client
    }
    
    public func execute(_ req: PagedNowPlayingRequest, completion: @escaping (Result) -> Void) {
        let request = URLRequest(url: baseURL)
        
        client.fetch(request) { _ in }
    }
}

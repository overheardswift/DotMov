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
        let request = URLRequest(url: enrich(baseURL, with: req))
        
        client.fetch(request) { result in
            switch result {
            case let .success(values):
                guard values.response.statusCode == 200 else {
                    return completion(.failure(Error.invalidResponse))
                }
            case .failure:
                completion(.failure(Error.connectivity))
            }
        }
    }
}

private extension RemoteNowPlayingLoader {
    func enrich(_ url: URL, with req: PagedNowPlayingRequest) -> URL {
        let requestURL = url
            .appending(path: "3")
            .appending(path: "movie")
            .appending(path: "now_playing")
        
        var urlComponents = URLComponents(url: requestURL, resolvingAgainstBaseURL: false)
        urlComponents?.queryItems = [
            URLQueryItem(name: "language", value: req.language),
            URLQueryItem(name: "page", value: String(req.page))
        ]
        
        return urlComponents?.url ?? requestURL
    }
}

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
        
        client.fetch(request) { [weak self] result in
            guard self != nil else { return }
            
            switch result {
            case let .success((data, response)):
                completion(RemoteNowPlayingLoader.map(data, from: response))
            case .failure:
                completion(.failure(Error.connectivity))
            }
        }
    }
}

private extension RemoteNowPlayingLoader {
    func enrich(_ url: URL, with req: PagedNowPlayingRequest) -> URL {
        let requestURL = url
            .appendingPathComponent("3")
            .appendingPathComponent("movie")
            .appendingPathComponent("now_playing")
        
        var urlComponents = URLComponents(url: requestURL, resolvingAgainstBaseURL: false)
        urlComponents?.queryItems = [
            URLQueryItem(name: "language", value: req.language),
            URLQueryItem(name: "page", value: String(req.page))
        ]
        
        return urlComponents?.url ?? requestURL
    }
    
    static func map(_ data: Data, from response: HTTPURLResponse) -> Result {
        do {
            let items = try NowPlayingItemsMapper.map(data, from: response)
            return .success(items.asPageDTO)
        } catch {
            return .failure(error)
        }
    }
}

private extension RemoteNowPlayingFeed {
    var asPageDTO: NowPlayingFeed {
        return NowPlayingFeed(
            items: results.asCardDTO,
            page: page,
            totalPages: total_pages
        )
    }
}

private extension Array where Element == RemoteNowPlayingFeed.RemoteNowPlayingItem {
    var asCardDTO: [NowPlayingItem] {
        return map { item in
            NowPlayingItem(
                id: item.id,
                title: item.original_title,
                imagePath: item.poster_path ?? "",
                releaseDate: item.release_date ?? "",
                genreIds: item.genre_ids ?? []
            )
        }
    }
}

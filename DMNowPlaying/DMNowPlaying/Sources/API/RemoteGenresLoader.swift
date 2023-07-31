//
//  RemoteGenresLoader.swift
//  DMNowPlaying
//
//  Created by Bayu Kurniawan on 31/07/23.
//

import Foundation
import DMNetworking

public final class RemoteGenresLoader: GenresLoader {
	
	public enum Error: Swift.Error {
		case connectivity
		case invalidResponse
	}
	
	public typealias Result = GenresLoader.Result
	
	private let baseURL: URL
	private let client: HTTPClient
	
	public init(
		baseURL: URL,
		client: HTTPClient
	) {
		self.baseURL = baseURL
		self.client = client
	}
	
	public func load(completion: @escaping (Result) -> Void) {
		let request = URLRequest(url: enrich(baseURL))
		
		client.fetch(request) { [weak self] result in
			guard self != nil else { return }
			
			switch result {
			case let .success((data, response)):
				completion(RemoteGenresLoader.map(data, from: response))
			case .failure:
				completion(.failure(Error.connectivity))
			}
		}
	}
	
}

private extension RemoteGenresLoader {
	func enrich(_ url: URL) -> URL {
		return url
			.appendingPathComponent("3")
			.appendingPathComponent("genre")
			.appendingPathComponent("movie")
			.appendingPathComponent("list")
	}
	
	static func map(_ data: Data, from response: HTTPURLResponse) -> Result {
		do {
			let item = try GenresMapper.map(data, from: response)
			return .success(item.genres.asGenresDTO)
		} catch {
			return .failure(error)
		}
	}
}

private extension Array where Element == RemoteGenres.Genre {
	var asGenresDTO: [Genre] {
		return map { item in
			Genre(
				id: item.id,
				name: item.name
			)
		}
	}
}

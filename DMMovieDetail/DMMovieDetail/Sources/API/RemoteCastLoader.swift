//
//  RemoteCastLoader.swift
//  DMMovieDetail
//
//  Created by Bayu Kurniawan on 31/07/23.
//

import Foundation
import DMNetworking

public final class RemoteCastLoader: CastLoader {
	
	public typealias Result = CastLoader.Result
	
	public enum Error: Swift.Error {
		case connectivity
		case invalidResponse
	}
	
	private let baseURL: URL
	private let client: HTTPClient
	
	public init(baseURL: URL, client: HTTPClient) {
		self.baseURL = baseURL
		self.client = client
	}
	
	public func load(id: Int, completion: @escaping (Result) -> Void) {
		client.fetch(URLRequest(url: enrich(baseURL, with: id)), completion: { [weak self] result in
			guard self != nil else { return }
			switch result {
			case let .success((data, response)): completion(RemoteCastLoader.map(data, from: response))
			case .failure: completion(.failure(Error.connectivity))
			}
		})
	}
}

private extension RemoteCastLoader {
	func enrich(_ url: URL, with movieID: Int) -> URL {
		let requestURL = url
			.appendingPathComponent("3")
			.appendingPathComponent("movie")
			.appendingPathComponent("\(movieID)")
			.appendingPathComponent("credits")
		
		return requestURL
	}
	
	static func map(_ data: Data, from response: HTTPURLResponse) -> Result {
		do {
			let value = try CastMapper.map(data, from: response)
			return .success(value.cast.asCast)
		} catch {
			return .failure(error)
		}
	}
}

private extension Array where Element == RemoteCasts.RemoteCast {
	var asCast: [Cast] {
		return map {
			Cast(
				id: $0.id,
				name: $0.original_name,
				profilePath: $0.profile_path ?? ""
			)
		}
	}
}

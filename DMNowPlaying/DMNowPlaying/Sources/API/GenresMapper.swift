//
//  GenresMapper.swift
//  DMNowPlaying
//
//  Created by Bayu Kurniawan on 31/07/23.
//

import Foundation

struct RemoteGenres: Decodable {
	
	struct Genre: Decodable {
		let id: Int
		let name: String
	}
	
	let genres: [Genre]
}

final class GenresMapper {
	
	private static var OK_200: Int { return 200 }
	
	static func map(_ data: Data, from response: HTTPURLResponse) throws -> RemoteGenres {
		guard response.statusCode == OK_200, let page = try? JSONDecoder().decode(RemoteGenres.self, from: data) else {
			throw RemoteNowPlayingLoader.Error.invalidResponse
		}
		
		return page
	}
}

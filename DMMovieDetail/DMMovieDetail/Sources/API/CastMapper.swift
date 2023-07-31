//
//  CastMapper.swift
//  DMMovieDetail
//
//  Created by Bayu Kurniawan on 31/07/23.
//

import Foundation

struct RemoteCast: Decodable {
	let id: Int
	let original_name: String
	let profile_path: String
}

final class CastMapper {

	private static var OK_200: Int { return 200 }

	static func map(_ data: Data, from response: HTTPURLResponse) throws -> RemoteCast {
		guard response.statusCode == OK_200, let page = try? JSONDecoder().decode(RemoteCast.self, from: data) else {
			throw RemoteCastLoader.Error.invalidResponse
		}

		return page
	}
}

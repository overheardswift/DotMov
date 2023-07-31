//
//  NowPlayingLoader.swift
//  DMNowPlaying
//
//  Created by Bayu Kurniawan on 29/07/23.
//

import Foundation

public struct PagedNowPlayingRequest: Equatable {
	public let page: Int
	public let language: String
	public let query: String
	
	public init(page: Int, language: String = "ID-id", query: String = "") {
		self.page = page
		self.language = language
		self.query = query
	}
}

public protocol NowPlayingLoader {
	typealias Result = Swift.Result<NowPlayingFeed, Error>
	func execute(_ req: PagedNowPlayingRequest, completion: @escaping (Result) -> Void)
}

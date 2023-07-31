//
//  NowPlayingPagingViewModel.swift
//  DMNowPlaying
//
//  Created by Bayu Kurniawan on 30/07/23.
//

import Foundation

public struct NowPlayingPagingViewModel: Equatable {
	public let isLoading: Bool
	public let isLast: Bool
	public let pageNumber: Int
	public let isSearchActive: Bool
	
	public var nextPage: Int? {
		return isLast || isSearchActive ? nil : pageNumber + 1
	}
	
	public init(isLoading: Bool, isLast: Bool, pageNumber: Int, isSearchActive: Bool) {
		self.isLoading = isLoading
		self.isLast = isLast
		self.pageNumber = pageNumber
		self.isSearchActive = isSearchActive
	}
}

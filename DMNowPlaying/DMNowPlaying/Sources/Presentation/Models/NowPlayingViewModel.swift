//
//  NowPlayingViewModel.swift
//  DMNowPlaying
//
//  Created by Bayu Kurniawan on 30/07/23.
//

import Foundation

public struct NowPlayingViewModel: Equatable {
	public let pageNumber: Int
	public let items: [NowPlayingItemViewModel]
}

//
//  NowPlayingFeed.swift
//  DMNowPlaying
//
//  Created by Bayu Kurniawan on 29/07/23.
//

import Foundation

public struct NowPlayingFeed: Equatable {
    public let items: [NowPlayingItem]
    public let page: Int
    public let totalPages: Int
    
    public init(
        items: [NowPlayingItem],
        page: Int,
        totalPages: Int
    ) {
        self.items = items
        self.page = page
        self.totalPages = totalPages
    }
}

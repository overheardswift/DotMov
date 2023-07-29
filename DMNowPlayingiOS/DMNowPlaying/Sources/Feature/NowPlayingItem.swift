//
//  NowPlayingItem.swift
//  DMNowPlaying
//
//  Created by Bayu Kurniawan on 29/07/23.
//

import Foundation

public struct NowPlayingItem: Equatable {
    public let id: Int
    public let title: String
    public let imagePath: String
    public let releaseDate: String
    public let genreIds: [Int]
    
    public init(
        id: Int,
        title: String,
        imagePath: String,
        releaseDate: String,
        genreIds: [Int]
    ) {
        self.id = id
        self.title = title
        self.imagePath = imagePath
        self.releaseDate = releaseDate
        self.genreIds = genreIds
    }
}

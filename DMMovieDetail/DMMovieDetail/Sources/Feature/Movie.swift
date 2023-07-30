//
//  Movie.swift
//  DMMovieDetail
//
//  Created by Bayu Kurniawan on 30/07/23.
//

import Foundation

public struct Movie: Equatable {
  public let id: Int
  public let title: String
  public let length: CGFloat
  public let genres: [String]
  public let overview: String
  public let backdropImagePath: String

  public init(id: Int, title: String, length: CGFloat, genres: [String], overview: String, backdropImagePath: String) {
    self.id = id
    self.title = title
    self.length = length
    self.genres = genres
    self.overview = overview
    self.backdropImagePath = backdropImagePath
  }
}

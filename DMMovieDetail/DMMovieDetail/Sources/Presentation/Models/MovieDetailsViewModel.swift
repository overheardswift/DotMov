//
//  MovieDetailsViewModel.swift
//  DMMovieDetail
//
//  Created by Bayu Kurniawan on 30/07/23.
//

import Foundation

public struct MovieDetailsViewModel<Image> {

  public let image: Image?
  public let title: String?
  public let runtime: String?
	public let genre: String?
  public let overview: String?

  public let isLoading: Bool
  public let error: String?

  public init(
    image: Image?,
    title: String?,
    runtime: String?,
		genre: String?,
    overview: String?,
    isLoading: Bool,
    error: String?
  ) {
    self.image = image
    self.title = title
    self.runtime = runtime
		self.genre = genre
    self.overview = overview
    self.isLoading = isLoading
    self.error = error
  }

  public static var showLoading: MovieDetailsViewModel<Image> {
      return .init(
        image: nil,
        title: nil,
        runtime: nil,
				genre: nil,
        overview: nil,
        isLoading: true,
        error: nil
      )
  }
}

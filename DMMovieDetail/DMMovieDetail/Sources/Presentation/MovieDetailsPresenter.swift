//
//  MovieDetailsPresentation.swift
//  DMMovieDetail
//
//  Created by Bayu Kurniawan on 30/07/23.
//

import Foundation

public protocol MovieDetailsView {
  associatedtype Image
  func display(_ model: MovieDetailsViewModel<Image>)
}

public final class MovieDetailsPresenter<View: MovieDetailsView, Image> where View.Image == Image {

  private let view: View
  private let imageTransformer: (Data) -> Image?

  public init(view: View, imageTransformer: @escaping (Data) -> Image?) {
    self.view = view
    self.imageTransformer = imageTransformer
  }

  public func didStartLoading() {
    view.display(.showLoading)
  }

  public func didFinishLoadingImageData(with data: Data, for movie: Movie) {
    view.display(MovieDetailsViewModel<Image>(
      image: imageTransformer(data),
      title: movie.title,
			runtime: makeMovieRuntime(length: movie.length),
			genre: makeMovieGenre(genres: movie.genres),
      overview: movie.overview,
      isLoading: false,
      error: nil
      )
    )
  }
}

private extension MovieDetailsPresenter {
  func makeMovieRuntime(length: CGFloat) -> String {
		let runTime = Double(length * 60).asString(style: .abbreviated)
    return runTime
  }
	
	func makeMovieGenre(genres: [String]) -> String {
		let genre = genres.map { $0.capitalizingFirstLetter() }.joined(separator: ", ")
		return genre
	}
}

extension String {
  func capitalizingFirstLetter() -> String {
    return prefix(1).capitalized + dropFirst()
  }

  mutating func capitalizeFirstLetter() {
    self = self.capitalizingFirstLetter()
  }
}

extension Double {
  func asString(style: DateComponentsFormatter.UnitsStyle) -> String {
    let formatter = DateComponentsFormatter()
    formatter.allowedUnits = [.hour, .minute, .second]
    formatter.unitsStyle = style
    guard let formattedString = formatter.string(from: self) else { return "" }
    return formattedString
  }
}

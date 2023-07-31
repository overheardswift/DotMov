//
//  MovieDetailsCastImagePresenter.swift
//  DMMovieDetail
//
//  Created by Bayu Kurniawan on 31/07/23.
//

import Foundation

public protocol MovieDetailsCastImageView {
	associatedtype Image
	func display(_ model: MovieDetailsCastImageViewModel<Image>)
}

public final class MovieDetailsCastImagePresenter<View: MovieDetailsCastImageView, Image> where View.Image == Image {

	private let view: View
	private let imageTransformer: (Data) -> Image?

	public init(view: View, imageTransformer: @escaping (Data) -> Image?) {
		self.view = view
		self.imageTransformer = imageTransformer
	}

	public func didStartLoadingImageData() {
		view.display(MovieDetailsCastImageViewModel<Image>(image: nil, isLoading: true))
	}

	public func didFinishLoadingImageData(with data: Data) {
		let image = imageTransformer(data)
		view.display(MovieDetailsCastImageViewModel<Image>(image: image, isLoading: false))
	}
}

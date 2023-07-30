//
//  MovieLoaderPresentationAdapter.swift
//  DMMovieDetailiOS
//
//  Created by Bayu Kurniawan on 30/07/23.
//

import Foundation
import DMMedia
import DMMovieDetail

final class MovieDetailsPresentationAdapter<View: MovieDetailsView, Image>: MovieDetailsViewControllerDelegate where View.Image == Image {
	
	var presenter: MovieDetailsPresenter<View, Image>?
	
	private let id: Int
	private let loader: MovieLoader
	private let imageLoader: ImageDataLoader
	
	private var task: ImageDataLoaderTask?
	
	init(id: Int, loader: MovieLoader, imageLoader: ImageDataLoader) {
		self.id = id
		self.loader = loader
		self.imageLoader = imageLoader
	}
	
	func didRequestLoad() {
		presenter?.didStartLoading()
		loader.load(id: id, completion: { [weak self] result in
			guard let self = self else { return }
			switch result {
			case let .success(movie): self.loadImage(for: movie)
			case .failure: break
			}
		})
	}
}

private extension MovieDetailsPresentationAdapter {
	func loadImage(for model: Movie) {
		task = imageLoader.load(from: makeImageURL(withPath: model.backdropImagePath), completion: { [weak self] result in
			guard let self = self else { return }
			switch result {
			case let .success(imageData): self.presenter?.didFinishLoadingImageData(with: imageData, for: model)
			case .failure: break
			}
		})
	}
	
	func makeImageURL(withPath path: String) -> URL {
		return URL(string: "https://image.tmdb.org/t/p/w1280/")!.appendingPathComponent(path)
	}
}

//
//  MovieDetailsCastImagePresentationAdapter.swift
//  DMMovieDetailiOS
//
//  Created by Bayu Kurniawan on 31/07/23.
//

import Foundation
import DMMovieDetail
import DMMedia

final class MovieDetailsCastImagePresentationAdapter<View: MovieDetailsCastImageView, Image>: CastCellControllerDelegate where View.Image == Image {
		
		var presenter: MovieDetailsCastImagePresenter<View, Image>?
		
		private let baseURL: URL
		private let model: MovieDetailsCastViewModel
		private let imageLoader: ImageDataLoader
		
		private var task: ImageDataLoaderTask?
		
		init(baseURL: URL, model: MovieDetailsCastViewModel, imageLoader: ImageDataLoader) {
				self.baseURL = baseURL
				self.model = model
				self.imageLoader = imageLoader
		}
		
		func didRequestLoadImage() {
				presenter?.didStartLoadingImageData()
				task = imageLoader.load(from: makeImageURL(withPath: model.profilePath), completion: { [weak self] result in
						guard let self = self else { return }
						switch result {
						case let .success(imageData): self.presenter?.didFinishLoadingImageData(with: imageData)
						default: break
						}
				})
		}
		
		func didRequestCancelLoadImage() {
				task?.cancel()
				task = nil
		}
}

private extension MovieDetailsCastImagePresentationAdapter {
		func makeImageURL(withPath path: String) -> URL {
				return baseURL.appendingPathComponent(path)
		}
}

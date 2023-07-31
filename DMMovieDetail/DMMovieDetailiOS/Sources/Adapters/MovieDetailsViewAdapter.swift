//
//  MovieDetailsViewAdapter.swift
//  DMMovieDetailiOS
//
//  Created by Bayu Kurniawan on 31/07/23.
//

import UIKit
import DMMedia
import DMMovieDetail
import DMCommon

final class MovieDetailsViewAdapter {
	
	private weak var controller: MovieDetailsViewController?
	private let imageLoader: ImageDataLoader
	
	init(controller: MovieDetailsViewController? = nil, imageLoader: ImageDataLoader) {
		self.controller = controller
		self.imageLoader = imageLoader
	}
}

extension MovieDetailsViewAdapter: MovieDetailsView {
	public func display(_ model: MovieDetailsViewModel<UIImage>) {
		controller?.set(model)
	}
	
	public func display(_ casts: [MovieDetailsCastViewModel]) {
		let controllers = casts.map(makeCellController)
		controller?.set(controllers)
	}
}

private extension MovieDetailsViewAdapter {
	func makeCellController(for model: MovieDetailsCastViewModel) -> CastCellController{
		let adapter = MovieDetailsCastImagePresentationAdapter<WeakRefVirtualProxy<CastCellController>, UIImage>(
			baseURL: URL(string: "https://image.tmdb.org/t/p/w200/")!,
			model: model,
			imageLoader: imageLoader
		)
		
		let cellController = CastCellController(model: model, delegate: adapter)
		
		adapter.presenter = MovieDetailsCastImagePresenter(
			view: WeakRefVirtualProxy(cellController),
			imageTransformer: UIImage.init
		)
		
		return cellController
	}
}

extension WeakRefVirtualProxy: MovieDetailsCastImageView where T: MovieDetailsCastImageView, T.Image == UIImage {
	public func display(_ model: MovieDetailsCastImageViewModel<UIImage>) {
		object?.display(model)
	}
}

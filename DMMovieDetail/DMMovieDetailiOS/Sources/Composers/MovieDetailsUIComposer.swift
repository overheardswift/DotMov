//
//  MovieDetailsUIComposer.swift
//  DMMovieDetailiOS
//
//  Created by Bayu Kurniawan on 30/07/23.
//

import UIKit
import DMMedia
import DMMovieDetail
import DMCommon

public enum MovieDetailsUIComposer {
	public static func compose(
		id: Int,
		movieLoader: MovieLoader,
		castLoader: CastLoader,
		imageLoader: ImageDataLoader
	) -> MovieDetailsViewController {
	
		let movieAdapter = MovieDetailsPresentationAdapter<MovieDetailsViewAdapter, UIImage>(
			id: id,
			movieLoader: MainQueueDispatchDecorator(movieLoader),
			castLoader: MainQueueDispatchDecorator(castLoader),
			imageLoader: MainQueueDispatchDecorator(imageLoader)
		)
		
		let viewController = MovieDetailsViewController(
			delegate: movieAdapter
		)

	
		movieAdapter.presenter = MovieDetailsPresenter(
			view: MovieDetailsViewAdapter(
				controller: viewController,
				imageLoader: MainQueueDispatchDecorator(imageLoader)
			),
			imageTransformer: UIImage.init
		)
		
		return viewController
	}
}

extension WeakRefVirtualProxy: MovieDetailsView where T: MovieDetailsView, T.Image == UIImage {
	public func display(_ model: MovieDetailsViewModel<UIImage>) {
		object?.display(model)
	}
	
	public func display(_ casts: [MovieDetailsCastViewModel]) {
		object?.display(casts)
	}
}

extension MainQueueDispatchDecorator: MovieLoader where T == MovieLoader {
	public func load(id: Int, completion: @escaping (MovieLoader.Result) -> Void) {
		decoratee.load(id: id, completion: { [weak self] result in
			self?.dispatch { completion(result) }
		})
	}
}

extension MainQueueDispatchDecorator: CastLoader where T == CastLoader {
	public func load(id: Int, completion: @escaping (CastLoader.Result) -> Void) {
		decoratee.load(id: id, completion: { [weak self] result in
			self?.dispatch { completion(result) }
		})
	}
}

extension MainQueueDispatchDecorator: ImageDataLoader where T == ImageDataLoader {
	public func load(from imageURL: URL, completion: @escaping (ImageDataLoader.Result) -> Void) -> ImageDataLoaderTask {
		decoratee.load(from: imageURL, completion: { [weak self] result in
			self?.dispatch { completion(result) }
		})
	}
}

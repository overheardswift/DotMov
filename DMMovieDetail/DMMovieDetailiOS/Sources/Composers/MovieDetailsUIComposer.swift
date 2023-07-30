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
		loader: MovieLoader,
		imageLoader: ImageDataLoader
	) -> MovieDetailsViewController {
		
		let adapter = MovieDetailsPresentationAdapter<WeakRefVirtualProxy<MovieDetailsViewController>, UIImage>(
			id: id,
			loader: MainQueueDispatchDecorator(loader),
			imageLoader: MainQueueDispatchDecorator(imageLoader)
		)
		
		let viewController = MovieDetailsViewController(delegate: adapter)
		
		adapter.presenter = MovieDetailsPresenter(
			view: WeakRefVirtualProxy(viewController),
			imageTransformer: UIImage.init
		)
		
		return viewController
	}
}

extension WeakRefVirtualProxy: MovieDetailsView where T: MovieDetailsView, T.Image == UIImage {
	public func display(_ model: MovieDetailsViewModel<UIImage>) {
		object?.display(model)
	}
}

extension MainQueueDispatchDecorator: MovieLoader where T == MovieLoader {
	public func load(id: Int, completion: @escaping (MovieLoader.Result) -> Void) {
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

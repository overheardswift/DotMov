//
//  NowPlayingUIComposer.swift
//  DMNowPlayingiOS
//
//  Created by Bayu Kurniawan on 30/07/23.
//

import Foundation
import DMNowPlaying
import DMMedia
import DMCommon

public enum NowPlayingUIComposer {
	
	public static func compose(
		loader: NowPlayingLoader,
		imageLoader: ImageDataLoader,
		onSelectCallback: @escaping (Int) -> Void
	) -> NowPlayingViewController {
		
		let adapter = NowPlayingPresentationAdapter(loader: MainQueueDispatchDecorator(loader))
		let refreshController = NowPlayingRefreshController(delegate: adapter)
		let pagingController = NowPlayingPagingController(delegate: adapter)
		let viewController = NowPlayingViewController(
			refreshController: refreshController,
			pagingController: pagingController
		)
		
		adapter.presenter = NowPlayingPresenter(
			view: NowPlayingViewAdapter(
				controller: viewController,
				imageLoader: MainQueueDispatchDecorator(imageLoader),
				onSelectCallback: onSelectCallback
			),
			loadingView: WeakRefVirtualProxy(refreshController),
			pagingView: WeakRefVirtualProxy(pagingController)
		)
		
		return viewController
	}
}

extension MainQueueDispatchDecorator: NowPlayingLoader where T == NowPlayingLoader {
	public func execute(_ req: PagedNowPlayingRequest, completion: @escaping (NowPlayingLoader.Result) -> Void) {
		decoratee.execute(req, completion: { [weak self] result in
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

class WeakRefVirtualProxy<T: AnyObject> {
	private(set) weak var object: T?
	
	init(_ object: T) {
		self.object = object
	}
}


extension WeakRefVirtualProxy: NowPlayingLoadingView where T: NowPlayingLoadingView {
	func display(_ viewModel: NowPlayingLoadingViewModel) {
		object?.display(viewModel)
	}
}

extension WeakRefVirtualProxy: NowPlayingPagingView where T: NowPlayingPagingView {
	func display(_ viewModel: NowPlayingPagingViewModel) {
		object?.display(viewModel)
	}
}

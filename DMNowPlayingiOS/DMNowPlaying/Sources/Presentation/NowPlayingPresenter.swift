//
//  NowPlayingPresenter.swift
//  DMNowPlaying
//
//  Created by Bayu Kurniawan on 30/07/23.
//

import Foundation

public protocol NowPlayingView {
	func display(_ viewModel: NowPlayingViewModel)
}

public protocol NowPlayingLoadingView {
	func display(_ viewModel: NowPlayingLoadingViewModel)
}

public protocol NowPlayingPagingView {
	func display(_ viewModel: NowPlayingPagingViewModel)
}

public class NowPlayingPresenter {
	
	private let view: NowPlayingView
	private let loadingView: NowPlayingLoadingView
	private let pagingView: NowPlayingPagingView
	
	public init(view: NowPlayingView, loadingView: NowPlayingLoadingView, pagingView: NowPlayingPagingView) {
		self.view = view
		self.loadingView = loadingView
		self.pagingView = pagingView
	}
	
	public func didStartLoading() {
		loadingView.display(.init(isLoading: true))
		pagingView.display(.init(isLoading: true, isLast: true, pageNumber: 0))
	}
	
	public func didFinishLoading(with feed: NowPlayingFeed, genres: [Genre]) {
		loadingView.display(.init(isLoading: false))
		pagingView.display(.init(isLoading: false, isLast: feed.page == feed.totalPages, pageNumber: feed.page))
		view.display(.init(pageNumber: feed.page, items: feed.items.presentedItems(with: genres)))
	}
	
	public func didFinishLoadingWithError() {
		loadingView.display(.init(isLoading: false))
	}
}

private extension String {
	var presentedDateString: String {
		let stringToDateFormatter = DateFormatter()
		stringToDateFormatter.dateFormat = "yyyy-mm-dd"
		
		guard let date = stringToDateFormatter.date(from: self) else {
			return self
		}
		
		let dateToStringFormatter = DateFormatter()
		dateToStringFormatter.dateFormat = "yyyy"
		return dateToStringFormatter.string(from: date)
	}
}

public extension Array where Element == NowPlayingItem {
	func presentedItems(with genres: [Genre]) -> [NowPlayingItemViewModel] {
		return map {
			NowPlayingItemViewModel(
				id: $0.id,
				title: $0.title,
				imagePath: $0.imagePath,
				releaseDate: $0.releaseDate.presentedDateString,
				genre: $0.genreIds.genres(genres).joined(separator: ", ")
			)
		}
	}
}

private extension Array where Element == Int {
	func genres(_ genres: [Genre]) -> [String] {
		return genres.filter {
			self.contains($0.id)
		}.map { $0.name }
	}
}

//
//  NowPlayingPresentationAdapter.swift
//  DMNowPlayingiOS
//
//  Created by Bayu Kurniawan on 30/07/23.
//

import Foundation
import DMNowPlaying

final class NowPlayingPresentationAdapter {
	
	var presenter: NowPlayingPresenter?
	
	private let nowPlayingLoader: NowPlayingLoader
	private let genresLoader: GenresLoader
	
	init(nowPlayingLoader: NowPlayingLoader, genresLoader: GenresLoader) {
		self.nowPlayingLoader = nowPlayingLoader
		self.genresLoader = genresLoader
	}
}

extension NowPlayingPresentationAdapter: NowPlayingRefreshControllerDelegate {
	func didRequestLoad() {
		presenter?.didStartLoading()
		loadNowPlayingMovies(page: 1)
	}
}

extension NowPlayingPresentationAdapter: NowPlayingPagingControllerDelegate {
	func didRequestPage(page: Int) {
		presenter?.didStartLoading()
		loadNowPlayingMovies(page: page)
	}
}

private extension NowPlayingPresentationAdapter {
	func loadNowPlayingMovies(page: Int) {
		nowPlayingLoader.execute(.init(page: page)) { [weak self] result in
			guard let self else { return }
			switch result {
			case let .success(feed):
				self.loadGenres(feed: feed)
			case .failure:
				self.presenter?.didFinishLoadingWithError()
			}
		}
	}
	
	func loadGenres(feed: NowPlayingFeed) {
		genresLoader.load { [weak self] result in
			guard let self else { return }
			switch result {
			case let .success(genres):
				self.presenter?.didFinishLoading(with: feed, genres: genres)
			case .failure:
				self.presenter?.didFinishLoading(with: feed, genres: [])
			}
		}
	}
}

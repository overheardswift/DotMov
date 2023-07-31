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
	private let searchMovieLoader: NowPlayingLoader
	
	init(nowPlayingLoader: NowPlayingLoader, genresLoader: GenresLoader, searchMovieLoader: NowPlayingLoader) {
		self.nowPlayingLoader = nowPlayingLoader
		self.genresLoader = genresLoader
		self.searchMovieLoader = searchMovieLoader
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

extension NowPlayingPresentationAdapter: SearchControllerDelegate {
	func didClickSearch(with keyword: String) {
		presenter?.didStartLoading()
		searchMovies(page: 1, with: keyword)
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
	
	func loadGenres(feed: NowPlayingFeed, isSearchActive: Bool = false) {
		genresLoader.load { [weak self] result in
			guard let self else { return }
			switch result {
			case let .success(genres):
				self.presenter?.didFinishLoading(with: feed, genres: genres, isSearchActive: isSearchActive)
			case .failure:
				self.presenter?.didFinishLoading(with: feed, genres: [], isSearchActive: isSearchActive)
			}
		}
	}
	
	func searchMovies(page: Int, with keyword: String) {
		searchMovieLoader.execute(.init(page: page, query: keyword)) { [weak self] result in
			guard let self else { return }
			switch result {
			case let .success(feed):
				self.loadGenres(feed: feed, isSearchActive: true)
			case .failure:
				self.presenter?.didFinishLoadingWithError()
			}
		}
	}
}

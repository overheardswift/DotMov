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
    
    private let loader: NowPlayingLoader
    
    init(loader: NowPlayingLoader) {
        self.loader = loader
    }
}

extension NowPlayingPresentationAdapter: NowPlayingRefreshControllerDelegate {
    func didRequestLoad() {
        presenter?.didStartLoading()
        load(page: 1)
    }
}

extension NowPlayingPresentationAdapter: NowPlayingPagingControllerDelegate {
    func didRequestPage(page: Int) {
        presenter?.didStartLoading()
        load(page: page)
    }
}

private extension NowPlayingPresentationAdapter {
    func load(page: Int) {
        loader.execute(.init(page: page)) { [weak self] result in
            guard let self else { return }
            switch result {
            case let .success(feed):
                self.presenter?.didFinishLoading(with: feed)
            case .failure:
                self.presenter?.didFinishLoadingWithError()
            }
        }
    }
}

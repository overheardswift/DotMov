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
    
    public func didFinishLoading(with feed: NowPlayingFeed) {
        loadingView.display(.init(isLoading: false))
        view.display(.init(pageNumber: feed.page, items: feed.items))
        pagingView.display(.init(isLoading: false, isLast: feed.page == feed.totalPages, pageNumber: feed.page))
    }
    
    public func didFinishLoadingWithError() {
        loadingView.display(.init(isLoading: false))
    }
}

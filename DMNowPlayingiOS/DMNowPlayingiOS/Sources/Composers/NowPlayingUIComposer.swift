//
//  NowPlayingUIComposer.swift
//  DMNowPlayingiOS
//
//  Created by Bayu Kurniawan on 30/07/23.
//

import Foundation
import DMNowPlaying

public enum NowPlayingUIComposer {
    
    public static func compose(
        loader: NowPlayingLoader
    ) -> NowPlayingViewController {
        
        let adapter = NowPlayingPresentationAdapter(loader: MainQueueDispatchDecoratee(loader))
        let refreshController = NowPlayingRefreshController(delegate: adapter)
        let pagingController = NowPlayingPagingController(delegate: adapter)
        let viewController = NowPlayingViewController(
            refreshController: refreshController,
            pagingController: pagingController
        )
        
        adapter.presenter = NowPlayingPresenter(
            view: NowPlayingViewAdapter(controller: viewController),
            loadingView: WeakRefVirtualProxy(refreshController),
            pagingView: WeakRefVirtualProxy(pagingController)
        )
        
        return viewController
    }
}

private final class MainQueueDispatchDecoratee<T> {
    private(set) var decoratee: T
    
    init(_ decoratee: T) {
        self.decoratee = decoratee
    }
    
    func dispatch(completion: @escaping () -> Void) {
        guard Thread.isMainThread else {
            return DispatchQueue.main.async(execute: completion)
        }
        
        completion()
    }
}

extension MainQueueDispatchDecoratee: NowPlayingLoader where T == NowPlayingLoader {
    func execute(_ req: PagedNowPlayingRequest, completion: @escaping (NowPlayingLoader.Result) -> Void) {
        decoratee.execute(req, completion: { [weak self] result in
            self?.dispatch { completion(result) }
        })
    }
}

private class WeakRefVirtualProxy<T: AnyObject> {
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

//
//  NowPlayingViewAdapter.swift
//  DMNowPlayingiOS
//
//  Created by Bayu Kurniawan on 30/07/23.
//

import UIKit
import DMNowPlaying
import DMMedia

final class NowPlayingViewAdapter {
    
    private weak var controller: NowPlayingViewController?
    private let imageLoader: ImageDataLoader
    
    init(controller: NowPlayingViewController?, imageLoader: ImageDataLoader) {
        self.controller = controller
        self.imageLoader = imageLoader
    }
}

extension NowPlayingViewAdapter: NowPlayingView {
    func display(_ viewModel: NowPlayingViewModel) {
        let newItems = viewModel.items.map(makeCellController)
        
        if viewModel.pageNumber == 1 {
            controller?.set(newItems)
        } else {
            controller?.append(newItems)
        }
    }
}

private extension NowPlayingViewAdapter {
    func makeCellController(for model: NowPlayingItem) -> NowPlayingCellController {
        let adapter = NowPlayingImageDataLoaderPresentationAdapter<WeakRefVirtualProxy<NowPlayingCellController>, UIImage>(
          baseURL: URL(string: "https://image.tmdb.org/t/p/w500/")!,
          model: model,
          imageLoader: imageLoader
        )
        
        let view = NowPlayingCellController(model: model, delegate: adapter)
        adapter.presenter = NowPlayingImagePresenter(
            view: WeakRefVirtualProxy(view),
            imageTransformer: UIImage.init
        )
        
        return view
    }
}

extension WeakRefVirtualProxy: NowPlayingImageView where T: NowPlayingImageView, T.Image == UIImage {
    func display(_ model: NowPlayingImageViewModel<UIImage>) {
        object?.display(model)
    }
}

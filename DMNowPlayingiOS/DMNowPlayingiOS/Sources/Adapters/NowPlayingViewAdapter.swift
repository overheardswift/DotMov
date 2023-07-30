//
//  NowPlayingViewAdapter.swift
//  DMNowPlayingiOS
//
//  Created by Bayu Kurniawan on 30/07/23.
//

import UIKit
import DMNowPlaying

final class NowPlayingViewAdapter {
    
    private weak var controller: NowPlayingViewController?
    
    init(controller: NowPlayingViewController?) {
        self.controller = controller
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
        let view = NowPlayingCellController(model: model)
        return view
    }
}

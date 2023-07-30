//
//  NowPlayingPagingController.swift
//  DMNowPlayingiOS
//
//  Created by Bayu Kurniawan on 30/07/23.
//

import Foundation
import DMNowPlaying

protocol NowPlayingPagingControllerDelegate {
    func didRequestPage(page: Int)
}

final class NowPlayingPagingController {
    
    private let delegate: NowPlayingPagingControllerDelegate
    private var viewModel: NowPlayingPagingViewModel?
    
    init(delegate: NowPlayingPagingControllerDelegate) {
        self.delegate = delegate
    }
    
    func load() {
        guard let viewModel = viewModel,
              let nextPage = viewModel.nextPage,
              !viewModel.isLoading else {
            return
        }
        
        delegate.didRequestPage(page: nextPage)
    }
}

extension NowPlayingPagingController: NowPlayingPagingView {
    func display(_ viewModel: NowPlayingPagingViewModel) {
        self.viewModel = viewModel
    }
}

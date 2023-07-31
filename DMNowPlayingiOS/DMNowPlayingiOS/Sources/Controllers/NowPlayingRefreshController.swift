//
//  NowPlayingRefreshController.swift
//  DMNowPlayingiOS
//
//  Created by Bayu Kurniawan on 30/07/23.
//

import UIKit
import DMNowPlaying

protocol NowPlayingRefreshControllerDelegate {
	func didRequestLoad()
}

final class NowPlayingRefreshController: NSObject {
	
	private(set) lazy var view = loadView()
	
	private let delegate: NowPlayingRefreshControllerDelegate
	
	init(delegate: NowPlayingRefreshControllerDelegate) {
		self.delegate = delegate
	}
	
	@objc func refresh() {
		delegate.didRequestLoad()
	}
}

extension NowPlayingRefreshController: NowPlayingLoadingView {
	func display(_ viewModel: NowPlayingLoadingViewModel) {
		viewModel.isLoading ? view.beginRefreshing() : view.endRefreshing()
	}
}

private extension NowPlayingRefreshController {
	func loadView() -> UIRefreshControl {
		let view = UIRefreshControl(frame: .zero)
		view.addTarget(self, action: #selector(refresh), for: .valueChanged)
		return view
	}
}

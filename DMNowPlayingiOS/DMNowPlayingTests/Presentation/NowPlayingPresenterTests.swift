//
//  NowPlayingPresenterTests.swift
//  DMNowPlayingTests
//
//  Created by Bayu Kurniawan on 30/07/23.
//

import XCTest
import DMNowPlaying

class NowPlayingPresenterTests: XCTestCase {
	
	func test_on_init_does_not_message_view() {
		let (_, view) = makeSUT()
		XCTAssertTrue(view.messages.isEmpty)
	}
	
	func test_did_start_loading() {
		let (sut, view) = makeSUT()
		
		sut.didStartLoading()
		XCTAssertEqual(view.messages, [.display(isLoading: true), .display(page: .init(isLoading: true, isLast: true, pageNumber: 0))])
	}
	
	func test_did_finish_loading_success_displays_feed_and_stops_loading() {
		let (sut, view) = makeSUT()
		let items = Array(0..<1).map { index in
			NowPlayingItem(
				id: index,
				title: "Item #\(index)",
				imagePath: "image-\(index).png",
				releaseDate: "2023-01-01",
				genreIds: [1, 2, 3]
			)
		}
		let feed = NowPlayingFeed(items: items, page: 1, totalPages: 1)
		
		sut.didFinishLoading(with: feed, genres: [])
		XCTAssertEqual(view.messages, [
			.display(isLoading: false),
			.display(page: .init(isLoading: false, isLast: true, pageNumber: 1)),
			.display(items: items.presentedItems(with: []))
		])
	}
}

private extension NowPlayingPresenterTests {
	
	func makeSUT(file: StaticString = #file, line: UInt = #line) -> (sut: NowPlayingPresenter, view: ViewSpy) {
		let view = ViewSpy()
		let sut = NowPlayingPresenter(view: view, loadingView: view, pagingView: view)
		checkForMemoryLeaks(view, file: file, line: line)
		checkForMemoryLeaks(sut, file: file, line: line)
		return (sut, view)
	}
	
	class ViewSpy: NowPlayingLoadingView, NowPlayingView, NowPlayingPagingView {
		
		enum Message: Equatable {
			case display(isLoading: Bool)
			case display(items: [NowPlayingItemViewModel])
			case display(page: NowPlayingPagingViewModel)
		}
		
		private(set) var messages: [Message] = []
		
		func display(_ viewModel: NowPlayingLoadingViewModel) {
			messages.append(.display(isLoading: viewModel.isLoading))
		}
		
		func display(_ viewModel: NowPlayingViewModel) {
			messages.append(.display(items: viewModel.items))
		}
		
		func display(_ viewModel: NowPlayingPagingViewModel) {
			messages.append(.display(page: viewModel))
		}
	}
}

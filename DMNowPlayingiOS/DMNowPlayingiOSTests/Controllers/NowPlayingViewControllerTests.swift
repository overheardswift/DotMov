//
//  NowPlayingViewControllerTests.swift
//  NowPlayingViewControllerTests
//
//  Created by Bayu Kurniawan on 30/07/23.
//

import XCTest
import DMNowPlaying
import DMNowPlayingiOS

class NowPlayingViewControllerTests: XCTestCase {
    
    // MARK: Rendering
    
    func test_load_actions_request_now_playing_from_loader() {
        let (sut, loader) = makeSUT()
        XCTAssertTrue(loader.messages.isEmpty)
        
        sut.loadViewIfNeeded()
        XCTAssertEqual(loader.messages, [.load(PagedNowPlayingRequest(page: 1))])
        
        sut.simulateUserRefresh()
        XCTAssertEqual(loader.messages, [
            .load(PagedNowPlayingRequest(page: 1)),
            .load(PagedNowPlayingRequest(page: 1))
        ])
    }
    
    func test_loading_indicator_is_visible_during_loading_state() {
        let (sut, loader) = makeSUT()
        
        sut.loadViewIfNeeded()
        XCTAssertTrue(sut.loadingIndicatorIsVisible)
        
        loader.loadFeedCompletes(with: .success(.init(items: [], page: 1, totalPages: 1)))
        XCTAssertFalse(sut.loadingIndicatorIsVisible)
        
        sut.simulateUserRefresh()
        XCTAssertTrue(sut.loadingIndicatorIsVisible)
        
        loader.loadFeedCompletes(with: .failure(makeError()))
        XCTAssertFalse(sut.loadingIndicatorIsVisible)
    }
    
    func test_load_completion_renders_successfully_loaded_now_playing_feed() {
        let (sut, loader) = makeSUT()
        let items = Array(0..<10).map { index in makeNowPlayingItem(id: index, title: "Card #\(index)") }
        let feedPage = makeNowPlayingFeed(items: items, pageNumber: 1, totalPages: 1)
        
        sut.loadViewIfNeeded()
        assertThat(sut, isRendering: [])
        
        loader.loadFeedCompletes(with: .success(feedPage))
        assertThat(sut, isRendering: items)
    }
    
    // MARK: Main Thread
    
    func test_now_playing_loader_completes_from_background_to_main_thread() {
        let (sut, loader) = makeSUT()
        let item = makeNowPlayingItem(id: 0)
        let feedPage = makeNowPlayingFeed(items: [item], pageNumber: 1, totalPages: 1)
        sut.loadViewIfNeeded()
        
        let exp = expectation(description: "await background queue")
        DispatchQueue.global().async {
            loader.loadFeedCompletes(with: .success(feedPage))
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1.0)
    }
    
    // MARK: Pagination
    
    func test_on_scroll_to_buttom_requests_next_page() {
        let (sut, loader) = makeSUT()
        let items = Array(0..<25).map { index in makeNowPlayingItem(id: index) }
        let feedPage = makeNowPlayingFeed(items: items, pageNumber: 1, totalPages: 10)
        
        sut.loadViewIfNeeded()
        loader.loadFeedCompletes(with: .success(feedPage))
        
        sut.simulatePagingRequest()
        XCTAssertEqual(loader.messages, [
            .load(PagedNowPlayingRequest(page: 1)),
            .load(PagedNowPlayingRequest(page: 2))
        ])
    }
    
    func test_on_scroll_to_buttom_does_not_request_if_on_last_page() {
        let (sut, loader) = makeSUT()
        let items = Array(0..<5).map { index in makeNowPlayingItem(id: index) }
        let feedPage = makeNowPlayingFeed(items: items, pageNumber: 1, totalPages: 1)
        
        sut.loadViewIfNeeded()
        loader.loadFeedCompletes(with: .success(feedPage))
        
        sut.simulatePagingRequest()
        XCTAssertEqual(loader.messages, [
            .load(PagedNowPlayingRequest(page: 1))
        ])
    }
    
    func test_onUserRefresh_afterPagingRequest_requestsFirstPageAgain() {
        let (sut, loader) = makeSUT()
        let items = Array(0..<25).map { index in makeNowPlayingItem(id: index) }
        let feedPage = makeNowPlayingFeed(items: items, pageNumber: 1, totalPages: 10)
        
        sut.loadViewIfNeeded()
        loader.loadFeedCompletes(with: .success(feedPage))
        
        sut.simulatePagingRequest()
        sut.simulateUserRefresh()
        
        XCTAssertEqual(loader.messages, [
            .load(PagedNowPlayingRequest(page: 1)),
            .load(PagedNowPlayingRequest(page: 2)),
            .load(PagedNowPlayingRequest(page: 1))
        ])
    }
    
    func test_onUserRefresh_afterPagingRequest_appendsNextPage() {
        let (sut, loader) = makeSUT()
        
        let items1 = (0..<10).map { index in makeNowPlayingItem(id: index, title: "Page 1 - Item #\(index)") }
        let feedPage1 = makeNowPlayingFeed(items: items1, pageNumber: 1, totalPages: 2)
        
        let items2 = (0..<10).map { index in makeNowPlayingItem(id: index, title: "Page 2 - Item #\(index)") }
        let feedPage2 = makeNowPlayingFeed(items: items2, pageNumber: 2, totalPages: 2)
        
        sut.loadViewIfNeeded()
        assertThat(sut, isRendering: [])
        
        loader.loadFeedCompletes(with: .success(feedPage1))
        assertThat(sut, isRendering: items1)
        
        sut.simulatePagingRequest()
        loader.loadFeedCompletes(with: .success(feedPage2))
        assertThat(sut, isRendering: items1 + items2)
    }
    
    func test_onUserRefresh_afterPagingRequest_rendersOnlyTheFirstPage() {
        let (sut, loader) = makeSUT()
        
        let items1 = (0..<10).map { index in makeNowPlayingItem(id: index, title: "Page 1 - Item #\(index)") }
        let feedPage1 = makeNowPlayingFeed(items: items1, pageNumber: 1, totalPages: 2)
        
        let items2 = (0..<10).map { index in makeNowPlayingItem(id: index, title: "Page 2 - Item #\(index)") }
        let feedPage2 = makeNowPlayingFeed(items: items2, pageNumber: 2, totalPages: 2)
        
        sut.loadViewIfNeeded()
        loader.loadFeedCompletes(with: .success(feedPage1))
        
        sut.simulatePagingRequest()
        loader.loadFeedCompletes(with: .success(feedPage2))
        
        sut.simulateUserRefresh()
        loader.loadFeedCompletes(with: .success(feedPage1))
        assertThat(sut, isRendering: items1)
    }
}

private extension NowPlayingViewControllerTests {
    func makeSUT(onSelectSpy: @escaping (Int) -> Void = { _ in }, file: StaticString = #file, line: UInt = #line) -> (NowPlayingViewController, LoaderSpy) {
        let loader = LoaderSpy()
        let sut = NowPlayingUIComposer.compose(loader: loader)
        
        checkForMemoryLeaks(loader, file: file, line: line)
        checkForMemoryLeaks(sut, file: file, line: line)
        
        return (sut, loader)
    }
    
    func makeNowPlayingFeed(items: [NowPlayingItem] = [], pageNumber: Int = 0, totalPages: Int = 1) -> NowPlayingFeed {
        return NowPlayingFeed(items: items, page: pageNumber, totalPages: totalPages)
    }
    
    func makeNowPlayingItem(id: Int, title: String? = nil, imagePath: String? = nil ) -> NowPlayingItem {
        return NowPlayingItem(id: id, title: title ?? UUID().uuidString, imagePath: imagePath ?? "\(UUID().uuidString).jpg", releaseDate: "2023-01-27", genreIds: [1, 2, 3])
    }
    
    func assertThat(_ sut: NowPlayingViewController, isRendering feed: [NowPlayingItem], file: StaticString = #file, line: UInt = #line) {
        guard sut.numberOfItems == feed.count else {
            return XCTFail("Expected \(feed.count) items, got \(sut.numberOfItems) instead.", file: file, line: line)
        }
        feed.indices.forEach { index in
            assertThat(sut, hasViewConfiguredFor: feed[index], at: index)
        }
    }
    
    func assertThat(_ sut: NowPlayingViewController, hasViewConfiguredFor item: NowPlayingItem, at index: Int, file: StaticString = #file, line: UInt = #line) {
        let cell = sut.itemAt(index)
        guard let _ = cell as? NowPlayingCell else {
            return XCTFail("Expected \(NowPlayingCell.self) instance, got \(String(describing: cell)) instead", file: file, line: line)
        }
    }
    
    class LoaderSpy: NowPlayingLoader {
        
        enum Message: Equatable {
            case load(PagedNowPlayingRequest)
        }
        
        private(set) var messages: [Message] = []
        private var loadCompletions: [(NowPlayingLoader.Result) -> Void] = []
        
        func execute(_ req: PagedNowPlayingRequest, completion: @escaping (NowPlayingLoader.Result) -> Void) {
            messages.append(.load(req))
            loadCompletions.append(completion)
        }
        
        func loadFeedCompletes(with result: NowPlayingLoader.Result, at index: Int = 0) {
            loadCompletions[index](result)
        }
    }
}

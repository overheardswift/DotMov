//
//  DMNowPlayingTests.swift
//  DMNowPlayingTests
//
//  Created by Bayu Kurniawan on 29/07/23.
//
import XCTest
import DMNowPlaying
import DMNetworking

class RemoteNowPlayingLoaderTests: XCTestCase {
    
    func test_on_init_does_not_request_data_from_remote() {
        let (_, client) = makeSUT()
        XCTAssertTrue(client.requestedURLs.isEmpty)
    }
    
    func test_execute_requests_data_from_remote() {
        let request = PagedNowPlayingRequest(page: 1)
        let expectedURL = makeURL("https://some-remote-url.dev/3/movie/now_playing?language=\(request.language)&page=\(request.page)")
        let baseURL = makeURL("https://some-remote-url.dev")
        let (sut, client) = makeSUT(baseURL: baseURL)
        
        sut.execute(request) { _ in }
        
        XCTAssertEqual(client.requestedURLs, [expectedURL])
    }
    
    func test_execute_requests_data_from_remote_on_each_call() {
        let request = PagedNowPlayingRequest(page: 1)
        let expectedURL = makeURL("https://some-remote-url.dev/3/movie/now_playing?language=\(request.language)&page=\(request.page)")
        let baseURL = makeURL("https://some-remote-url.dev")
        let (sut, client) = makeSUT(baseURL: baseURL)
        
        sut.execute(request) { _ in }
        sut.execute(request) { _ in }
        
        XCTAssertEqual(client.requestedURLs, [expectedURL, expectedURL])
    }
    
    func test_execute_delivers_error_on_client_error() {
        let (sut, client) = makeSUT()
        let error = makeError()
        expect(sut, toCompleteWith: failure(.connectivity), when: {
            client.completes(with: error)
        })
    }
    
    func test_execute_delivers_error_on_non_success_response() {
        let (sut, client) = makeSUT()
        let nonSuccessStatusCodes = [299, 300, 399, 400, 418, 499, 500]
        let data = makeData()
        
        nonSuccessStatusCodes.indices.forEach { index in
            expect(sut, toCompleteWith: failure(.invalidResponse), when: {
                client.completes(withStatusCode: nonSuccessStatusCodes[index], data: data, at: index)
            })
        }
    }
    
    func test_execute_delivers_error_on_success_response_with_invalid_json() {
      let (sut, client) = makeSUT()
      let invalidJSONData = Data("invalid json".utf8)
      expect(sut, toCompleteWith: failure(.invalidResponse), when: {
        client.completes(withStatusCode: 200, data: invalidJSONData)
      })
    }
    
    func test_execute_delivers_empty_collection_on_success_response_with_no_items() {
      let (sut, client) = makeSUT()
      let emptyPage = makeNowPlayingFeed(items: [], pageNumber: 1, totalPages: 1)
      let emptyPageData = makeItemsJSONData(for: emptyPage.json)
      expect(sut, toCompleteWith: .success(emptyPage.model), when: {
        client.completes(withStatusCode: 200, data: emptyPageData)
      })
    }
    
    func test_execute_delivers_now_playing_feed_on_success_response_with_items() {
      let (sut, client) = makeSUT()
      let items = Array(0..<3).map { index in makeNowPlayingItem(id: index) }
      let page = makeNowPlayingFeed(items: items, pageNumber: 1, totalPages: 1)
      let pageData = makeItemsJSONData(for: page.json)
      expect(sut, toCompleteWith: .success(page.model), when: {
        client.completes(withStatusCode: 200, data: pageData)
      })
    }
}

private extension RemoteNowPlayingLoaderTests {
    func makeSUT(baseURL: URL? = nil, file: StaticString = #file, line: UInt = #line) -> (NowPlayingLoader, HTTPClientSpy) {
      let client = HTTPClientSpy()
      let sut = RemoteNowPlayingLoader(baseURL: baseURL ?? makeURL(), client: client)

      checkForMemoryLeaks(client, file: file, line: line)
      checkForMemoryLeaks(sut, file: file, line: line)

      return (sut, client)
    }
    
    func expect(_ sut: NowPlayingLoader, toCompleteWith expectedResult: NowPlayingLoader.Result, when action: () -> Void, file: StaticString = #file, line: UInt = #line) {
      let exp = expectation(description: "Wait for load completion")
      let req = PagedNowPlayingRequest(page: 1)
      sut.execute(req, completion: { receivedResult in
        switch (receivedResult, expectedResult) {
          case let (.success(receivedItems), .success(expectedItems)):
            XCTAssertEqual(receivedItems, expectedItems, file: file, line: line)
          case let (.failure(receivedError as RemoteNowPlayingLoader.Error), .failure(expectedError as RemoteNowPlayingLoader.Error)):
            XCTAssertEqual(receivedError, expectedError, file: file, line: line)
          default:
            XCTFail("Expected result \(expectedResult) got \(receivedResult) instead", file: file, line: line)
        }
        exp.fulfill()
      })
      action()
      wait(for: [exp], timeout: 1.0)
    }
    
    func failure(_ error: RemoteNowPlayingLoader.Error) -> NowPlayingLoader.Result {
      return .failure(error)
    }
    
    func makeNowPlayingFeed(items: [(model: NowPlayingItem, json: [String : Any])] = [], pageNumber: Int = 0, totalPages: Int = 1) -> (model: NowPlayingFeed, json: [String: Any]) {

      let model = NowPlayingFeed(
        items: items.map { $0.model },
        page: pageNumber,
        totalPages: totalPages
      )

      let json: [String: Any] = [
        "results": items.map { $0.json },
        "page": pageNumber,
        "total_pages": totalPages
      ]

      return (model, json.compactMapValues { $0 })
    }

    func makeItemsJSONData(for items: [String: Any]) -> Data {
      let data = try! JSONSerialization.data(withJSONObject: items)
      return data
    }
    
    func makeNowPlayingItem(id: Int, title: String? = nil, imagePath: String? = nil ) -> (model: NowPlayingItem, json: [String: Any]) {
      let model = NowPlayingItem(
        id: id,
        title: title ?? UUID().uuidString,
        imagePath: imagePath ?? "\(UUID().uuidString).jpg",
        releaseDate: "2023-01-01",
        genreIds: [1, 2, 3]
      )

      let json: [String: Any] = [
        "id": model.id,
        "original_title": model.title,
        "poster_path": model.imagePath,
        "release_date": model.releaseDate,
        "genre_ids": model.genreIds
      ]

      return (model, json)
    }
}

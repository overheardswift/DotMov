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
}

private extension RemoteNowPlayingLoaderTests {
    func makeSUT(baseURL: URL? = nil, file: StaticString = #file, line: UInt = #line) -> (NowPlayingLoader, HTTPClientSpy) {
      let client = HTTPClientSpy()
      let sut = RemoteNowPlayingLoader(baseURL: baseURL ?? makeURL(), client: client)

      checkForMemoryLeaks(client, file: file, line: line)
      checkForMemoryLeaks(sut, file: file, line: line)

      return (sut, client)
    }
}

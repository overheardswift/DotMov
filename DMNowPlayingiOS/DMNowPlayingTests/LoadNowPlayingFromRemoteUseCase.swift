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

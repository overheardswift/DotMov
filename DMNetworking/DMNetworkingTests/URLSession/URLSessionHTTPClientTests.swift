//
//  URLSessionHTTPClientTests.swift
//  DMNetworkingTests
//
//  Created by Bayu Kurniawan on 28/07/23.
//

import XCTest
import DMNetworking

extension XCTestCase {
    
    func makeURL(_ urlString: String = "https://any-url.xyz", file: StaticString = #file, line: UInt = #line) -> URL {
        guard let url = URL(string: urlString) else {
            preconditionFailure("Failed to create URL with \(urlString)", file: file, line: line)
        }
        return url
    }
    
    func makeError(_ message: String = "Something went wrong") -> NSError {
        return NSError(domain: "TEST_ERROR", code: -9999, userInfo: nil)
    }
    
    func checkForMemoryLeaks(_ object: AnyObject, file: StaticString = #file, line: UInt = #line) {
        addTeardownBlock { [weak object] in
            XCTAssertNil(object, "Instance or object should have been deallocated. Potential memory leak.", file: file, line: line)
        }
    }
}

class URLSessionHTTPClientTests: XCTestCase {
    
    override func tearDown() {
        URLProtocolStub.removeStub()
    }
    
    func test_fetch_request_fails_on_request_error() {
        let error = makeError()
        let receivedError = resultErrorFor(data: nil, response: nil, error: error) as NSError?
        
        XCTAssertEqual(receivedError?.code, error.code)
        XCTAssertEqual(receivedError?.domain, error.domain)
    }
}

private extension URLSessionHTTPClientTests {
    
    func makeSUT(file: StaticString = #file, line: UInt = #line) -> HTTPClient {
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [URLProtocolStub.self]
        
        let session = URLSession(configuration: configuration)
        let sut = URLSessionHTTPClient(session: session)
        checkForMemoryLeaks(sut, file: file, line: line)
        
        return sut
    }
    
    func resultErrorFor(data: Data?, response: URLResponse?, error: Error, file: StaticString = #file, line: UInt = #line) -> Error? {
        URLProtocolStub.stub(data: data, response: response, error: error)
        
        var receivedError: Error? = nil
        let exp = expectation(description: "Wait for completion")
        let sut = makeSUT(file: file, line: line)
        
        let request = URLRequest(url: makeURL())
        sut.fetch(request, completion: { result in
            switch result {
            case let .failure(error):
                receivedError = error
            default:
                XCTFail("Expected failure but get \(result) instead", file: file, line: line)
            }
            exp.fulfill()
        })
        
        wait(for: [exp], timeout: 1)
        return receivedError
    }
}

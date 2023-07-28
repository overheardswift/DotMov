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
    
    func makeData(isEmpty: Bool = false) -> Data {
        return isEmpty ? Data() : Data("any data".utf8)
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
    
    func test_fetch_request_fails_on_all_nil_response_values() {
        let receivedError = resultErrorFor(data: nil, response: nil, error: nil)
        XCTAssertNotNil(receivedError)
    }
    
    func test_fetch_request_with_predefined_request() {
        let exp = expectation(description: "Wait for completion")
        let sut = makeSUT()
        let requestURL = makeURL()
        
        var request = URLRequest(url: requestURL)
        request.httpMethod = "POST"
        request.setValue("test", forHTTPHeaderField: "query")
        
        URLProtocolStub.observeRequests { request in
            XCTAssertEqual(request.url, requestURL)
            XCTAssertEqual(request.httpMethod, "POST")
            XCTAssertEqual(request.value(forHTTPHeaderField: "query"), "test")
            exp.fulfill()
        }
        
        sut.fetch(request) { _ in }
        
        wait(for: [exp], timeout: 1)
    }
    
    /**
     These cases should *never* happen, however as ``URLSession`` represents these fields as optional
     it is possible in some obscure way that this state _could_ exist.
     
     | Data?    | URLResponse?      | Error?   |
     |----------|-------------------|----------|
     | nil      | nil               | nil      |
     | nil      | URLResponse       | nil      |
     | value    | nil               | nil      |
     | value    | nil               | value    |
     | nil      | URLResponse       | value    |
     | nil      | HTTPURLResponse   | value    |
     | value    | HTTPURLResponse   | value    |
     | value    | URLResponse       | nil      |
    */
    func test_fetch_request_fails_on_invalid_representation_cases() {
      let nonHTTPURLResponse = URLResponse(url: makeURL(), mimeType: nil, expectedContentLength: 0, textEncodingName: nil)
      let httpResponse = HTTPURLResponse(url: makeURL(), statusCode: 200, httpVersion: nil, headerFields: nil)
      let data = makeData()
      let error = makeError()

      XCTAssertNotNil(resultErrorFor(data: nil, response: nil, error: nil))
      XCTAssertNotNil(resultErrorFor(data: nil, response: nonHTTPURLResponse, error: nil))
      XCTAssertNotNil(resultErrorFor(data: data, response: nil, error: nil))
      XCTAssertNotNil(resultErrorFor(data: data, response: nil, error: error))
      XCTAssertNotNil(resultErrorFor(data: nil, response: nonHTTPURLResponse, error: error))
      XCTAssertNotNil(resultErrorFor(data: nil, response: httpResponse, error: error))
      XCTAssertNotNil(resultErrorFor(data: data, response: nonHTTPURLResponse, error: error))
      XCTAssertNotNil(resultErrorFor(data: data, response: httpResponse, error: error))
      XCTAssertNotNil(resultErrorFor(data: data, response: nonHTTPURLResponse, error: nil))
    }
    
    func test_fetch_request_succeeds_on_HTTPURLResponse_with_data() {
        let data = makeData()
        let httpResponse = HTTPURLResponse(url: makeURL(), statusCode: 200, httpVersion: nil, headerFields: nil)
        let receivedValues = resultValuesFor(data: data, response: httpResponse, error: nil)
        
        XCTAssertEqual(receivedValues?.data, data)
        XCTAssertEqual(receivedValues?.response.url, httpResponse?.url)
        XCTAssertEqual(receivedValues?.response.statusCode, httpResponse?.statusCode)
    }
    
    func test_fetch_request_succeeds_with_empty_data() {
        let emptyData = makeData(isEmpty: true)
        let httpResponse = HTTPURLResponse(url: makeURL(), statusCode: 200, httpVersion: nil, headerFields: nil)
        let receivedValues = resultValuesFor(data: nil, response: httpResponse, error: nil)
        
        XCTAssertEqual(receivedValues?.data, emptyData)
        XCTAssertEqual(receivedValues?.response.url, httpResponse?.url)
        XCTAssertEqual(receivedValues?.response.statusCode, httpResponse?.statusCode)
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
    
    func resultErrorFor(data: Data?, response: URLResponse?, error: Error?, file: StaticString = #file, line: UInt = #line) -> Error? {
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
                XCTFail("Expected failure but got \(result) instead", file: file, line: line)
            }
            exp.fulfill()
        })
        
        wait(for: [exp], timeout: 1)
        return receivedError
    }
    
    func resultValuesFor(data: Data?, response: URLResponse?, error: Error?, file: StaticString = #file, line: UInt = #line) -> (data: Data, response: HTTPURLResponse)? {
        URLProtocolStub.stub(data: data, response: response, error: error)
        
        var receivedValues: (Data, HTTPURLResponse)? = nil
        let exp = expectation(description: "Wait for completion")
        let sut = makeSUT(file: file, line: line)
        
        let request = URLRequest(url: makeURL())
        sut.fetch(request, completion: { result in
            switch result {
            case let .success(values):
                receivedValues = values
            default:
                XCTFail("Expected success but got \(result) instead", file: file, line: line)
            }
            exp.fulfill()
        })
        
        wait(for: [exp], timeout: 1)
        return receivedValues
    }
}

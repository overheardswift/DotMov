//
//  HTTPClientSpy.swift
//  DMMediaTests
//
//  Created by Bayu Kurniawan on 30/07/23.
//

import Foundation
import DMNetworking

class HTTPClientSpy: HTTPClient {

  typealias Result = HTTPClient.Result

  private struct Task: HTTPClientTask {
    let callback: () -> Void
    func cancel() { callback() }
  }

  private var messages: [(requests: URLRequest, completion: (Result) -> Void)] = []
  private(set) var cancelledURLs: [URL] = []

  var requestedURLs: [URL] {
    return messages.compactMap { $0.requests.url }
  }

  func fetch(_ request: URLRequest, completion: @escaping (Result) -> Void) -> HTTPClientTask {
    messages.append((request, completion))
    return Task { [weak self] in self?.cancelledURLs.append(request.url!) }
  }

  func completes(with error: Error, at index: Int = 0) {
    messages[index].completion(.failure(error))
  }

  func completes(withStatusCode code: Int, data: Data, at index: Int = 0) {
    let response = HTTPURLResponse(
      url: requestedURLs[index],
      statusCode: code,
      httpVersion: nil,
      headerFields: nil
    )!
    messages[index].completion(.success((data, response)))
  }
}


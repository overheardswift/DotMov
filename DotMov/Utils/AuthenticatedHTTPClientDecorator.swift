//
//  AuthenticatedHTTPClientDecorator.swift
//  DotMov
//
//  Created by Bayu Kurniawan on 31/07/23.
//

import Foundation
import DMNetworking

public class AuthenticatedHTTPClientDecorator: HTTPClient {

	public typealias Result = HTTPClient.Result

	private let decoratee: HTTPClient
	private let config: APIConfig

	public init(decoratee: HTTPClient, config: APIConfig) {
		self.decoratee = decoratee
		self.config = config
	}

	public func fetch(_ request: URLRequest, completion: @escaping (Result) -> Void) -> DMNetworking.HTTPClientTask {
		return decoratee.fetch(enrich(request, with: config), completion: { [weak self] result in
			guard self != nil else { return }
			switch result {
				case let .success(body): completion(.success(body))
				case let .failure(error): completion(.failure(error))
			}
		})
	}
}

private extension AuthenticatedHTTPClientDecorator {
	func enrich(_ request: URLRequest, with config: APIConfig) -> URLRequest {

		guard let requestURL = request.url, var urlComponents = URLComponents(string: requestURL.absoluteString) else { return request }

		var queryItems: [URLQueryItem] = urlComponents.queryItems ?? []
		queryItems.append(.init(name: "api_key", value: config.secret))

		urlComponents.queryItems = queryItems

		guard let authenticatedRequestURL = urlComponents.url else { return request }

		var signedRequest = request
		signedRequest.url = authenticatedRequestURL
		return signedRequest
	}
}

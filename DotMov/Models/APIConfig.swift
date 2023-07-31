//
//  ApiConfig.swift
//  DotMov
//
//  Created by Bayu Kurniawan on 31/07/23.
//

import Foundation

public struct APIConfig: Decodable {
	public let secret: String
	
	public init(secret: String) {
		self.secret = secret
	}
}

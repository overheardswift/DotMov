//
//  CastLoader.swift
//  DMMovieDetail
//
//  Created by Bayu Kurniawan on 31/07/23.
//

import Foundation

public protocol CastLoader {
	typealias Result = Swift.Result<Cast, Error>
	func load(id: Int, completion: @escaping (Result) -> Void)
}

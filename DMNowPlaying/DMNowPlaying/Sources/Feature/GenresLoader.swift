//
//  GenresLoader.swift
//  DMNowPlaying
//
//  Created by Bayu Kurniawan on 31/07/23.
//

import Foundation

public protocol GenresLoader {
		typealias Result = Swift.Result<[Genre], Error>
		func load(completion: @escaping (Result) -> Void)
}

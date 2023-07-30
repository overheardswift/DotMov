//
//  MovieLoader.swift
//  DMMovieDetail
//
//  Created by Bayu Kurniawan on 30/07/23.
//

import Foundation

public protocol MovieLoader {
  typealias Result = Swift.Result<Movie, Error>
  func load(id: Int, completion: @escaping (Result) -> Void)
}

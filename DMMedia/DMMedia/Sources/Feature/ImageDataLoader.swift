//
//  ImageDataLoader.swift
//  DMMedia
//
//  Created by Bayu Kurniawan on 30/07/23.
//

import Foundation

public protocol ImageDataLoaderTask {
  func cancel()
}

public protocol ImageDataLoader {
  typealias Result = Swift.Result<Data, Error>

  func load(from imageURL: URL, completion: @escaping (Result) -> Void) -> ImageDataLoaderTask
}


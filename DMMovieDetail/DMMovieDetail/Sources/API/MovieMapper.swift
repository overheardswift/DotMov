//
//  MovieMapper.swift
//  DMMovieDetail
//
//  Created by Bayu Kurniawan on 30/07/23.
//

import Foundation

struct RemoteMovie: Decodable {

  struct RemoteMovieGenre: Decodable {
    let name: String
  }

  let id: Int
  let original_title: String
  let runtime: CGFloat
  let genres: [RemoteMovieGenre]
  let overview: String
  let backdrop_path: String
}

final class MovieMapper {

  private static var OK_200: Int { return 200 }

  static func map(_ data: Data, from response: HTTPURLResponse) throws -> RemoteMovie {
    guard response.statusCode == OK_200, let page = try? JSONDecoder().decode(RemoteMovie.self, from: data) else {
      throw RemoteMovieLoader.Error.invalidResponse
    }

    return page
  }
}

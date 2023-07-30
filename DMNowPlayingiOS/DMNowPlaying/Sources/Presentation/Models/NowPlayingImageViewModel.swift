//
//  NowPlayingImageViewModel.swift
//  DMNowPlaying
//
//  Created by Bayu Kurniawan on 30/07/23.
//

import Foundation

public struct NowPlayingImageViewModel<Image> {

  public let image: Image?
  public let isLoading: Bool

  public init(image: Image?, isLoading: Bool) {
    self.image = image
    self.isLoading = isLoading
  }
}

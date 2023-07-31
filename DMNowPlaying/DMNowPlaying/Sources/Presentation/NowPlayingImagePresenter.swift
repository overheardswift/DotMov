//
//  NowPlayingImagePresenter.swift
//  DMNowPlaying
//
//  Created by Bayu Kurniawan on 30/07/23.
//

import Foundation

public protocol NowPlayingImageView {
  associatedtype Image
  func display(_ model: NowPlayingImageViewModel<Image>)
}

public final class NowPlayingImagePresenter<View: NowPlayingImageView, Image> where View.Image == Image {

  private let view: View
  private let imageTransformer: (Data) -> Image?

  public init(view: View, imageTransformer: @escaping (Data) -> Image?) {
    self.view = view
    self.imageTransformer = imageTransformer
  }

  public func didStartLoadingImageData() {
    view.display(NowPlayingImageViewModel<Image>(image: nil, isLoading: true))
  }

  public func didFinishLoadingImageData(with data: Data) {
    let image = imageTransformer(data)
    view.display(NowPlayingImageViewModel<Image>(image: image, isLoading: false))
  }
}

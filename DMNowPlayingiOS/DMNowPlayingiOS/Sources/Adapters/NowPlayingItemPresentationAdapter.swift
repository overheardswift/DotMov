//
//  NowPlayingItemPresentationAdapter.swift
//  DMNowPlayingiOS
//
//  Created by Bayu Kurniawan on 30/07/23.
//

import Foundation
import DMNowPlaying
import DMMedia

final class NowPlayingImageDataLoaderPresentationAdapter<View: NowPlayingImageView, Image>: NowPlayingCellControllerDelegate where View.Image == Image {
    
    var presenter: NowPlayingImagePresenter<View, Image>?
    
    private let baseURL: URL
    private let model: NowPlayingItem
    private let imageLoader: ImageDataLoader
    
    private var task: ImageDataLoaderTask?
    
    init(baseURL: URL, model: NowPlayingItem, imageLoader: ImageDataLoader) {
        self.baseURL = baseURL
        self.model = model
        self.imageLoader = imageLoader
    }
    
    func didRequestLoadImage() {
        presenter?.didStartLoadingImageData(for: model)
        task = imageLoader.load(from: makeImageURL(withPath: model.imagePath), completion: { [weak self, model] result in
            guard let self = self else { return }
            switch result {
            case let .success(imageData): self.presenter?.didFinishLoadingImageData(with: imageData, for: model)
            default: break
            }
        })
    }
    
    func didRequestCancelLoadImage() {
        task?.cancel()
        task = nil
    }
}

private extension NowPlayingImageDataLoaderPresentationAdapter {
    func makeImageURL(withPath path: String) -> URL {
        return baseURL.appendingPathComponent(path)
    }
}

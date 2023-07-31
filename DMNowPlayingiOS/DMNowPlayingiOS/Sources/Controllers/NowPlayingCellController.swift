//
//  NowPlayingCellController.swift
//  DMNowPlayingiOS
//
//  Created by Bayu Kurniawan on 30/07/23.
//

import UIKit
import DMNowPlaying

protocol NowPlayingCellControllerDelegate {
	func didRequestCancelLoadImage()
	func didRequestLoadImage()
}

final class NowPlayingCellController: Hashable {
	
	private let model: NowPlayingItemViewModel
	private let delegate: NowPlayingCellControllerDelegate
	
	var didSelect: (() -> Void)?
	
	init(model: NowPlayingItemViewModel, delegate: NowPlayingCellControllerDelegate) {
		self.model = model
		self.delegate = delegate
	}
	
	static func == (lhs: NowPlayingCellController, rhs: NowPlayingCellController) -> Bool {
		return lhs.model.id == rhs.model.id
	}
	
	func hash(into hasher: inout Hasher) {
		hasher.combine(model.id)
	}
	
	private var cell: NowPlayingCell?
	
	func view(in collectionView: UICollectionView, forItemAt indexPath: IndexPath) -> UICollectionViewCell {
		cell = collectionView.dequeueReusableCell(withReuseIdentifier: NowPlayingCell.id, for: indexPath) as? NowPlayingCell
		cell?.titleLabel.text = model.title
		cell?.yearLabel.text = model.releaseDate
		cell?.categoryLabel.text = model.genre
		
		return cell!
	}
	
	func cancelLoad() {
		delegate.didRequestCancelLoadImage()
		releaseCellForReuse()
	}
	
	func prefetch() {
		delegate.didRequestLoadImage()
	}
	
	func select() {
		didSelect?()
	}
}

private extension NowPlayingCellController {
	func releaseCellForReuse() {
		cell = nil
	}
}

extension NowPlayingCellController: NowPlayingImageView {
	func display(_ model: NowPlayingImageViewModel<UIImage>) {
		cell?.contentView.isShimmering = model.isLoading
		cell?.thumbnailImageView.image = model.image
	}
}

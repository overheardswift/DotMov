//
//  CastCellController.swift
//  DMMovieDetailiOS
//
//  Created by Bayu Kurniawan on 31/07/23.
//

import UIKit
import DMMovieDetail

protocol CastCellControllerDelegate {
	func didRequestCancelLoadImage()
	func didRequestLoadImage()
}

final class CastCellController {
	
	private let model: MovieDetailsCastViewModel
	private let delegate: CastCellControllerDelegate
	
	private var cell: CastCell?
	
	init(model: MovieDetailsCastViewModel, delegate: CastCellControllerDelegate) {
		self.model = model
		self.delegate = delegate
	}
	
	func view(in collectionView: UICollectionView, forItemAt indexPath: IndexPath) -> UICollectionViewCell {
		cell = collectionView.dequeueReusableCell(withReuseIdentifier: CastCell.id, for: indexPath) as? CastCell
		cell?.nameLabel.text = model.name
		return cell!
	}
	
	func cancelLoad() {
		delegate.didRequestCancelLoadImage()
		releaseCellForReuse()
	}
	
	func prefetch() {
		delegate.didRequestLoadImage()
	}
}

private extension CastCellController {
	func releaseCellForReuse() {
		cell = nil
	}
}

extension CastCellController: MovieDetailsCastImageView {
	func display(_ model: MovieDetailsCastImageViewModel<UIImage>) {
		cell?.profileImageView.image = model.image
	}
}

//
//  CastCellController.swift
//  DMMovieDetailiOS
//
//  Created by Bayu Kurniawan on 31/07/23.
//

import UIKit
import DMMovieDetail

final class CastCellController {
	
	private let model: MovieDetailsCastViewModel
	private var cell: CastCell?
	
	init(model: MovieDetailsCastViewModel) {
		self.model = model
	}
	
	func view(in collectionView: UICollectionView, forItemAt indexPath: IndexPath) -> UICollectionViewCell {
		cell = collectionView.dequeueReusableCell(withReuseIdentifier: CastCell.id, for: indexPath) as? CastCell
		cell?.nameLabel.text = model.name
		return cell!
	}
}

//
//  NowPlayingCellController.swift
//  DMNowPlayingiOS
//
//  Created by Bayu Kurniawan on 30/07/23.
//

import UIKit
import DMNowPlaying

final class NowPlayingCellController: Hashable {
    
    private let model: NowPlayingItem
    
    init(model: NowPlayingItem) {
        self.model = model
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
        return cell!
    }
}

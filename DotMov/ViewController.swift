//
//  NowPlayingViewController.swift
//  DotMov
//
//  Created by Bayu Kurniawan on 22/07/23.
//

import UIKit

struct Dummy: Hashable {
    let id: Int
}

final class NowPlayingViewController: UICollectionViewController {
    
    private lazy var dataSource: UICollectionViewDiffableDataSource<Int, Dummy> = {
        return .init(collectionView: collectionView) { collectionView, indexPath, itemIdentifier in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NowPlayingCell.id, for: indexPath)
            return cell
        }
    }()
    
    convenience init() {
        self.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
}

private extension NowPlayingViewController {
    func configureUI() {
        configureCollectionView()
    }
    
    func configureCollectionView() {
        collectionView.collectionViewLayout = createLayout()
        collectionView.dataSource = dataSource
        collectionView.register(NowPlayingCell.self, forCellWithReuseIdentifier: NowPlayingCell.id)
        
        var snapshot = NSDiffableDataSourceSnapshot<Int, Dummy>()
        snapshot.appendSections([0])
        snapshot.appendItems(
            (0...4).map { id in
                Dummy(id: id)
            },
            toSection: 0
        )
        dataSource.apply(snapshot)
    }
    
    func createLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { section, _ in
            
            let item = NSCollectionLayoutItem(
                layoutSize: .init(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .fractionalHeight(1)
                )
            )
            
            let group = NSCollectionLayoutGroup.vertical(
                layoutSize: .init(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .absolute(100)
                ),
                subitems: [item]
            )
            
            let section = NSCollectionLayoutSection(group: group)
            section.interGroupSpacing = 20
            section.contentInsets.leading = 16
            section.contentInsets.trailing = 16
            
            return section
        }
    }
}

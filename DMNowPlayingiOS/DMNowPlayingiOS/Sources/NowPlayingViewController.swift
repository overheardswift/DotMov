//
//  NowPlayingViewController.swift
//  DMNowPlayingiOS
//
//  Created by Bayu Kurniawan on 27/07/23.
//

import UIKit

public final class NowPlayingViewController: UICollectionViewController {
    
    private lazy var dataSource: UICollectionViewDiffableDataSource<Int, String> = {
        return .init(collectionView: collectionView) { collectionView, indexPath, itemIdentifier in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NowPlayingCell.id, for: indexPath)
            return cell
        }
    }()
    
    public convenience init() {
        self.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    public override func viewDidLoad() {
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
        
        var snapshot = NSDiffableDataSourceSnapshot<Int, String>()
        snapshot.appendSections([0])
        snapshot.appendItems(
            (0...4).map { id in
                String(id)
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

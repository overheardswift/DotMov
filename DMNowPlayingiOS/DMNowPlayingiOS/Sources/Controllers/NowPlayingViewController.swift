//
//  NowPlayingViewController.swift
//  DMNowPlayingiOS
//
//  Created by Bayu Kurniawan on 27/07/23.
//

import UIKit

public final class NowPlayingViewController: UICollectionViewController {
	
	private lazy var dataSource: UICollectionViewDiffableDataSource<Int, NowPlayingCellController> = {
		return .init(collectionView: collectionView) { collectionView, indexPath, controller in
			return controller.view(in: collectionView, forItemAt: indexPath)
		}
	}()
	
	private let loadingIndicator = UIActivityIndicatorView(style: .medium)
	
	private let searchBar = UISearchBar()
	
	var refreshController: NowPlayingRefreshController?
	var pagingController: NowPlayingPagingController?
	var searchController: SearchController?
	
	convenience init(
		refreshController: NowPlayingRefreshController,
		pagingController: NowPlayingPagingController,
		searchController: SearchController
	) {
		self.init(collectionViewLayout: UICollectionViewFlowLayout())
		self.refreshController = refreshController
		self.pagingController = pagingController
		self.searchController = searchController
	}
	
	public override func viewDidLoad() {
		super.viewDidLoad()
		configureUI()
		refreshController?.refresh()
	}
	
	func set(_ newItems: [NowPlayingCellController]) {
		var snapshot = NSDiffableDataSourceSnapshot<Int, NowPlayingCellController>()
		snapshot.appendSections([0])
		snapshot.appendItems(newItems, toSection: 0)
		dataSource.applySnapshotUsingReloadData(snapshot)
	}
	
	func append(_ newItems: [NowPlayingCellController]) {
		var snapshot = dataSource.snapshot()
		snapshot.appendItems(newItems, toSection: 0)
		dataSource.apply(snapshot, animatingDifferences: false)
	}
	
	public override func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
		guard collectionView.refreshControl?.isRefreshing == true else { return }
		refreshController?.refresh()
	}
	
	public override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
		prefetchCellController(forItemAt: indexPath)
	}
	
	public override func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
		removeCellController(forItemAt: indexPath)
	}
	
	public override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		cellController(forItemAt: indexPath)?.select()
	}
	
	public override func scrollViewDidScroll(_ scrollView: UIScrollView) {
		guard scrollView.isDragging else { return }
		
		let offsetY = scrollView.contentOffset.y
		let contentHeight = scrollView.contentSize.height
		if (offsetY > contentHeight - scrollView.frame.height) {
			pagingController?.load()
		}
	}
}

extension NowPlayingViewController: UICollectionViewDataSourcePrefetching {
	public func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
		indexPaths.forEach(prefetchCellController)
	}
	
	public func collectionView(_ collectionView: UICollectionView, cancelPrefetchingForItemsAt indexPaths: [IndexPath]) {
		indexPaths.forEach(removeCellController)
	}
}

extension NowPlayingViewController: UISearchBarDelegate {
	public func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
		guard let text = searchBar.text, !text.isEmpty else {
			return
		}
		collectionView.refreshControl = nil
		searchController?.search(text)
		searchBar.resignFirstResponder()
	}
	
	public func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
		guard searchText.isEmpty else { return }
		collectionView.refreshControl = refreshController?.view
		refreshController?.refresh()
	}
}

private extension NowPlayingViewController {
	func configureUI() {
		configureCollectionView()
		configureNavigation()
	}
	
	func configureCollectionView() {
		collectionView.collectionViewLayout = createLayout()
		collectionView.dataSource = dataSource
		collectionView.prefetchDataSource = self
		collectionView.delegate = self
		collectionView.register(NowPlayingCell.self, forCellWithReuseIdentifier: NowPlayingCell.id)
		collectionView.delegate = self
		collectionView.contentInset.top = 30
		collectionView.contentInset.bottom = 20
		collectionView.refreshControl = refreshController?.view
		collectionView.keyboardDismissMode = .onDrag
	}
	
	func configureNavigation() {
		searchBar.placeholder = "Type and enter"
		searchBar.delegate = self
		navigationItem.titleView = searchBar
	}
	
	func cellController(forItemAt indexPath: IndexPath) -> NowPlayingCellController? {
		let controller = dataSource.itemIdentifier(for: indexPath)
		return controller
	}
	
	func removeCellController(forItemAt indexPath: IndexPath) {
		cellController(forItemAt: indexPath)?.cancelLoad()
	}
	
	func prefetchCellController(forItemAt indexPath: IndexPath) {
		cellController(forItemAt: indexPath)?.prefetch()
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

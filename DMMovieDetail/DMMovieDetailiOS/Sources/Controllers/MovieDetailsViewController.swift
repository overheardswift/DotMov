//
//  MovieDetailsViewController.swift
//  DMMovieDetailiOS
//
//  Created by Bayu Kurniawan on 30/07/23.
//

import UIKit
import DMCommoniOS
import DMMovieDetail

protocol MovieDetailsViewControllerDelegate {
	func didRequestLoad()
}

public final class MovieDetailsViewController: UIViewController {
    
	private let scrollViewContainer = ScrollViewContainer()
	private let headerView = MovieDetailHeaderView()
	private let overviewLabel = PaddingLabel()
	private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
	private let loadingIndicator = UIActivityIndicatorView(style: .large)
	
	private var isLoading: Bool = false {
		didSet {
			UIView.transition(with: scrollViewContainer, duration: 0.33, options: .transitionCrossDissolve) {
				self.isLoading ? self.loadingIndicator.startAnimating() : self.loadingIndicator.stopAnimating()
				self.scrollViewContainer.isHidden = self.isLoading
			}
		}
	}
	
	private var delegate: MovieDetailsViewControllerDelegate?
	
	convenience init(delegate: MovieDetailsViewControllerDelegate) {
		self.init(nibName: nil, bundle: nil)
		self.delegate = delegate
	}
	
	public override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = .white
		configureUI()
		
		delegate?.didRequestLoad()
	}
}

extension MovieDetailsViewController: MovieDetailsView {
	public func display(_ model: MovieDetailsViewModel<UIImage>) {
		isLoading = model.isLoading
		headerView.titleLabel.text = model.title
		headerView.runtimeLabel.text = model.runtime
		headerView.genreLabel.text = model.genre
		headerView.backdropImageView.image = model.image
		overviewLabel.text = model.overview
	}
}

extension MovieDetailsViewController: UICollectionViewDataSource {
	public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return 5
	}
	
	public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CastCell.id, for: indexPath)
		return cell
	}
}

extension MovieDetailsViewController: UICollectionViewDelegateFlowLayout {
	public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		return CGSize(width: 80, height: 124)
	}
	
	public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
		return 20
	}
	
	public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
		return .init(top: 0, left: 16, bottom: 0, right: 16)
	}
}

private extension MovieDetailsViewController {
	func configureUI() {
		configureScrollViewContainer()
		configureHeaderView()
		configureOverviewLabel()
		configureLoadingIndicator()
		configureCollectionView()
	}
	
	func configureScrollViewContainer() {
		scrollViewContainer.translatesAutoresizingMaskIntoConstraints = false
		scrollViewContainer.contentInsetAdjustmentBehavior = .never
		scrollViewContainer.spacingBetween = 24
		
		view.addSubview(scrollViewContainer)
		NSLayoutConstraint.activate([
			scrollViewContainer.topAnchor.constraint(equalTo: view.topAnchor),
			scrollViewContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
			scrollViewContainer.bottomAnchor.constraint(equalTo: view.bottomAnchor),
			scrollViewContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor)
		])
	}
	
	func configureHeaderView() {
		headerView.translatesAutoresizingMaskIntoConstraints = false
		headerView.backgroundColor = .systemGray4
		
		scrollViewContainer.addArrangedSubViews(headerView)
		headerView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.45).isActive = true
	}
	
	func configureOverviewLabel() {
		overviewLabel.translatesAutoresizingMaskIntoConstraints = false
		overviewLabel.numberOfLines = 0
		overviewLabel.paddingLeft = 16
		overviewLabel.paddingRight = 16
		overviewLabel.font = .poppins(.regular, size: 12)
		overviewLabel.textColor = .boulder
		
		scrollViewContainer.addArrangedSubViews(overviewLabel)
	}
	
	func configureCollectionView() {
		let layout = UICollectionViewFlowLayout()
		layout.scrollDirection = .horizontal
		
		collectionView.showsHorizontalScrollIndicator = false
		collectionView.collectionViewLayout = layout
		collectionView.translatesAutoresizingMaskIntoConstraints = false
		collectionView.dataSource = self
		collectionView.delegate = self
		collectionView.register(CastCell.self, forCellWithReuseIdentifier: CastCell.id)
		
		scrollViewContainer.addArrangedSubViews(collectionView)
		collectionView.heightAnchor.constraint(equalToConstant: 150).isActive = true
	}
	
	func configureLoadingIndicator() {
		loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
		loadingIndicator.color = .black
		
		view.addSubview(loadingIndicator)
		NSLayoutConstraint.activate([
			loadingIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			loadingIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
		])
	}
}

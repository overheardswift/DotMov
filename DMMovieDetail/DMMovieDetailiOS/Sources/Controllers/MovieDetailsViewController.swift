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

private extension MovieDetailsViewController {
	func configureUI() {
		configureScrollViewContainer()
		configureHeaderView()
		configureOverviewLabel()
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
}

extension MovieDetailsViewController: MovieDetailsView {
	public func display(_ model: MovieDetailsViewModel<UIImage>) {
		
		headerView.titleLabel.text = model.title
		headerView.runtimeLabel.text = model.runtime
		headerView.genreLabel.text = model.genre
		headerView.backdropImageView.image = model.image
		overviewLabel.text = model.overview
	}
}

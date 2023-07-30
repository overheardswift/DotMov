//
//  MovieDetailsViewController.swift
//  DMMovieDetailiOS
//
//  Created by Bayu Kurniawan on 30/07/23.
//

import UIKit

public final class MovieDetailsViewController: UIViewController {
    
	private let scrollViewContainer = ScrollViewContainer()
	private let headerView = UIView()
	
	public override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = .white
		
		configureUI()
	}
}

private extension MovieDetailsViewController {
	func configureUI() {
		configureScrollViewContainer()
		configureHeaderView()
	}
	
	func configureScrollViewContainer() {
		scrollViewContainer.translatesAutoresizingMaskIntoConstraints = false
		scrollViewContainer.contentInsetAdjustmentBehavior = .never
		
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
}

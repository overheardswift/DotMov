//
//  MovieDetailsViewController.swift
//  DMMovieDetailiOS
//
//  Created by Bayu Kurniawan on 30/07/23.
//

import UIKit
import DMCommoniOS

public final class MovieDetailsViewController: UIViewController {
    
	private let scrollViewContainer = ScrollViewContainer()
	private let headerView = UIView()
	private let overviewLabel = PaddingLabel()
	
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
		overviewLabel.text = """
		Lorem ipsum dolor sit amet, consectetur adipiscing elit ut aliquam, purus sit amet luctus venenatis, lectus magna fringilla urna, porttitor rhoncus dolor purus non enim praesent elementum facilisis leo, vel fringilla est ullamcorper eget nulla facilisi etiam dignissim diam quis enim lobortis scelerisque fermentum dui faucibus in ornare quam viverra orci sagittis eu volutpat odio facilisis mauris sit amet massa vitae tortor condimentum lacinia quis vel eros donec ac odio tempor orci dapibus ultrices in iaculis nunc sed augue lacus, viverra vitae congue eu, consequat ac felis donec et odio pellentesque diam volutpat commodo sed egestas egestas fringilla phasellus faucibus
		"""
		overviewLabel.numberOfLines = 0
		overviewLabel.paddingLeft = 16
		overviewLabel.paddingRight = 16
		overviewLabel.font = .poppins(.regular, size: 12)
		overviewLabel.textColor = .boulder
		
		scrollViewContainer.addArrangedSubViews(overviewLabel)
	}
}

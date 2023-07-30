//
//  ScrollViewContainer.swift
//  DMMovieDetailiOS
//
//  Created by Bayu Kurniawan on 30/07/23.
//

import UIKit

final class ScrollViewContainer: UIScrollView {
	
	private let refresher = UIRefreshControl()
	
	var refreshCallback: (() -> Void)?
	
	var spacingBetween: CGFloat = 0 {
		didSet {
			stackView.spacing = spacingBetween
		}
	}
	
	private let stackView: UIStackView = {
		let view = UIStackView()
		view.axis = .vertical
		view.translatesAutoresizingMaskIntoConstraints = false
		return view
	}()
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		addSubview(stackView)
		NSLayoutConstraint.activate([
			stackView.topAnchor.constraint(equalTo: topAnchor),
			stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
			stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
			stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
			stackView.centerXAnchor.constraint(equalTo: centerXAnchor)
		])
	}
	
	required init?(coder: NSCoder) {
		super.init(coder: coder)
	}
	
	@discardableResult
	func addArrangedSubViews(_ view: UIView) -> Self {
		self.stackView.addArrangedSubview(view)
		return self
	}
}

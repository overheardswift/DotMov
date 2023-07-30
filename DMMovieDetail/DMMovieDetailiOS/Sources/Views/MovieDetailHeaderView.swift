//
//  MovieDetailHeaderView.swift
//  DMMovieDetailiOS
//
//  Created by Bayu Kurniawan on 31/07/23.
//

import UIKit
import DMCommoniOS

final class MovieDetailHeaderView: UIView {
	
	private(set) var backdropImageView = UIImageView()
	private(set) var titleLabel = UILabel()
	private(set) var runtimeLabel = UILabel()
	private(set) var genreLabel = UILabel()
	
	private let stackView = UIStackView()
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		configureUI()
	}
	
	@available(*, unavailable)
	required init?(coder: NSCoder) {
		return nil
	}
	
	override func layoutSubviews() {
		super.layoutSubviews()
		let gradient = CAGradientLayer()
		gradient.frame = bounds
		gradient.colors = [
			UIColor.clear,
			UIColor.black
		].map{ $0.cgColor }
		backdropImageView.layer.addSublayer(gradient)
	}
}

private extension MovieDetailHeaderView {
	func configureUI() {
		configureBackdropImageView()
		configureStackView()
		configureTitleLabel()
		configureRuntimeLabel()
		configureGenreLabel()
	}
	
	func configureBackdropImageView() {
		backdropImageView.translatesAutoresizingMaskIntoConstraints = false
		backdropImageView.contentMode = .scaleAspectFill
		backdropImageView.clipsToBounds = true
		
		addSubview(backdropImageView)
		NSLayoutConstraint.activate([
			backdropImageView.topAnchor.constraint(equalTo: topAnchor),
			backdropImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
			backdropImageView.bottomAnchor.constraint(equalTo: bottomAnchor),
			backdropImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
		])
	}
	
	func configureStackView() {
		stackView.translatesAutoresizingMaskIntoConstraints = false
		stackView.axis = .vertical
		stackView.spacing = 4
		stackView.bringSubviewToFront(backdropImageView)
		
		addSubview(stackView)
		NSLayoutConstraint.activate([
			stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
			stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16),
			stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16)
		])
	}
	
	func configureTitleLabel() {
		titleLabel.font = .poppins(.semibold, size: 20)
		titleLabel.textColor = .white
		
		stackView.addArrangedSubview(titleLabel)
	}
	
	func configureRuntimeLabel() {
		runtimeLabel.font = .poppins(.regular, size: 12)
		runtimeLabel.textColor = .boulder
		
		stackView.addArrangedSubview(runtimeLabel)
	}
	
	func configureGenreLabel() {
		genreLabel.font = .poppins(.regular, size: 12)
		genreLabel.textColor = .boulder
		
		stackView.addArrangedSubview(genreLabel)
	}
}

//
//  CastCell.swift
//  DMMovieDetailiOS
//
//  Created by Bayu Kurniawan on 31/07/23.
//

import UIKit
import DMCommoniOS

final class CastCell: UICollectionViewCell {
	
	static var id: String {
		return String(describing: CastCell.self)
	}
	
	private(set) var profileImageView = UIImageView()
	private(set) var nameLabel = UILabel()
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		configureUI()
	}
	
	@available(*, unavailable)
	required init?(coder: NSCoder) {
		return nil
	}
}

private extension CastCell {
	func configureUI() {
		configureProfileImageView()
		configureNameLabel()
	}
	
	func configureProfileImageView() {
		profileImageView.translatesAutoresizingMaskIntoConstraints = false
		profileImageView.backgroundColor = .cloud
		profileImageView.layer.cornerRadius = contentView.bounds.width / 2
		
		contentView.addSubview(profileImageView)
		NSLayoutConstraint.activate([
			profileImageView.widthAnchor.constraint(equalTo: contentView.widthAnchor),
			profileImageView.heightAnchor.constraint(equalTo: profileImageView.widthAnchor)
		])
	}
	
	func configureNameLabel() {
		nameLabel.translatesAutoresizingMaskIntoConstraints = false
		nameLabel.textColor = .boulder
		nameLabel.font = .poppins(.regular, size: 12)
		nameLabel.textAlignment = .center
		nameLabel.numberOfLines = 2
		nameLabel.text = "John Doe"
		
		contentView.addSubview(nameLabel)
		NSLayoutConstraint.activate([
			NSLayoutConstraint(
				item: nameLabel,
				attribute: .top,
				relatedBy: .equal,
				toItem: profileImageView,
				attribute: .bottom,
				multiplier: 1,
				constant: 12
			),
			nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 4),
			nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -4),
		])
	}
}

//
//  NowPlayingCell.swift
//  DMNowPlayingiOS
//
//  Created by Bayu Kurniawan on 27/07/23.
//

import UIKit

final class NowPlayingCell: UICollectionViewCell {
    
    static var id: String {
        return String(describing: NowPlayingCell.self)
    }
    
    private let thumbnailImageView = UIImageView()
    private let rightContentStackView = UIStackView()
    private let titleLabel = UILabel()
    private let yearLabel = UILabel()
    private let categoryLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("Unimplemented")
    }
}

private extension NowPlayingCell {
    func configureUI() {
        configureThumbnailImageView()
        configureRightContentStackView()
        configureCategoryLabel()
    }
    
    func configureThumbnailImageView() {
        thumbnailImageView.translatesAutoresizingMaskIntoConstraints = false
        thumbnailImageView.backgroundColor = .systemGray4
        thumbnailImageView.layer.cornerRadius = 4
        
        contentView.addSubview(thumbnailImageView)
        NSLayoutConstraint.activate([
            thumbnailImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            thumbnailImageView.heightAnchor.constraint(equalTo: contentView.heightAnchor),
            thumbnailImageView.widthAnchor.constraint(equalTo: thumbnailImageView.heightAnchor)
        ])
    }

    func configureRightContentStackView() {
        rightContentStackView.translatesAutoresizingMaskIntoConstraints = false
        rightContentStackView.axis = .vertical
        rightContentStackView.alignment = .top
        rightContentStackView.spacing = 4
        
        contentView.addSubview(rightContentStackView)
    
        NSLayoutConstraint.activate([
            NSLayoutConstraint(
                item: rightContentStackView,
                attribute: .leading,
                relatedBy: .equal,
                toItem: thumbnailImageView,
                attribute: .trailing,
                multiplier: 1,
                constant: 16
            ),
            rightContentStackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            rightContentStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
        
        configureTitleLabel()
        configureYearLabel()
    }
    
    func configureTitleLabel() {
        titleLabel.font = .systemFont(ofSize: 16)
        titleLabel.textColor = .black
        titleLabel.text = "Movie Title"
        
        rightContentStackView.addArrangedSubview(titleLabel)
    }
    
    func configureYearLabel() {
        yearLabel.font = .systemFont(ofSize: 16)
        yearLabel.textColor = .darkGray
        yearLabel.text = "2023"
        
        rightContentStackView.addArrangedSubview(yearLabel)
    }
    
    func configureCategoryLabel() {
        categoryLabel.translatesAutoresizingMaskIntoConstraints = false
        categoryLabel.font = .systemFont(ofSize: 12)
        categoryLabel.textColor = .lightGray
        categoryLabel.text = "Drama, Asia, Comedy, Series"
        
        contentView.addSubview(categoryLabel)
        NSLayoutConstraint.activate([
            NSLayoutConstraint(
                item: categoryLabel,
                attribute: .leading,
                relatedBy: .equal,
                toItem: thumbnailImageView,
                attribute: .trailing,
                multiplier: 1,
                constant: 16
            ),
            categoryLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            categoryLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }
}

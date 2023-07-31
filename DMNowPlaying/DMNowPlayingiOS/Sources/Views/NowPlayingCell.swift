//
//  NowPlayingCell.swift
//  DMNowPlayingiOS
//
//  Created by Bayu Kurniawan on 27/07/23.
//

import UIKit
import DMCommoniOS

public final class NowPlayingCell: UICollectionViewCell {
    
    static var id: String {
        return String(describing: NowPlayingCell.self)
    }
    
    private(set) public var thumbnailImageView = UIImageView()
    private let rightContentStackView = UIStackView()
    private(set) public var titleLabel = UILabel()
    private(set) public var yearLabel = UILabel()
    private(set) public var categoryLabel = UILabel()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    @available(*, unavailable)
    public required init?(coder: NSCoder) {
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
        thumbnailImageView.backgroundColor = .cloud
        thumbnailImageView.layer.cornerRadius = 4
        thumbnailImageView.clipsToBounds = true
        thumbnailImageView.contentMode = .scaleToFill
        
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
        titleLabel.font = .poppins(.regular, size: 16)
        titleLabel.textColor = .black
        titleLabel.numberOfLines = 2
        
        rightContentStackView.addArrangedSubview(titleLabel)
    }
    
    func configureYearLabel() {
        yearLabel.font = .poppins(.regular, size: 16)
        yearLabel.textColor = .boulder
        
        rightContentStackView.addArrangedSubview(yearLabel)
    }
    
    func configureCategoryLabel() {
        categoryLabel.translatesAutoresizingMaskIntoConstraints = false
        categoryLabel.font = .poppins(.regular, size: 12)
        categoryLabel.textColor = .boulder
        categoryLabel.text = "LOREM, IPSUM, DOLOR"
        
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

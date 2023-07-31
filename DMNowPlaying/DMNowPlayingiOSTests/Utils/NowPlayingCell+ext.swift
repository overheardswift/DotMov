//
//  NowPlayingCell+ext.swift
//  DMNowPlayingiOSTests
//
//  Created by Bayu Kurniawan on 30/07/23.
//

import UIKit
import DMNowPlayingiOS

extension NowPlayingCell {
    var renderedImage: Data? {
        return thumbnailImageView.image?.pngData()
    }
}

extension UIView {
    var loadingIndicatorIsVisible: Bool {
      return isShimmering
    }
}

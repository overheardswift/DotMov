//
//  UIRefreshControl+ext.swift
//  DMNowPlayingiOSTests
//
//  Created by Bayu Kurniawan on 30/07/23.
//

import UIKit

extension UIRefreshControl {
  func simulatePullToRefresh() {
    simulate(event: .valueChanged)
  }
}

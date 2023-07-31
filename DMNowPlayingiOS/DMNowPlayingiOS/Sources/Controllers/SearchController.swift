//
//  SearchController.swift
//  DMNowPlayingiOS
//
//  Created by Bayu Kurniawan on 31/07/23.
//

import UIKit

protocol SearchControllerDelegate {
	func didClickSearch(with keyword: String)
}

final class SearchController {
	
	private let delegate: SearchControllerDelegate
	
	init(delegate: SearchControllerDelegate) {
		self.delegate = delegate
	}
	
	func search(_ text: String) {
		delegate.didClickSearch(with: text)
	}
}

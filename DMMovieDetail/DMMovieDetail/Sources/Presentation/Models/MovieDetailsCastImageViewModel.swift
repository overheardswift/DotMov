//
//  MovieDetailsCastImageViewModel.swift
//  DMMovieDetail
//
//  Created by Bayu Kurniawan on 31/07/23.
//

import Foundation

public struct MovieDetailsCastImageViewModel<Image> {

	public let image: Image?
	
	public init(image: Image?, isLoading: Bool) {
		self.image = image
	}
}

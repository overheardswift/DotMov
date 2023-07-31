//
//  MovieDetailsCastViewModel.swift
//  DMMovieDetail
//
//  Created by Bayu Kurniawan on 31/07/23.
//

import Foundation

public struct MovieDetailsCastViewModel {
	
	public let name: String
	public let profilePath: String
	
	public init(name: String, profilePath: String) {
		self.name = name
		self.profilePath = profilePath
	}
}

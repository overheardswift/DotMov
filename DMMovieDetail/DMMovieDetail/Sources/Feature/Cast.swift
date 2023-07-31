//
//  Cast.swift
//  DMMovieDetail
//
//  Created by Bayu Kurniawan on 31/07/23.
//

import Foundation

public struct Cast: Equatable {
	public let id: Int
	public let name: String
	public let profilePath: String
	
	public init(id: Int, name: String, profilePath: String) {
		self.id = id
		self.name = name
		self.profilePath = profilePath
	}
}

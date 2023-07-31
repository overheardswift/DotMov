//
//  WeakRefVirtualProxy.swift
//  DMCommon
//
//  Created by Bayu Kurniawan on 31/07/23.
//

import Foundation

public class WeakRefVirtualProxy<T: AnyObject> {
	private(set) public weak var object: T?
	
	public init(_ object: T) {
		self.object = object
	}
}

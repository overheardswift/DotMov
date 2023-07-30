//
//  MainQueueDispatchDecorator.swift
//  DMCommon
//
//  Created by Bayu Kurniawan on 31/07/23.
//

import Foundation

public final class MainQueueDispatchDecorator<T> {
	private(set) public var decoratee: T
	
	public init(_ decoratee: T) {
		self.decoratee = decoratee
	}
	
	public func dispatch(completion: @escaping () -> Void) {
		guard Thread.isMainThread else {
			return DispatchQueue.main.async(execute: completion)
		}
		
		completion()
	}
}

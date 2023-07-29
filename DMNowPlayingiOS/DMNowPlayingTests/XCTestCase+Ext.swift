//
//  XCTestCase+Ext.swift
//  DMNowPlayingTests
//
//  Created by Bayu Kurniawan on 29/07/23.
//
import XCTest

extension XCTestCase {
    
    func makeURL(_ urlString: String = "https://any-url.xyz", file: StaticString = #file, line: UInt = #line) -> URL {
        guard let url = URL(string: urlString) else {
            preconditionFailure("Failed to create URL with \(urlString)", file: file, line: line)
        }
        return url
    }
    
    func makeData(isEmpty: Bool = false) -> Data {
        return isEmpty ? Data() : Data("any data".utf8)
    }
    
    func makeError(_ message: String = "Something went wrong") -> NSError {
        return NSError(domain: "TEST_ERROR", code: -9999, userInfo: nil)
    }
    
    func checkForMemoryLeaks(_ object: AnyObject, file: StaticString = #file, line: UInt = #line) {
        addTeardownBlock { [weak object] in
            XCTAssertNil(object, "Instance or object should have been deallocated. Potential memory leak.", file: file, line: line)
        }
    }
}

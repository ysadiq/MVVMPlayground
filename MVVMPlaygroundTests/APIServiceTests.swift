//
//  APIServiceTests.swift
//  MVVMPlaygroundTests
//
//  Created by Yahya Saddiq on 2/1/20.
//  Copyright © 2020 ysaddiq. All rights reserved.
//

import XCTest
@testable import MVVMPlayground

class APIServiceTests: XCTestCase {
    var sut: APIService!

    override func setUp() {
        super.setUp()
        sut = APIService()
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func test_fetch_popular_photos() {
        // Given
        let promise = XCTestExpectation(description: "Fetch photos completed")
        var responseError: Error?
        var responsePhotos: [Photo]?

        // When
        guard let bundle = Bundle.unitTest.path(forResource: "stub", ofType: "json") else {
            XCTFail("Error: content not found")
            return
        }
        
        sut.fetchPhotos(from: URL(fileURLWithPath: bundle), complete: { (photos, error) in
            responseError = error
            responsePhotos = photos
            promise.fulfill()
        })
        wait(for: [promise], timeout: 1)

        // Then
        XCTAssertNil(responseError)
        XCTAssertNotNil(responsePhotos)
    }
}

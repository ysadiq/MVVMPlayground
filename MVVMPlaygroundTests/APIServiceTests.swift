//
//  APIServiceTests.swift
//  MVVMPlaygroundTests
//
//  Created by Neo on 01/10/2017.
//  Copyright © 2017 ST.Huang. All rights reserved.
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
        // 1
        let promise = XCTestExpectation(description: "Fetch photos completed")

        // When
        sut.fetchPopularPhoto(complete: { (photos, error) in
            // Then
            guard error == nil,
                let photos = photos else {
                    if let errorDesc = error?.rawValue {
                        XCTFail("Error: \(errorDesc)")
                    }
                    return
            }
            
            XCTAssertEqual(photos.count, 20)
            for photo in photos {
                XCTAssertNotNil(photo.id)
            }

            // 2
            promise.fulfill()
        })

        // 3
        wait(for: [promise], timeout: 3.1)
    }

    func test_fetch_popular_photos_completes() {
        // Given
        let promise = XCTestExpectation(description: "Fetch photos completed")
        var responseError: Error?
        var responsePhotos: [Photo]?

        // When
        sut.fetchPopularPhoto(complete: { (photos, error) in
            responseError = error
            responsePhotos = photos
            promise.fulfill()
        })
        wait(for: [promise], timeout: 3.1)

        // Then
        XCTAssertNil(responseError)
        XCTAssertEqual(responsePhotos?.count, 20)
    }
}

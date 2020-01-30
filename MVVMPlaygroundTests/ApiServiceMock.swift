//
//  ApiServiceMock.swift
//  MVVMPlaygroundTests
//
//  Created by Yahya Saddiq on 10/1/19.
//  Copyright © 2019 ST.Huang. All rights reserved.
//

import Foundation
@testable import MVVMPlayground

class ApiServiceMock: APIServiceProtocol {

    var isFetchPopularPhotoCalled = false

    var completePhotos: [Photo] = [Photo]()
    var completeClosure: (([Photo]?, Error?) -> ())!

    func fetchPopularPhoto(complete: @escaping ([Photo]?, Error?) -> ()) {
        isFetchPopularPhotoCalled = true
        completeClosure = complete
    }

    func fetchSuccess() {
        completeClosure(completePhotos, nil)
    }

    func fetchFail(error: APIError?) {
        completeClosure(nil, error)
    }
}

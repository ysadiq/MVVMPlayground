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
    var completeClosure: ((Bool, [Photo], APIError?) -> ())!

    func fetchPopularPhoto(complete: @escaping (Bool, [Photo], APIError?) -> ()) {
        isFetchPopularPhotoCalled = true
        completeClosure = complete
    }

    func fetchSuccess() {
        completeClosure(true, completePhotos, nil)
    }

    func fetchFail(error: APIError?) {
        completeClosure(false, completePhotos, error)
    }

}

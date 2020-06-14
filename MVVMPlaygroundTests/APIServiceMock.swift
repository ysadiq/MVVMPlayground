//
//  APIServiceMock.swift
//  MVVMPlaygroundTests
//
//  Created by Yahya Saddiq on 2/1/20.
//  Copyright © 2020 ysaddiq. All rights reserved.
//

import Foundation
@testable import MVVMPlayground
// The mock APIService(APIServiceMock) object doesn’t connect to the real server,
// it’s an object designed only for the test.
// Both APIServiceand APIServiceMock conform to APIServiceProtocol,
// so that we are able to inject different dependency in different situation.
class APIServiceMock: APIServiceProtocol{
    var isFetchPopularPhotoCalled = false

    var completePhotos: [Photo] = [Photo]()
    var completeClosure: (([Photo]?, APIError?) -> ())!

    func fetchPopularPhoto(from url: URL?, complete: @escaping ([Photo]?, APIError?) -> ()) {
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

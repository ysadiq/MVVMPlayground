//
//  StubGenerator.swift
//  MVVMPlaygroundTests
//
//  Created by Yahya Saddiq on 10/1/19.
//  Copyright © 2019 ysaddiq. All rights reserved.
//

import Foundation
@testable import MVVMPlayground

class StubGenerator {
    func stubPhotos() -> [Photo] {
        let path = Bundle.unitTest.path(forResource: "content(stub)", ofType: "json")!
        let data = try! Data(contentsOf: URL(fileURLWithPath: path))
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        let photos = try! decoder.decode(Photos.self, from: data)
        return photos.photos
    }
}

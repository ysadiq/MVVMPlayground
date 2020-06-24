//
//  StubGenerator.swift
//  MVVMPlaygroundTests
//
//  Created by Yahya Saddiq on 6/24/20.
//  Copyright © 2020 ysaddiq. All rights reserved.
//

import Foundation
@testable import MVVMPlayground

class StubGenerator {
    func stubPhotos() -> [Photo]? {
        guard let path = Bundle.unitTest.path(forResource: "stub", ofType: "json"),
            let data = try? Data(contentsOf: URL(fileURLWithPath: path)) else {
                return nil
        }

        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        let photos = try? decoder.decode(Photos.self, from: data)
        return photos?.photos
    }
}

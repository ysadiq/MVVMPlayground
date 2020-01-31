//
//  APIService.swift
//  MVVMPlayground
//
//  Created by Neo on 01/10/2017.
//  Copyright © 2017 ST.Huang. All rights reserved.
//

import Foundation

enum APIError: String, Error {
    case noNetwork = "No Network"
    case serverOverload = "Server is overloaded"
    case permissionDenied = "You don't have permission"
    case notFound = "Page Not Found"
}

protocol APIServiceProtocol {
    func fetchPopularPhoto(complete: @escaping (_ photos: [Photo]?, _ error: APIError?)->())
}

class APIService: APIServiceProtocol {
    // Simulate a long waiting for fetching 
    func fetchPopularPhoto(complete: @escaping (_ photos: [Photo]?, _ error: APIError?)->()) {
        DispatchQueue.global().async {
            sleep(3)
            guard let path = Bundle.main.path(forResource: "content", ofType: "json") else {
                complete(nil, APIError.notFound)
                return
            }
            let data = try! Data(contentsOf: URL(fileURLWithPath: path))
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            let photos = try! decoder.decode(Photos.self, from: data)
            complete(photos.photos, nil)
        }
    }
}








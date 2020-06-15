//
//  APIService.swift
//  MVVMPlayground
//
//  Created by Yahya Saddiq on 01/10/2017.
//  Copyright © 2017 ysaddiq. All rights reserved.
//

import Foundation

enum APIError: String, Error {
    case noNetwork = "No Network"
    case serverOverload = "Server is overloaded"
    case permissionDenied = "You don't have permission"
    case notFound = "Page Not Found"
}

class APIService: APIServiceProtocol {
    func fetchPhotos(from url: URL?,
                     complete: @escaping (_ photos: [Photo]?, _ error: APIError?)->()) {
        guard let url = url else {
            complete(nil, .notFound)
            return
        }

        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else { return }
            do {
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .iso8601
                let photos = try decoder.decode(Photos.self, from: data)
                complete(photos.photos, nil)
            } catch {
                complete(nil, .notFound)
            }
        }.resume()
    }

    static func popularPhotoURL() -> URL? {
        URL(string: "https://pastebin.com/raw/Ugjx0B3u")
    }
}



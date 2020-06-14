//
//  APIServiceProtocol.swift
//  MVVMPlayground
//
//  Created by Yahya Saddiq on 6/14/20.
//  Copyright © 2020 ysaddiq. All rights reserved.
//

import Foundation

protocol APIServiceProtocol {
    func fetchPopularPhoto(from url: URL?, complete: @escaping (_ photos: [Photo]?, _ error: APIError?)->())
}

extension APIServiceProtocol {
    func fetchPopularPhoto(complete: @escaping (_ photos: [Photo]?, _ error: APIError?)->()) {
        fetchPopularPhoto(from: APIService.popularPhotoURL(), complete: complete)
    }
}

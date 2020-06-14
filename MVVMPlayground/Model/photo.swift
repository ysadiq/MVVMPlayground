//
//  Event.swift
//  MVVMPlayground
//
//  Created by Yahya Saddiq on 01/10/2017.
//  Copyright © 2017 ysaddiq. All rights reserved.
//

import Foundation
struct Photos: Codable {
    let photos: [Photo]
}

struct Photo: Codable {
    let id: Int
    let name: String
    let description: String?
    let created_at: Date
    let image_url: String
    let for_sale: Bool
    let camera: String?
}

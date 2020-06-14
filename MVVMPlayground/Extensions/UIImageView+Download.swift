//
//  UIImageView+Download.swift
//  MVVMPlayground
//
//  Created by Yahya Saddiq on 6/14/20.
//  Copyright © 2020 ST.Huang. All rights reserved.
//

import UIKit

extension UIImageView {
    func download(from url: URL?) {
        guard let url = url else {
            return
        }

        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data, error == nil else { return }
            print(response?.suggestedFilename ?? url.lastPathComponent)
            DispatchQueue.main.async() { [weak self] in
                self?.image = UIImage(data: data)
            }
        }.resume()
    }
}

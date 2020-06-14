//
//  UIImageView+Download.swift
//  MVVMPlayground
//
//  Created by Yahya Saddiq on 6/14/20.
//  Copyright © 2020 ST.Huang. All rights reserved.
//

import UIKit

extension UIImageView {
    func download(from urlString: String?) {
        guard let urlString = urlString,
            let url = URL(string: urlString) else {
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

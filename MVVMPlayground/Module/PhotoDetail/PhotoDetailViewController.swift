//
//  PhotoDetailViewController.swift
//  MVVMPlayground
//
//  Created by Neo on 03/10/2017.
//  Copyright © 2017 ST.Huang. All rights reserved.
//

import UIKit

class PhotoDetailViewController: UIViewController {

    var imageUrl: String?
    
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let imageUrl = imageUrl {
            imageView.sd_setImage(with: URL(string: imageUrl), completed: nil)
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

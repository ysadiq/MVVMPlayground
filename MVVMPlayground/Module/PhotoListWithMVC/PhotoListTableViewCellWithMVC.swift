//
//  PhotoListTableViewCellWithMVC.swift
//  MVVMPlayground
//
//  Created by Yahya Saddiq on 10/1/19.
//  Copyright © 2019 ST.Huang. All rights reserved.
//

import Foundation
import UIKit

class PhotoListTableViewCellWithMVC: UITableViewCell {
    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descContainerHeightConstraint: NSLayoutConstraint!
}

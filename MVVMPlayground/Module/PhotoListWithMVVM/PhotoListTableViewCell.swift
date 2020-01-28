//
//  PhotoListTableViewCell.swift
//  MVVMPlayground
//
//  Created by Yahya Saddiq on 10/1/19.
//  Copyright © 2019 ST.Huang. All rights reserved.
//

import Foundation
import UIKit

class PhotoListTableViewCell: UITableViewCell {
    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descContainerHeightConstraint: NSLayoutConstraint!
    var photoListCellViewModel : PhotoListCellViewModel? {
        didSet {
            nameLabel.text = photoListCellViewModel?.titleText
            descriptionLabel.text = photoListCellViewModel?.descText
            mainImageView?.sd_setImage(with: URL(string: photoListCellViewModel?.imageUrl ?? ""), completed: nil)
            dateLabel.text = photoListCellViewModel?.dateText
        }
    }
}

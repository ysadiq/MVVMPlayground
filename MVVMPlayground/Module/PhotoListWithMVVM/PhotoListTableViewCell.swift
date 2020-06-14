//
//  PhotoListTableViewCell.swift
//  MVVMPlayground
//
//  Created by Yahya Saddiq on 10/1/19.
//  Copyright © 2019 ysaddiq. All rights reserved.
//

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
            dateLabel.text = photoListCellViewModel?.dateText
            mainImageView?.download(from: photoListCellViewModel?.imageUrl)
        }
    }
}

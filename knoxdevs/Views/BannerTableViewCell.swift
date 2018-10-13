//
//  BannerTableViewCell.swift
//  knoxdevs
//
//  Created by Gavin on 10/13/18.
//  Copyright © 2018 Gavin Wiggins. All rights reserved.
//

import UIKit

class BannerTableViewCell: UITableViewCell {
    
    @IBOutlet weak var bannerImageView: UIImageView!
    @IBOutlet weak var groupName: UILabel!
    @IBOutlet weak var groupTags: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

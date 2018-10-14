//
//  LocationTableViewCell.swift
//  knoxdevs
//
//  Created by Gavin on 10/10/18.
//  Copyright © 2018 Gavin Wiggins. All rights reserved.
//

import UIKit
import MapKit
import SafariServices

class LocationTableViewCell: UITableViewCell {

    var locationUrl: URL?
    var parentVC: UIViewController?

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var locationLabel: UILabel!
    
    @IBAction func showWebsite(_ sender: UIButton) {
        guard let parentVC = parentVC, let url = locationUrl else { return }
        let safariVC = SFSafariViewController(url: url)
        parentVC.present(safariVC, animated: true, completion: nil)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
}

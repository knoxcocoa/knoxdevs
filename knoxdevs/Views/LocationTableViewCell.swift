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

    var locationAnnotation: MKAnnotation?
    var locationUrl: URL?
    var parentVC: UIViewController?

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var locationLabel: UILabel!
    
    @IBAction func showWebsite(_ sender: UIButton) {
        guard let parentVC = parentVC, let url = locationUrl else { return }
        let safariVC = SFSafariViewController(url: url)
        safariVC.preferredBarTintColor = Theme.tableBgColor
        parentVC.present(safariVC, animated: true, completion: nil)
    }
    
    @IBAction func showDirections(_ sender: UIButton) {
        guard let annotation = locationAnnotation else { return }
        let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: annotation.coordinate))
        mapItem.name = annotation.title ?? "Meetup"
        mapItem.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving])
    }

}

//
//  GroupLocationViewModel.swift
//  knoxdevs
//
//  Created by Gavin on 12/08/18.
//  Copyright © 2018 Gavin Wiggins. All rights reserved.
//

import Foundation
import MapKit

struct GroupLocationViewModel {

    let description: String
    let region: MKCoordinateRegion
    let annotation: MKPointAnnotation
    let website: URL

    init(location: Location) {
        let lat = location.latitude
        let lon = location.longitude
        let desc = "\(location.name)\n\(location.address)\n\(lat), \(lon)"
        self.description = desc

        var region = MKCoordinateRegion()
        region.center = CLLocationCoordinate2D(latitude: lat, longitude: lon)
        region.span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        self.region = region

        let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lon)
        annotation.title = location.name
        self.annotation = annotation

        let url = URL(string: location.website)
        self.website = url!
    }
}

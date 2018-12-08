//
//  LocationAnnotation.swift
//  knoxdevs
//
//  Created by Gavin on 12/8/18.
//  Copyright © 2018 Gavin Wiggins. All rights reserved.
//

import Foundation
import MapKit

class LocationAnnotation: NSObject, MKAnnotation {
    
    let coordinate: CLLocationCoordinate2D
    let title: String?
    let subtitle: String?
    
    init(location: Location) {
        self.coordinate = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
        self.title = location.name
        self.subtitle = "Tap for directions"
    }
}

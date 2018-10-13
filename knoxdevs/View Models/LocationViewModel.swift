//
//  LocationViewModel.swift
//  knoxdevs
//
//  Created by Gavin on 10/11/18.
//  Copyright © 2018 Gavin Wiggins. All rights reserved.
//

import Foundation

struct LocationViewModel {

    let id: Int64
    let description: String
    let latitude: Double
    let longitude: Double
    let website: URL?

    init(location: Location) {
        self.id = location.id
        var desc: String = location.name
        
        if let address = location.address {
            desc.append("\n\(address)")
        } else {
            desc.append("\nKnoxville, TN")
        }
        
        if let lat = location.latitude, let lon = location.longitude {
            desc.append("\n\(lat), \(lon)")
            self.latitude = lat
            self.longitude = lon
        } else {
            desc.append("\n\(35.972778), \(-83.942222)")
            self.latitude = 35.972778
            self.longitude = -83.942222
        }
        self.description = desc
        
        if let web = location.website, let url = URL(string: web) {
            self.website = url
        } else {
            self.website = nil
        }
    }
}

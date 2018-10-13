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
    let name: String
    let address: String
    let latitude: Double
    let longitude: Double
    let website: URL?

    init(location: Location) {
        self.id = location.id
        self.name = location.name
        
        if let address = location.address {
            self.address = address
        } else {
            self.address = "Knoxville, TN"
        }
        
        if let lat = location.latitude, let lon = location.longitude {
            self.latitude = lat
            self.longitude = lon
        } else {
            self.latitude = 35.972778
            self.longitude = -83.942222
        }
        
        if let web = location.website, let url = URL(string: web) {
            self.website = url
        } else {
            self.website = nil
        }
    }
}

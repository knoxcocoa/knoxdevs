//
//  LocationViewModel.swift
//  knoxdevs
//
//  Created by Gavin on 10/11/18.
//  Copyright © 2018 Gavin Wiggins. All rights reserved.
//

import Foundation
import MapKit

struct LocationViewModel {

    let description: String
    let region: MKCoordinateRegion
    let annotation: MKPointAnnotation
    let website: URL

    init(locationName: String) {
        let sqlitedb = SQLiteDatabase()
        
        do {
            try sqlitedb.open()
        } catch SQLiteError.Path(let message) {
            print("\(message)")
        } catch SQLiteError.Open(let message) {
            print("\(message)")
        } catch {
            print("Unexpected error.")
        }
        
        guard let location = sqlitedb.getLocation(name: locationName) else {
            //let loc = Location(id: 0, name: "none", address: "none", latitude: 0.0, longitude: 0.0, website: "none")
            self.description = "none"
            self.region = MKCoordinateRegion()
            self.annotation = MKPointAnnotation()
            self.website = URL(string: "none")!
            return
        }
        
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
        self.annotation = annotation
        
        let url = URL(string: location.website)
        self.website = url!
    }

//    init(location: Location) {
//        let lat = location.latitude
//        let lon = location.longitude
//        let desc = "\(location.name)\n\(location.address)\n\(lat), \(lon)"
//        self.description = desc
//
//        var region = MKCoordinateRegion()
//        region.center = CLLocationCoordinate2D(latitude: lat, longitude: lon)
//        region.span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
//        self.region = region
//
//        let annotation = MKPointAnnotation()
//        annotation.coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lon)
//        self.annotation = annotation
//
//        let url = URL(string: location.website)
//        self.website = url!
//    }
}

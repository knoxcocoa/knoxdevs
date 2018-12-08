//
//  LocationsViewController.swift
//  knoxdevs
//
//  Created by Gavin on 12/7/18.
//  Copyright © 2018 Gavin Wiggins. All rights reserved.
//

import MapKit
import UIKit

class LocationsViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewWillAppear(_ animated: Bool) {
        view.backgroundColor = Theme.viewBgColor
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchLocations()
    }
    
    // MARK: - SQLite database
    
    private func fetchLocations() {
        let sqlitedb = SQLiteDatabase()
        
        sqlitedb.getLocationAnnotations { [weak self] locations, error in
            if let error = error {
                self?.handleError(error: error)
            }
            if let locations = locations {
                self?.handleLocations(locations: locations)
            }
        }
    }

    private func handleError(error: SQLiteError) {
        var errorMessage = ""
        switch error {
        case .invalidPath(let message):
            errorMessage = "Invalid path \(message)."
        case .failedOpen(let message):
            errorMessage = "Faild to open database \(message)."
        case .invalidQuery(let message):
            errorMessage = "Invalid query \(message)."
        }
        let alertController = UIAlertController(title: "SQLite Error", message: errorMessage, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        DispatchQueue.main.async {
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    private func handleLocations(locations: [LocationAnnotation]) {
        mapView.showAnnotations(locations, animated: false)
    }
    
    // MARK: - Mapview
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        guard let annotation = view.annotation else { return }
        let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: annotation.coordinate))
        mapItem.name = annotation.title ?? "Meetup"
        mapItem.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving])
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        if let location = annotation as? LocationAnnotation {
            let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "Location")
                ?? MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: "Location")
            annotationView.annotation = location
            annotationView.canShowCallout = true
            annotationView.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            annotationView.clusteringIdentifier = "LocationClustered"
            return annotationView
        } else if let cluster = annotation as? MKClusterAnnotation {
            let clusterView = mapView.dequeueReusableAnnotationView(withIdentifier: "LocationCluster") ?? MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: "LocationCluster")
            clusterView.annotation = cluster
            return clusterView
        } else {
            return nil
        }
    }

}

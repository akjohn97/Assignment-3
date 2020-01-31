//
//  MapViewController.swift
//  City2City-J22
//
//  Created by mac on 1/30/20.
//  Copyright © 2020 mac. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    var city: City!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMap()
    }
    
    private func setupMap() {
  
        let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: city.latitude, longitude: city.longitude), latitudinalMeters: 10000, longitudinalMeters: 10000)
        mapView.region = region
        

        let annote = MKPointAnnotation()
        annote.coordinate = CLLocationCoordinate2D(latitude: city.latitude, longitude: city.longitude)
        annote.title = "\(city.name), \(city.state)"
        annote.subtitle = "You Are Here"
        mapView.addAnnotation(annote)
    }
 

}
